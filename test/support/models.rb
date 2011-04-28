class Person < ActiveRecord::Base
  enum_field :gender, %w(Male Female), :default => "Female"
end