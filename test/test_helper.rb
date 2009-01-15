require 'rubygems'
require "mocha"
require "test/spec"
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")
require 'varnish'
$LOAD_PATH << '../'