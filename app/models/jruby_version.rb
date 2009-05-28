require 'open-uri'

class JrubyVersion < ActiveRecord::Base
  def self.versions
    uri = URI.parse("http://dist.codehaus.org/jruby/")
    uri.read.scan(/\"\d+\.\d+.*\/\"/).map { |v| v.gsub(/[\/\"]/, "") }.sort
  end

  def self.load_versions
    JrubyVersion.all.each { |v| v.delete }
    
    self.versions.each do |v|
      JrubyVersion.create :version => v
    end
  end
end
