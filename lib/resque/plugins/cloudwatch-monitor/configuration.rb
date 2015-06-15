module Resque
  module Plugins
    module CloudwatchMonitor
      module Configuration
        class << self

          attr_accessor :namespace, :cloudwatch_client

          def configure
            yield self
          end
        end
      end
    end
  end
end