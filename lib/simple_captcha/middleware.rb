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
      def make_image(env, headers = {}, status = 404)
        request = Rack::Request.new(env)
        code = request.params["code"]
        
        if !code.blank? && Utils::simple_captcha_value(code)
          status = 200
          body = generate_simple_captcha_image(code)
          headers['Content-Type'] = 'image/jpeg'
          #body = File.open(body, "rb")
          
          case type = variation(env)
            when 'X-Accel-Redirect'
              path = File.expand_path(body.to_path)
              if url = map_accel_path(env, path)
                headers['Content-Length'] = '0'
                headers[type] = url
                body = []
              else
                env['rack.errors'].puts "X-Accel-Mapping header missing"
              end
            when 'X-Sendfile', 'X-Lighttpd-Send-File'
              path = File.expand_path(body.to_path)
              headers['Content-Length'] = '0'
              headers[type] = path
              body = []
            when '', nil
            else
              env['rack.errors'].puts "Unknown x-sendfile variation: '#{type}'.\n"
          end
        end
        
        [status, headers, body]
      end
      
      def captcha_path?(request_path)
        request_path.include?('/simple_captcha')
      end
      
      def variation(env)
        env['sendfile.type'] || env['HTTP_X_SENDFILE_TYPE']
      end

      def map_accel_path(env, file)
        if mapping = env['HTTP_X_ACCEL_MAPPING']
          internal, external = mapping.split('=', 2).map{ |p| p.strip }
          file.sub(/^#{internal}/i, external)
        end
      end
  end
end
