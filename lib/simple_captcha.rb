require 'simple_captcha/utils'
require 'simple_captcha/image'
require 'simple_captcha/view'
require 'simple_captcha/controller'

if Object.const_defined?("ActionView")
  ActionView::Base.send(:include, SimpleCaptcha::ViewHelper)
  ActionView::Helpers::FormBuilder.send(:include, SimpleCaptcha::FormBuilder)
end

if Object.const_defined?("ActiveRecord")
  require 'simple_captcha/active_record'
  ActiveRecord::Base.send(:include, SimpleCaptcha::ModelHelpers)
end

if Object.const_defined?("Formtastic")
  require 'simple_captcha/formtastic'
  Formtastic::SemanticFormHelper.builder = SimpleCaptcha::CustomFormBuilder
end
