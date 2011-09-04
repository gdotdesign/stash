require "rubygems"
require "bundler/setup"
Bundler.require(:default)

class Site < Sinatra::Application
  set :server, %w[thin]
  set :environment, :development 
  set :views, File.dirname(__FILE__) + "/views"
  set :root, File.dirname(__FILE__)
  set :public, Proc.new { File.join(root, "public") }
  set :haml, {:ugly=>true} 
  
  get "/site.js" do
    CoffeeScript.compile File.read("../Source/Stash.coffee")+File.read("views/site.coffee")
  end
  
  get "/style.css" do
    sass :"style"
  end
  
  get "/" do
    haml :index
  end
  
end
