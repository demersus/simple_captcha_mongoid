require 'digest/sha1'

module SimpleCaptcha #:nodoc
  module Utils #:nodoc

    private

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
