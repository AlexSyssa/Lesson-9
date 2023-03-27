# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethod
  end

  module ClassMethods
    attr_writer :validations

    def validations
      @validations ||= []
    end

    def validate(attr_name, validation_type, expression = nil)
      validations << ({ attr_name: attr_name, validation_type: validation_type, expression: expression })
    end
  end

  module InstanceMethod
    def validate!
      self.class.validations.each do |validation|
        @value = instance_variable_get("@#{validation[:attr_name]}")
        check_validity(validation[:attr_name], validation[:validation_type], @value, validation[:expression])
      end
    end

    def valid?
      validate!
      true
    rescue StandartError
      false
    end

    def check_validity(attr_name, type, attr_value, expression)
      case type
      when :presence
        if attr_value.instance_of?(String)
          raise "Не указано значение #{attr_name}" if attr_value.nil?
        end
      when :type
        raise "Значение #{attr_name} не соответствует заданному типу #{type}" unless attr_value.instance_of?(type)
      when :format
        raise "Значение #{name} не соответствует заданному формату #{expression}" if attr_value !~ expression
      end
    end
  end
end
