namespace :isitruby19 do
  desc "import gems from rubyforge"
  task :import => :environment do
    GemImporter.import
  end

  desc "load the default set of platforms"  
  task :load_platforms => :environment do
    Platform.load_defaults
  end 

  desc "load jruby versions"
  task :load_jruby_versions => :environment do
    JrubyVersion.load_versions
  end

  desc "set gem properties"
  task :set_gem_properties => :environment do
    gems = Code.find_all_by_c_extension_and_code_type(nil, "gem")
    total, i = gems.size, 0
    puts "#{total} gem(s) to process..."

    gems.each do |gem|
      i += 1
      begin
        puts "[#{i}/#{total}] Processing #{gem.slug_name}..."
        GemProperty.set(gem).save!
      rescue Exception => ex
        puts "Exception while processing #{gem.slug_name}"
        puts "#{ex.class} #{ex.message}"
      end
    end
  end
  
  desc "Clear expired sessions"
  task :clear_expired_sessions => :environment do
    ActiveRecord::Base.connection.execute("delete from sessions where updated_at < '#{6.hours.ago.to_s(:db)}';")
  end
  

end