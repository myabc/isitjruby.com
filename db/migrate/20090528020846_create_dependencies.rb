class CreateDependencies < ActiveRecord::Migration
  def self.up
    create_table :dependencies do |t|
      t.integer :code_id, :null => false
      t.string  :gem,     :null => false
    end
  end

  def self.down
    drop_table :dependencies
  end
end
