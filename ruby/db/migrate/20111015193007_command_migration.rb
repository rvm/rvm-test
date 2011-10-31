class CommandMigration < ActiveRecord::Migration
  def self.up
    create_table :commands do |t|
      t.references :test_report
      t.string :sysname     
      t.string :os_type
      t.string  :cmd
      t.text  :cmd_output
      t.string  :timings
      t.string  :gist_url
      t.integer :exit_status
      t.timestamps
    end
  end

  def self.down
    drop_table :commands
  end
end
