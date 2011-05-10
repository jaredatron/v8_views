require 'sinatra/base'
require 'JSON'

class App < Sinatra::Base

  get '/posts' do
    content_type 'application/json'
    {
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
    }.to_json
  end

end
