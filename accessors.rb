# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }

      define_method("#{name}=".to_sym) { |value| instance_variable_set(var_name, value) }
      instance_eval "@#{name}_history ||= []", __FILE__, __LINE__
      instance_eval "@#{name}_history.push(value)", __FILE__, __LINE__
    end
  end

  def strong_attr_accessor(name, class_name)
    var_name = "@#{name}".to_sym
    # getter
    define_method("@#{name}".to_sym) { instance_variable_get(var_name) }
    # setter
    define_method("#{name}=".to_sym) do |value|
      raise 'Тип присваиваемого значения отличается от указанного' if class_name != value.class

      instance_variable_set(var_name, value)
    end
  end
end
