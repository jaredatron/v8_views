# $:.unshift ::File.join(File.dirname(__FILE__), 'lib')

require "rubygems"
require "bundler/setup"

require 'pp'
require 'rack/lint'
require 'lib/v8_views'
require 'JSON'

use Rack::Lint
use V8Views, :thins => 12

# mock app
run Proc.new { |env|

  data = {
    :_render => {
      :layout   => 'application',
      :template => 'posts/index',
    },
    :page_title => 'My Awesome Example Blog',
    :blog_title => 'My Awesome Example Blog',
    :posts => [
      'post one',
      'post due',
      'post tres'
    ],
  }

  [200, {"Content-Type" => "application/json"}, [data.to_json]]
}

