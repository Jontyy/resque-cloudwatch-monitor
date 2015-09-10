module Resque
  module Plugins
    module CloudwatchMonitor
      module Configuration
        class << self

          attr_accessor :cloudwatch_client

          @@report_on = {
              before_perform: false,
              after_perform: false,
              on_failure: false,
              after_enqueue: false,
              before_enqueue: false,
              after_dequeue: false,
              before_dequeue: false
          }

          @@report_namespace = {
              before_perform: 'Resque before_perform',
              after_perform: 'Resque after_perform',
              on_failure: 'Resque on_failure',
              after_enqueue: 'Resque after_enqueue',
              before_enqueue: 'Resque before_enqueue',
              after_dequeue: 'Resque after_dequeue',
              before_dequeue: 'Resque before_dequeue'
          }
          def configure
            yield self
          end

          def should_report?(type)
            @@report_on[type]
          end

          def do_not_report_on(type)
            @@report_on[type] = false
          end

          def report_on(type)
            @@report_on[type] = true
          end

          def get_namespace_for(type)
            @@report_namespace[type]
          end

          def set_namespace_for(type, namespace)
            @@report_namespace[type] = namespace
          end

          def event_list
            @@report_on.keys
          end
        end
      end
    end
  end
end