# Copyright (c) 2007 [Sur http://expressica.com]

require 'fileutils'

namespace :simple_captcha do
  desc "Adds the migration file 'xxx_create_simple_captcha_data.rb' required by the plugin SimpleCaptcha"
  task :setup => :environment do
    def source_file
      RAILS_GEM_VERSION.to_f < 2.0 ?
      File.join(File.dirname(__FILE__), "../assets", "migrate", "create_simple_captcha_data_less_than_2.0.rb") :
      File.join(File.dirname(__FILE__), "../assets", "migrate", "create_simple_captcha_data.rb")
    end
    
    def copy_view_file
      if RAILS_GEM_VERSION.to_f < 2.0
        puts "Copying SimpleCaptcha view file(for rails < 2.0)"
        mkdir(File.join(RAILS_ROOT, "app/views/simple_captcha")) unless File.exist?(File.join(RAILS_ROOT, "app/views/simple_captcha"))
        FileUtils.cp_r(
          File.join(File.dirname(__FILE__), "../assets/views/simple_captcha/_simple_captcha.erb"),
          File.join(RAILS_ROOT, "app/views/simple_captcha/_simple_captcha.rhtml")
        )
        puts "==============================================================================="
      end
    end
    
    begin
      puts "==============================================================================="
      puts "ruby script/generate migration create_simple_captcha_data"
      puts %x{ruby script/generate migration create_simple_captcha_data}
      puts "==============================================================================="
      copy_to_path = File.join(RAILS_ROOT, "db", "migrate")
      migration_file = File.join(copy_to_path, Dir.entries(copy_to_path).last)
      File.open(migration_file, "wb"){|f| f.write(File.read(source_file))}
      puts "rake db:migrate"
      puts %x{rake db:migrate}
      puts "==============================================================================="
      copy_view_file
      puts File.read(File.dirname(__FILE__)+"/../README")
    rescue StandardError => e
      p e
    end
  end
end
