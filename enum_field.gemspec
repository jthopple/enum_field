# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{enum_field}
  s.version = "0.3.3"

  s.required_rubygems_version = ">= 1.3.6"
  s.authors = ["James Golick", "Mathieu Martin", "Jeremy Hopple"]
  s.description = %q{enum_field encapsulates a bunch of common idioms around ActiveRecord validates_inclusion_of}
  s.email = %q{jeremy@jthopple.co}
  s.homepage = %q{http://github.com/jthopple/enum_field}
  s.rdoc_options = ["--charset=UTF-8"]
  s.summary = %q{ActiveRecord enum fields on steroid}
  
  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "shoulda"
  s.add_development_dependency "mocha"
  s.add_development_dependency "sqlite3"

  s.add_dependency "activerecord", "~> 3.0"

  s.files        = `git ls-files`.split("\n")
  s.require_path = 'lib'
end
