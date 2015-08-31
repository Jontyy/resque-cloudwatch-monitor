resque-cloudwatch-monitor
============
[![Build Status](https://travis-ci.org/YotpoLtd/resque-cloudwatch-monitor.svg)](https://travis-ci.org/YotpoLtd/resque-cloudwatch-monitor)
[![Code Climate](https://codeclimate.com/github/YotpoLtd/resque-cloudwatch-monitor/badges/gpa.svg)](https://codeclimate.com/github/YotpoLtd/resque-cloudwatch-monitor)
[![Test Coverage](https://codeclimate.com/github/YotpoLtd/resque-cloudwatch-monitor/badges/coverage.svg)](https://codeclimate.com/github/YotpoLtd/resque-cloudwatch-monitor/coverage)

A [Resque][rq] plugin. Requires Resque ~> 1.25

This gem provides Cloudwatch reports of failed Resque jobs

  * Redis backed retry count/limit.


Install & Quick Start
---------------------

To install:

    $ gem install resque-cloudwatch-monitor

If you're using [Bundler][bundler] to manage your dependencies, you should add `gem
'resque-cloudwatch-monitor'` to your projects `Gemfile`.


Use the plugin:
