class Createtestreportscommandsjointable < ActiveRecord::Migration
  
  def self.up
    create_table :commands_test_reports, :id => false do |t|
      t.integer :test_report_id
      t.integer :command_id
    end
  end

  def self.down
    drop_table :commands_test_reports
  end

end
