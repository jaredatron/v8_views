require 'rubygems'
require "bundler/setup"
require 'v8'

ROOT_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))
HANDLEBARS_PATH = File.join(ROOT_PATH, 'lib/v8_views/handlebars.js')

HELPERS = <<-JS
  var A_TAG = 'a';
  function link_to(body, url) {
    return "<"+A_TAG+" href='" + url + "'>" + body + "</a>";
  }
  var S='s';
  function pluralize(string){ return string+S; }
JS

class View
  def initialize
    @javascript = V8::Context.new
    @javascript.load HANDLEBARS_PATH
  end
  attr_reader :javascript

  def load_helpers source
    @javascript.eval(scope_helper_source(source))
  end

  def scope_helper_source source

    js = V8::Context.new
    js.eval source

    # eval the source once just to detect what functions are defined =P
    names = js.eval <<-JS
      __helpers = [];
      for (p in this) if (typeof this[p] === "function") __helpers.push(p);
      __helpers;
    JS

    register_helpers = names.map{ |name| %[Handlebars.registerHelper("#{name}", #{name});] }.join("\n")

    <<-JS
      (function(){
        #{source};
        #{register_helpers};
      })();
    JS
  end

end

v = View.new
v.load_helpers HELPERS
v.javascript['puts'] = Proc.new{|s| puts s}
v.javascript.eval <<-JS
  puts(Handlebars.helpers.pluralize('shoe'));
  puts(Handlebars.helpers.link_to('open', 'http://www.open.com'));
JS
