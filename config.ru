$:.unshift(File.join(File.expand_path(File.dirname(__FILE__)), 'lib'))
require 'app'

run LightBlog::App
