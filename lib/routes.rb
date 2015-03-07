module LightBlog
  class Routes < Sinatra::Application
    get '/' do
      erb :index, layout: true
    end
  end
end
