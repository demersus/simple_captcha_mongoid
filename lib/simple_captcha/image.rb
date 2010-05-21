module SimpleCaptcha #:nodoc
  module ImageHelpers #:nodoc
    
    include SimpleCaptcha::Utils
    
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
    
    DISTORTIONS = ['low', 'medium', 'high']

    class << self
      def image_style(key='simply_blue')
        return IMAGE_STYLES[rand(IMAGE_STYLES.length)] if key=='random'
        IMAGE_STYLES.include?(key) ? key : 'simply_blue'
      end
      
      def distortion(key='low')
        key = 
          key == 'random' ?
          DISTORTIONS[rand(DISTORTIONS.length)] :
          DISTORTIONS.include?(key) ? key : 'low'
        case key
          when 'low' then return [0 + rand(2), 80 + rand(20)]
          when 'medium' then return [2 + rand(2), 50 + rand(20)]
          when 'high' then return [4 + rand(2), 30 + rand(20)]
        end
      end
    end

    class Tempfile < ::Tempfile
      # Replaces Tempfile's +make_tmpname+ with one that honors file extensions.
      def make_tmpname(basename, n)
        extension = File.extname(basename)
        sprintf("%s,%d,%d%s", File.basename(basename, extension), $$, n, extension)
      end
    end

    private
    
      def set_simple_captcha_image_style(style) #:nodoc
        case style
          when 'embosed_silver' then 
            ['darkblue', '-shade 20x60']
          when 'simply_red' then
            ['darkred', '']
          when 'simply_green' then
            ['darkgreen', '']
          when 'simply_blue' then
            ['darkblue', '']
          when 'distorted_black' then
            ['darkblue', '-edge 10']
          when 'all_black' then
            ['darkblue', '-edge 2']
          when 'charcoal_grey' then
            ['darkblue', '-charcoal 5']
          when 'almost_invisible' then
            ['red', '-solarize 50']
          else
            ['darkblue', '']
        end
      end

      def generate_simple_captcha_image(options={}) #:nodoc
        @simple_captcha_options = {
          :simple_captcha_key => options[:simple_captcha_key],
          :distortion => SimpleCaptcha::ImageHelpers.distortion(options[:distortion]),
          :image_style => SimpleCaptcha::ImageHelpers.image_style(options[:image_style])
        }
        color, effect = set_simple_captcha_image_style(@simple_captcha_options[:image_style])
        amplitude, frequency = @simple_captcha_options[:distortion]
        text = simple_captcha_value(@simple_captcha_options[:simple_captcha_key])
        dst = Tempfile.new('simple_captcha.jpg')
        dst.binmode
        
        params = [ "-size 110x30" ]
        params << "-background white"
        params << "-fill #{color}"
        params << "-wave #{amplitude}x#{frequency}"
        params << "-gravity 'Center'"
        params << "-pointsize 22"
        params << effect
        params << "-implode 0.2"
        params << "label:#{text} #{File.expand_path(dst.path)}"
        
        run("convert", params.join(' '))

        File.expand_path(dst.path)
      end
  end
end
