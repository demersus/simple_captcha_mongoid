Rails.application.routes.draw do |map|
  match '/simple_captcha', :to => 'simple_captcha#show', :as => :simple_captcha
end
