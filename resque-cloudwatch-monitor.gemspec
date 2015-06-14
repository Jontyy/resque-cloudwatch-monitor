$:.push File.expand_path('../lib', __FILE__)
require 'resque/plugins/cloudwatch-monitor/version'
Gem::Specification.new do |s|
  s.name                = 'resque-cloudwatch-monitor'
  s.version             = Resque::Plugins::CloudwatchMonitor::VERSION
  s.date                = Time.now.strftime('%Y-%m-%d')
  s.summary             = 'Send Resque Failures To AWS CloudWatch'
  s.email               = 'avichay@yotpo.com'
  s.homepage            = 'https://github.com/YotpoLtd/resque-cloudwatch-monitor'
  s.description         = 'Allows reporting failures of resque jobs to Amazon CloudWatch'
  s.has_rdoc            = false
  s.require_paths       = ['lib']
  s.authors             = ['Yotpo/avichay@yotpo']
  s.files               = ['README.md', 'resque-cloudwatch-monitor.gemspec', 'LICENSE']
  s.files               += Dir['**/*.rb']
  s.license             = 'MIT'

  s.add_dependency 'resque', '~> 1.25'
  s.add_dependency 'aws-sdk'
  s.add_development_dependency 'rake', '~> 10.3'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'timecop'
end