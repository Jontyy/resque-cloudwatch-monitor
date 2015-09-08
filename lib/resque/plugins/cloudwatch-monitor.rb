module Resque
  module Plugins

    module CloudwatchMonitor

      def get_namespace(type)
        Configuration.get_namespace_for(type)
      end

      def should_report?(type)
        Configuration.should_report?(type)
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

      Configuration.event_list.each do |type|
        define_method("#{type}_report_cw") do |e, *args|
          report(type, *args)
        end
      end

      private
      def report(type, *args)
        return unless should_report?(type)
        report_dimensions = dimensions(*args)
        report_dimensions ||= []
        report_dimensions.delete_if{|key| key[:value].nil? || key[:name].nil? }
        metric_data = {
            metric_name: metric_name.to_s,
            dimensions: report_dimensions,
            timestamp: timestamp,
            value: value,
            unit: unit.to_s
        }
        report_namespace = get_namespace(type)
        #Send to metrics. One general of the queue and another one with dimensions if custom dimensions
        metrics_to_send = report_dimensions.empty? ? [metric_data] : [metric_data, metric_data.merge(dimensions: [])]

        Configuration.cloudwatch_client.put_metric_data(namespace: report_namespace, metric_data: metrics_to_send)
      end
    end
  end
end