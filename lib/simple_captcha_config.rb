require 'digest/sha1'

module SimpleCaptcha #:nodoc
  
  #--
  # The configuration constants have been set here.
  # * CAPTCHA_IMAGE_PATH
  # The simple captcha's images will be stored here,
  # the default is /public/images/captcha/.
  # * CAPTCHA_DATA_PATH
  # The simple captcha's session data wil be stored here, the default is /tmp/captcha/.
  # 
  # The path can be modified as needed.
  # The same modification is also required in the rake file.
  module Config #:nodoc
    
    CAPTCHA_IMAGE_PATH = "#{RAILS_ROOT}/public/images/simple_captcha/"
    CAPTCHA_DATA_PATH = "#{RAILS_ROOT}/tmp/simple_captcha/"
    
  end
  
  module ConfigTasks #:nodoc
    
    include Config
    
    def create_captcha_directories #:nodoc
      Dir.mkdir(CAPTCHA_DATA_PATH) unless File.exist?(CAPTCHA_DATA_PATH)
      Dir.mkdir(CAPTCHA_IMAGE_PATH) unless File.exist?(CAPTCHA_IMAGE_PATH)
    end
    
    def create_code #:nodoc
      captcha_hash_string = "simple captcha by sur http://expressica.com"
      Digest::SHA1.hexdigest(captcha_hash_string + session.session_id + captcha_hash_string)
    end
    
    private :create_code
    
  end
  
  
end
