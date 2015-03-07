module LightBlog
  module Index
    class Show < Sinatra::Application
      get '/' do
         erb :index, layout: true
      end
    end
  end
end
