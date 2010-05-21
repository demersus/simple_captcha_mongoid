module SimpleCaptcha
  module FormBuilder
    def self.included(base)
      base.send(:include, SimpleCaptcha::ViewHelper)
      base.send(:include, SimpleCaptcha::FormBuilder::ClassMethods)
      
      base.delegate :render, :session, :to => :template
    end
    
    module ClassMethods
      # Example:
		  # <% form_for :post, :url => posts_path do |form| %>
		  #   ...
		  #   <%= form.simple_captcha :label => "Enter numbers..", :image_style => "simply_red" %>
		  # <% end %>
		  #
		  def simple_captcha(options = {})
      	options.update :object => @object_name
      	show_simple_captcha(objectify_options(options))
      end
      
      private
        
        def template
          @template
        end
    end
  end
end
