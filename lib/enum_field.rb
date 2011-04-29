require 'active_record'

module EnumField
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    # enum_field encapsulates a validates_inclusion_of and automatically gives you a 
    # few more goodies automatically.
    # 
    #     class Computer < ActiveRecord:Base
    #       enum_field :status, ['on', 'off', 'standby', 'sleep', 'out of this world']
    # 
    #       # Optionally with a message to replace the default one
    #       # enum_field :status, ['on', 'off', 'standby', 'sleep'], :message => "incorrect status"
    # 
    #       #...
    #     end
    # 
    # This will give you a few things:
    # 
    # - add a validates_inclusion_of with a simple error message ("invalid #{field}") or your custom message
    # - define the following query methods, in the name of expressive code:
    #   - on?
    #   - off?
    #   - standby?
    #   - sleep?
    #   - out_of_this_world?
    # - define the STATUSES constant, which contains the acceptable values
    def enum_field(field, possible_values, options={})     
      prefix = EnumField.prefix(field, options)
      
      possible_values.each do |value|
        EnumField.check_value(value) 
        method_name = EnumField.methodize_value(value)

        name = "#{prefix}#{method_name}"
        const = name.upcase
        unless const_defined?(const)
          const_set const, value 
        end
        
        define_method("#{prefix}#{method_name}?") do
          self.send(field) == value
        end
      
        scope method_name.to_sym, where({ field.to_sym => value })
      end
      
      unless const_defined?(field.to_s.pluralize.upcase)
        const_set field.to_s.pluralize.upcase, possible_values 
      end
      
      validates_inclusion_of field, 
        :in => possible_values, 
        :message => options[:message],
        :allow_nil => options[:allow_nil],
        :allow_blank => options[:allow_blank]
    end
  end
  
  private
    def self.prefix(field, options)
      prefix = options[:prefix]
      prefix && "#{prefix == true ? field : prefix}_"
    end

    def self.check_value(value)
      if value.to_s !~ /^[\w\s_-]*$/
        raise ArgumentError.new("Invalid enum value: #{value}")
      end
    end
    
    def self.methodize_value(value)
      value.downcase.gsub(/[-\s]/, '_')
    end
end

ActiveRecord::Base.class_eval { include EnumField }