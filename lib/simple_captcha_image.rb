# Copyright (c) 2008 [Sur http://expressica.com]

require 'rubygems'
require 'RMagick'

module SimpleCaptcha #:nodoc
  module ImageHelpers #:nodoc
    
    include ConfigTasks
    
    IMAGE_STYLES = [
                    'embosed_silver',
                    'simply_red',
                    'simply_green',
                    'simply_blue',
                    'distorted_black',
                    'all_black',
                    'charcoal_grey',
                    'almost_invisible'
                   ]
    
    DISTORTIONS = {
      'low' => [0, 100],
      'medium' => [3, 50],
      'high' => [5, 30]
    }

    private

    def append_simple_captcha_code #:nodoc      
      color = @simple_captcha_image_options[:color]
      text = Magick::Draw.new
      text.annotate(@image, 0, 0, 0, 5, simple_captcha_value) do
        self.font_family = 'arial'
        self.pointsize = 22
        self.fill = color
        self.gravity = Magick::CenterGravity
      end
    end
    
    def set_simple_captcha_image_style #:nodoc
      amplitude, frequency = @simple_captcha_image_options[:distortion]
      case @simple_captcha_image_options[:image_style]
      when 'embosed_silver'
        append_simple_captcha_code
        @image = @image.wave(amplitude, frequency).shade(true, 20, 60)
      when 'simply_red'
        @simple_captcha_image_options[:color] = 'darkred'
        append_simple_captcha_code
        @image = @image.wave(amplitude, frequency)
      when 'simply_green'
        @simple_captcha_image_options[:color] = 'darkgreen'
        append_simple_captcha_code
        @image = @image.wave(amplitude, frequency)
      when 'simply_blue'
        append_simple_captcha_code
        @image = @image.wave(amplitude, frequency)
      when 'distorted_black'
        append_simple_captcha_code
        @image = @image.wave(amplitude, frequency).edge(10)
      when 'all_black'
        append_simple_captcha_code
        @image = @image.wave(amplitude, frequency).edge(2)
      when 'charcoal_grey'
        append_simple_captcha_code
        @image = @image.wave(amplitude, frequency).charcoal
      when 'almost_invisible'
        @simple_captcha_image_options[:color] = 'red'
        append_simple_captcha_code
        @image = @image.wave(amplitude, frequency).solarize
      else
        append_simple_captcha_code(options)
        @image = @image.wave(amplitude, frequency)
      end
    end

    def generate_simple_captcha_image(options={})  #:nodoc
      @image = Magick::Image.new(110, 30){self.background_color = 'white'}
      @image.format = "JPG"
      @simple_captcha_image_options = {}
      @simple_captcha_image_options[:image_style] = 
        IMAGE_STYLES.include?(options[:image_style]) ?
        options[:image_style] :
        'simply_blue'
      @simple_captcha_image_options[:image_style] = 
        IMAGE_STYLES[rand(IMAGE_STYLES.length)] if options[:image_style]=='random'
      @simple_captcha_image_options[:distortion] = 
        DISTORTIONS.has_key?(options[:distortion]) ?
        DISTORTIONS[options[:distortion]] :
        DISTORTIONS['low']
      @simple_captcha_image_options[:color] = 'darkblue'
      set_simple_captcha_image_style      
      @image.implode(0.2).to_blob
    end

  end
end
