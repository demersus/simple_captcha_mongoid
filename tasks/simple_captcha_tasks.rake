# Copyright (c) 2007 [Sur http://expressica.com]

require 'fileutils'

namespace :simple_captcha do
  
  def generate_migration
    puts "==============================================================================="
    puts "ruby script/generate migration create_simple_captcha_data"
    puts %x{ruby script/generate migration create_simple_captcha_data}
    puts "================================DONE==========================================="
  end
  
  def source_file(rails='')
    rails == 'old' ?
    File.join(File.dirname(__FILE__), "../assets", "migrate", "create_simple_captcha_data_less_than_2.0.rb") :
    File.join(File.dirname(__FILE__), "../assets", "migrate", "create_simple_captcha_data.rb")
  end

  def copy_view_file
    puts "Copying SimpleCaptcha view file(for rails < 2.0)"
    mkdir(File.join(RAILS_ROOT, "app/views/simple_captcha")) unless File.exist?(File.join(RAILS_ROOT, "app/views/simple_captcha"))
    FileUtils.cp_r(
      File.join(File.dirname(__FILE__), "../assets/views/simple_captcha/_simple_captcha.erb"),
      File.join(RAILS_ROOT, "app/views/simple_captcha/_simple_captcha.rhtml")
    )
    puts "================================DONE==========================================="
  end
  
  desc "Set up the plugin SimpleCaptcha for rails < 2.0"
  task :setup_old do
    begin
      generate_migration
      copy_to_path = File.join(RAILS_ROOT, "db", "migrate")
      migration_filename = 
        Dir.entries(copy_to_path).collect do |file|
          number, *name = file.split("_")
          file if name.join("_") == "create_simple_captcha_data.rb"
        end.compact.first
      migration_file = File.join(copy_to_path, migration_filename)
      File.open(migration_file, "wb"){|f| f.write(File.read(source_file('old')))}
      copy_view_file
      puts "Final Step"
      puts "run the task 'rake db:migrate' to migrate the simple_captcha migration into your db."
      puts "============================AND DONE!========================================"
    rescue StandardError => e
      p e
    end
  end
  
  desc "Set up the plugin SimpleCaptcha for rails >= 2.0"
  task :setup do
    begin
      generate_migration
      copy_to_path = File.join(RAILS_ROOT, "db", "migrate")
      migration_filename = 
        Dir.entries(copy_to_path).collect do |file|
        number, *name = file.split("_")
        file if name.join("_") == "create_simple_captcha_data.rb"
        end.compact.first
      migration_file = File.join(copy_to_path, migration_filename)
      File.open(migration_file, "wb"){|f| f.write(File.read(source_file))}
      puts "Final Step"
      puts "run the task 'rake db:migrate' to migrate the simple_captcha migration into your db."
      puts "============================AND DONE!========================================"
    rescue StandardError => e
      p e
    end
  end
  
end
