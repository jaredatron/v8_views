require 'v8'

class V8Views

  class TemplateNotFoundError < StandardError; end

  MUSTACHE_PATH = __FILE__.sub(/\.rb$/,'/mustache.js')

  DEFAULT_OPTIONS = {
    :root  => File.expand_path(File.join(File.dirname(__FILE__), '..')),
    :views => 'views'
  }

  def initialize app, options={}
    @app = app
    @options = DEFAULT_OPTIONS.merge(options)
  end

  def call env
    return @app.call(env)  unless env["HTTP_ACCEPT"] =~ %r[text/html]
    status, header, body = @app.call(env.merge("HTTP_ACCEPT" => "application/json"))
    return [status, header, body]  unless header["Content-Type"] == "application/json"
    header["Content-Type"] = "text/html"
    return [status, header, render(body.first)]
  end

  private

  def render json
    context.eval "TEMPLATES.render(#{json});"
  end

  def context
    @context or begin
      @context = V8::Context.new
      @context.load MUSTACHE_PATH
      @context['TEMPLATES'] = TemplateStore.new File.join(@options[:root], @options[:views])
      @context.eval <<-JS
        TEMPLATES.render = function(view){
          var layout, template, html;
          template = TEMPLATES.load(view._render.template);
          html = Mustache.to_html(template, view);
          if (view._render.layout){
            layout = TEMPLATES.load('layouts/'+view._render.layout);
            view.yield = html;
            html = Mustache.to_html(layout, view)
          }
          return html;
        }
      JS
    end
    @context
  end

end


class V8Views::TemplateStore
  def initialize path
    @views_path = path
  end
  def load view
    path = File.join(@views_path, view)
    template = Dir[path+'*'].first
    raise V8Views::TemplateNotFoundError, path if template.nil?
    File.read(template)
  end
end
