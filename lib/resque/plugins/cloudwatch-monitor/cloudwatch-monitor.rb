module Resque
  module Plugins

    module CloudwatchMonitor

      #Cloudwatch Custom Metric Namespace
      def namespace
        Configuration.namespace
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
      def on_failure(e, *args)

        dimensions = dimensions(*args)

        metric_data = {
            metric_name: metric_name.to_s,
            dimensions: dimensions,
            timestamp: timestamp,
            value: value,
            unit: unit.to_s
        }

        #Send to metrics. One general of the queue and another one with dimensions if custom dimensions
        metrics_to_send = dimensions.empty? ? [metric_data] : [metric_data, metric_data.merge(dimensions: [])]

        Configuration.cloudwatch_client.put_metric_data(namespace: namespace, metric_data: metrics_to_send)
      end
    end
  end
end