require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

class GemPropertyTest < Test::Unit::TestCase
  def test_with_real_gems
    gems = [  [ "eventmachine", {:contains_c_extension=>true} ],
              [ "tzinfo",       {:contains_c_extension=>false} ] ]

    gems.each do |gem|
      gem_name = gem[0]
      properties = gem[1]
      g = GemProperty.new(gem_name)
      assert_equal properties, g.properties
      assert_equal gem_name, g.gem
      assert g.file.match(/^#{gem_name}\-/)
      assert g.send(:gem_specs).is_a?(Gem::Specification), "gem_specs is a #{g.send(:gem_specs).class}"
      assert !File.exist?(g.path), "#{g.path} exists but should have been deleted"
    end
  end
end
