require 'digest/sha1'

module SimpleCaptcha #:nodoc
  module Utils #:nodoc
    
    private

    # Execute command with params and return output if exit status equal expected_outcodes
    def run(cmd, params = "", expected_outcodes = 0)
      command = %Q[#{cmd} #{params}].gsub(/\s+/, " ")
      command = "#{command} 2>&1"
      
      output = `#{command}`
      
      unless [expected_outcodes].flatten.include?($?.exitstatus)
        raise ::StandardError, "Error while running #{cmd}: #{output}"
      end
      
      output
    end
  
    def simple_captcha_key #:nodoc
      session[:simple_captcha] ||= Digest::SHA1.hexdigest(Time.now.to_s + session[:id].to_s)
    end

    def simple_captcha_value(key = simple_captcha_key) #:nodoc
      SimpleCaptchaData.get_data(key).value rescue nil
    end

    def simple_captcha_passed!(key = simple_captcha_key) #:nodoc
      SimpleCaptchaData.remove_data(key)
    end
  end
end
