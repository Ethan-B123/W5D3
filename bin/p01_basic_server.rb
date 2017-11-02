require 'rack'
require 'pry'


  app = Proc.new do |env|
    req = Rack::Request.new(env)
    res = Rack::Response.new
    # p req
    binding.pry
    res['Content-Type'] = 'text/html'
    res.write(req.path)
    res.finish
  end


Rack::Server.start(
  app: app,
  Port: 3000
)
