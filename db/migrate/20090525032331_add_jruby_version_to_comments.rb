class AddJrubyVersionToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :jruby_version, :string
  end

  def self.down
    remove_column :comments, :jruby_version
  end
end
