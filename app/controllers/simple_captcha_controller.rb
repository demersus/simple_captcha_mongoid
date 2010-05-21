class SimpleCaptchaController < ActionController::Base
  include SimpleCaptcha::ImageHelpers

  # GET /simple_captcha
  def show
    send_file(
      generate_simple_captcha_image(
        :image_style => params[:image_style],
        :distortion => params[:distortion], 
        :simple_captcha_key => params[:simple_captcha_key]),
      :type => 'image/jpeg',
      :disposition => 'inline',
      :filename => 'simple_captcha.jpg')
  end
end
