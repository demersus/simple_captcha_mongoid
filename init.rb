# Copyright (c) 2007 [Sur http://expressica.com]

require 'simple_captcha_config'
require 'simple_captcha_action_view'
require 'simple_captcha_action_controller'
require 'simple_captcha_active_record'


ActionController::Base.view_paths.unshift File.join(directory, 'assets', 'views') if RAILS_GEM_VERSION.to_f >= 2.0
