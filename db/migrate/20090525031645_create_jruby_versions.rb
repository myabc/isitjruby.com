class CreateJrubyVersions < ActiveRecord::Migration
  def self.up
    create_table :jruby_versions do |t|
      t.string :version
    end
  end

  def self.down
    drop_table :jruby_versions
  end
end
