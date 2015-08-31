module Resque
  module Plugins
    module CloudwatchMonitor
      module Configuration
        class << self

          attr_accessor :namespace, :cloudwatch_client, :fail_namespace, :perform_namespace

          def configure
            yield self
          end
        end
      end
    end
  end
end