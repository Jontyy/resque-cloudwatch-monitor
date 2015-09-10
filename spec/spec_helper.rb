require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require 'aws'
require 'timecop'
require 'resque-cloudwatch-monitor'

RSpec.configure do |config|
  # some (optional) config here
end

class CloudWatchMonitorTest
  def self.perform_enqueued_job(worker)
    job = worker.reserve
    worker.perform(job)
    worker.done_working
  end
end

Resque::Plugins::CloudwatchMonitor::Configuration.configure do |config|
  config.set_namespace_for(:on_failure, 'Resque Failures')
  config.set_namespace_for(:after_perform, 'Resque Success')
  config.set_namespace_for(:before_perform, 'Resque Perform')
  config.report_on(:on_failure)
  config.report_on(:after_perform)
  config.report_on(:before_perform)

  config.cloudwatch_client = AWS::CloudWatch::Client.new
end

class FailureJobTest
  extend Resque::Plugins::CloudwatchMonitor
  @queue = 'FailingQueue'

  def self.perform(*args)
    raise Exception.new('Test Error')
  end
end

class SuccessJobTest
  extend Resque::Plugins::CloudwatchMonitor
  @queue = 'SuccessfulQueue'

  def self.perform(*args)
    1 + 1
  end
end