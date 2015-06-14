require 'spec_helper'
describe Resque::Plugins::CloudwatchMonitor do

  before(:all) do
    Resque.redis.flushall
    @worker = Resque::Worker.new('*')
    @worker.register_worker

    Timecop.freeze(Time.now)

    @metric_data = {
        metric_name: 'Failure',
        dimensions: [],
        timestamp: Time.now.iso8601,
        value: 1,
        unit: 'Count'
    }

  end

  after(:all) do
    Timecop.return
  end

  it 'failure in resque job sends metric to cloudwatch' do
    expect(Resque::Plugins::CloudwatchMonitor::Configuration.cloudwatch_client).
        to receive(:put_metric_data).
        with(namespace: 'Resque Failures', metric_data: [@metric_data])

    Resque.enqueue(FailureJobTest, :fail)
    CloudWatchMonitorTest.perform_enqueued_job(@worker)
  end

  it 'failure in resque job sends custom dimensions' do
    class FailureJobTest
      def self.dimensions(*args)
        [{name: 'Custom', value: args.first.to_s}]
      end
    end

    # allow(FailureJobTest).to receive(:dimensions) {[{name: 'Custom', value: 'fail'}] }

    expect(Resque::Plugins::CloudwatchMonitor::Configuration.cloudwatch_client).
        to receive(:put_metric_data).
        with(namespace: 'Resque Failures', metric_data: [@metric_data.merge(dimensions: [{name: 'Custom', value: 'fail'}]), @metric_data])

    Resque.enqueue(FailureJobTest, :fail)
    CloudWatchMonitorTest.perform_enqueued_job(@worker)
  end

  it 'successful job does not send a metric to cloudwatch' do
    expect(Resque::Plugins::CloudwatchMonitor::Configuration.cloudwatch_client).
        to receive(:put_metric_data).
        exactly(0).times

    Resque.enqueue(SuccessJobTest, :success)
    CloudWatchMonitorTest.perform_enqueued_job(@worker)
  end
end