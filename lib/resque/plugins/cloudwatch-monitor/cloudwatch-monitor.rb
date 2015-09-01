module Resque
  module Plugins

    module CloudwatchMonitor

      #Cloudwatch Custom Metric Namespace
      def namespace
        Configuration.namespace
      end

      #Cloudwatch Custom Metric Namespace For Failed Jobs
      def fail_namespace
        Configuration.fail_namespace
      end

      #Cloudwatch Custom Metric Namespace For Before Performed Jobs
      def perform_namespace
        Configuration.perform_namespace
      end

      #Cloudwatch metric name
      def metric_name
        @queue || queue
      end

      #Array of dimensions for Cloudwatch
      def dimensions(*args)
        []
      end

      #Metric timestamp
      def timestamp
        Time.now.iso8601
      end

      #Cloudwatch metric unit type
      def unit
        'Count'
      end

      #Cloudwatch metric value
      def value
        1
      end

      #Job on failure hook. receives the job arguments and the exception
      def on_failure_report_cw(e, *args)
        report_dimensions = dimensions(*args)
        report(fail_namespace, metric_name, report_dimensions)
      end

      def before_perform_report_cw(*args)
        report_dimensions = dimensions(*args)
        report(perform_namespace, metric_name, report_dimensions)
      end

      private
      def report(report_namespace, metric_name, report_dimensions)
        report_dimensions ||= []
        report_dimensions.delete_if{|key| key[:value].nil? || key[:name].nil? }
        metric_data = {
            metric_name: metric_name.to_s,
            dimensions: report_dimensions,
            timestamp: timestamp,
            value: value,
            unit: unit.to_s
        }
        report_namespace ||= namespace
        #Send to metrics. One general of the queue and another one with dimensions if custom dimensions
        metrics_to_send = report_dimensions.empty? ? [metric_data] : [metric_data, metric_data.merge(dimensions: [])]

        Configuration.cloudwatch_client.put_metric_data(namespace: report_namespace, metric_data: metrics_to_send)
      end
    end
  end
end