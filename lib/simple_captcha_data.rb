# Copyright (c) 2008 [Sur http://expressica.com]

class SimpleCaptchaData < ActiveRecord::Base
  set_table_name "simple_captcha_data"
  
  class << self
    def get_data(key)
      data = find_by_key(key) || new
      data.key = key if data.new_record?
      data
    end
    
    def remove_data(key)
      data = find_by_key(key)
      data.destroy if data
    end
  end
  
end
