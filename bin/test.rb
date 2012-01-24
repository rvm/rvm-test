require 'session'
require 'active_record'
require 'active_support'

ActiveRecord::Base.establish_connection(YAML.load_file(File.dirname(__FILE__) + "/../config/database.yml"))

Dir["#{File.dirname(__FILE__)}/../app/models/*.rb"].each do |filename|
  load filename
end

ARGV.each do |filename|
  load filename
end
