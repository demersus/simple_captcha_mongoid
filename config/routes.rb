Rails.application.routes.draw do |map|
  match '/simple_captcha/:action', :to => 'simple_captcha', :as => :simple_captcha
end
