require 'pstore'
require 'RMagick'
include Magick

module SimpleCaptcha #:nodoc
  
  module ImageHandlers #:nodoc
    
    include ConfigTasks
    
    IMAGE_STYLES = [
                    "embosed_silver",
                    "simply_red",
                    "simply_green",
                    "simply_blue",
                    "distorted_black",
                    "all_black",
                    "charcoal_grey",
                    "almost_invisible"
                   ]
    
    private
    
    def image_details #:nodoc
      string = ""
      6.times{string << (65 + rand(25)).chr}
      name = create_code
      data = PStore.new(CAPTCHA_DATA_PATH + "data")
      data.transaction{data[name] = string}
      return string, name << ".jpg"
    end
    
    def add_text(options) #:nodoc
      options[:color] = "darkblue" unless options.has_key?(:color)
      text = Draw.new
      text.annotate(options[:image], 0, 0, 0, 5, options[:string]) do
        self.font = 'Courier'
        self.pointsize = 22
        self.fill = options[:color]
        self.gravity = NorthGravity 
      end
      return options[:image]
    end
    
    def add_text_and_effects(options={}) #:nodoc
      image = Image.new(110, 30){self.background_color = 'white'}
      options[:image] = image
      case options[:image_style]
      when "embosed_silver"
        image = add_text(options)
        image = image.wave(5, 30).shade(true, 20, 60)
      when "simply_red"
        options[:color] = "darkred"
        image = add_text(options)
        image = image.wave(5, 30)
      when "simply_green"
        options[:color] = "darkgreen"
        image = add_text(options)
        image = image.wave(5, 30)
      when "simply_blue"
        image = add_text(options)
        image = image.wave(5, 30)
      when "distorted_black"
        image = add_text(options)
        image = image.wave(5, 30).edge(10)
      when "all_black"
        image = add_text(options)
        image = image.wave(5, 30).edge(2)
      when "charcoal_grey"
        image = add_text(options)
        image = image.wave(5, 30).charcoal
      when "almost_invisible"
        options[:color] = "red"
        image = add_text(options)
        image = image.wave(5, 30).solarize
      else
        image = add_text(options)
        image = image.wave(5, 30)
      end
      return image
    end
    
    def create_image(image_style="simply_blue") #:nodoc
      image_style = IMAGE_STYLES[rand(IMAGE_STYLES.length)] if image_style=="random"
      string, name = image_details
      options = {
        :image_style => image_style,
        :string => string
      }
      image = add_text_and_effects(options)
      image.implode(0.2).write(CAPTCHA_IMAGE_PATH + name)
      return name
    end
    
  end
  
end
