class TestReportMigration < ActiveRecord::Migration
  def change
    create_table :test_reports do |t|
      t.string  :sysname
      t.string  :timings
      t.text    :report
      t.string  :gist_url
      t.integer :exit_status
      t.text    :env_initial
      t.timestamps
    end
  end

end
