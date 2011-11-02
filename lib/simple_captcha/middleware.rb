# encoding: utf-8
module SimpleCaptcha
  class Middleware
    include SimpleCaptcha::ImageHelpers
    
    def initialize(app, options={})
      @app = app
      self
    end
    
    def call(env) # :nodoc:
      if env["REQUEST_METHOD"] == "GET" && captcha_path?(env['PATH_INFO'])
        make_image(env)
      else
        @app.call(env)
      end
    end
    
    protected
      def make_image(env, body = '', status = 404)
        request = Rack::Request.new(env)
        code = request.params["code"]
        
        if !code.blank? && Utils::simple_captcha_value(code)
          status = 200
          body = generate_simple_captcha_image(code)
          body = File.open(body, "rb")
        end
        
        [status, {'Content-Type' => 'image/jpeg', 'Content-Length' => body.size.to_s}, body]
      end
      
      def captcha_path?(request_path)
        request_path.include?('/simple_captcha')
      end
  end
end
