require "rubygems"
require "test/unit"
require 'shoulda'
require 'mocha'

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'enum_field'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3", 
  :database => File.dirname(__FILE__) + "/enum_field.sqlite3"
)

load File.dirname(__FILE__) + '/support/schema.rb'
load File.dirname(__FILE__) + '/support/models.rb'