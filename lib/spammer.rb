$:.unshift File.dirname(__FILE__)

require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

require 'features'
require 'message'
require 'preclassified_message'
require 'spam_detector'
