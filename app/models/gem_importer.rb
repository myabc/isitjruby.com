require 'rubygems'

class GemImporter

  GEMCUTTER_URI = 'http://gemcutter.org/'

  def self.import
    # Gem::SpecFetcher.fetcher.list.each { |source, gems| }
    Gem::SpecFetcher.fetcher.list[URI.parse(GEMCUTTER_URI)].each do |g|
      Code.new_from_gem_tuple(g)
    end
  rescue Exception => ex
    puts ex.message
  end

end
