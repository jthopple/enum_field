require 'active_record'

module EnumField
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
    prefix = prefix(field, options)
    
    possible_values.each do |value|
      verify_format(value) 
      method_name = methodize_value(value, prefix)
      define_value_constant(method_name, value)
      define_query_method(field, method_name, value)
      scope method_name.to_sym, where({ field.to_sym => value })
    end
    
    define_values_constant(field, possible_values)
    
    validates_inclusion_of field, 
      :in => possible_values, 
      :message => options[:message],
      :allow_nil => options[:allow_nil],
      :allow_blank => options[:allow_blank]
  end
  
  private
    def prefix(field, options)
      prefix = options[:prefix]
      return nil if prefix == false
      prefix && "#{prefix == true ? field : prefix}_"
    end

    def verify_format(value)
      if value.to_s !~ /^[\w\s_-]*$/
        raise ArgumentError.new("Invalid enum value: #{value}")
      end
    end
    
    def methodize_value(value, prefix)
      "#{prefix}#{value.downcase.gsub(/[-\s]/, '_')}"
    end
    
    def define_value_constant(method_name, value)
      const = method_name.upcase
      unless const_defined?(const)
        const_set const, value 
      end
    end
    
    def define_query_method(field, method_name, value)
      define_method("#{method_name}?") do
        self.send(field) == value
      end
    end
    
    def define_values_constant(field, values)
      unless const_defined?(field.to_s.pluralize.upcase)
        const_set field.to_s.pluralize.upcase, values 
      end
    end
end

ActiveRecord::Base.extend EnumField