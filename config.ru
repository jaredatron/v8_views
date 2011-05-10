require "rubygems"
require "bundler/setup"

require 'pp'
require 'rack/lint'
require 'lib/v8_views'
require 'app'

use Rack::Lint
use V8Views
run App
