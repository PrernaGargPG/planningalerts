namespace :planningalerts do
  namespace :authorities do
    desc "Load all the authorities data from the scraper web service index"
    task :load => :environment do
      Authority.load_from_web_service(Logger.new(STDOUT))
    end
  end
  
  namespace :applications do
    desc "Scrape new applications, index them, send emails and generate XML sitemap"
    task :scrape_and_email => [:scrape, 'ts:in', :email, :sitemap]
    
    desc "Scrape all the applications for the last few days for all the loaded authorities"
    task :scrape, [:authority_short_name] => :environment do |t, args|
      authorities = args[:authority_short_name] ? [Authority.find_by_short_name_encoded(args[:authority_short_name])] : Authority.active
      Application.collect_applications(authorities, Logger.new(STDOUT))
    end
    
    desc "Send planning alerts"
    task :email => :environment do
      Alert.send_alerts(Logger.new(STDOUT))
    end
  end
  
  desc "Generate XML sitemap and notify Google, Yahoo, etc.."
  task :sitemap => :environment do
    s = PlanningAlertsSitemap.new
    s.generate_and_notify
  end

  # A response to something bad
  namespace :emergency do
    desc "Applications for an authority shouldn't have duplicate values of council_reference and so this removes duplicates."
    task :fix_duplicate_council_references => :environment do
      # First find all duplicates
      duplicates = Application.group(:authority_id).group(:council_reference).count.select{|k,v| v > 1}.map{|k,v| k}
      duplicates.each do |authority_id, council_reference|
        authority = Authority.find(authority_id)
        puts "Removing duplicates for #{authority.full_name_and_state} - #{council_reference}..."
        applications = authority.applications.find_all_by_council_reference(council_reference)
        # The first result is the most recently scraped. We want to keep the last result which was the first
        # one scraped
        applications[0..-2].each {|a| a.destroy}
      end
    end
  end
end
