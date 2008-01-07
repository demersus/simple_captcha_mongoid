# Copyright (c) 2008 [Sur http://expressica.com]

class SimpleCaptchaController < ApplicationController

  include SimpleCaptcha::ImageHelpers

  def get_simple_captcha_image  #:nodoc
    send_data(
      generate_simple_captcha_image(:image_style => params[:image_style], 
        :distortion => params[:distortion]), 
      :type => 'image/jpeg', 
      :disposition => 'inline', 
      :filename => 'simple_captcha.jpg')
  end

end
