class AddCExtensionToCodes < ActiveRecord::Migration
  def self.up
    add_column :codes, :c_extension, :boolean
  end

  def self.down
    remove_column :codes, :c_extension
  end
end
