# frozen_string_literal: true

class Wagon
  include Company
  include InstanceCounter
  include Validation
  include Accessors

  WAGON_FORMAT = /^[0-9]{1,3}$/.freeze

  attr_reader :number, :company
  attr_accessor :amount_space, :occupied_space

  validate :number, :presence
  validate :number, :format, WAGON_FORMAT
  validate :company, :presence

  def initialize(number, company, amount_space, type)
    @number = number.to_s
    @company = company
    @amount_space = amount_space
    @occupied_space = 0
    @type = type
    validate!
  end

  def free_space
    amount_space - occupied_space
  end

  def take_space
    raise 'Вагон заполнен, свободных мест нет' if @amount_space <= 0

    @occupied_space += 1
    @amount_space - @occupied_space
    puts "Вы заняли место в вагоне #{number}, количество свободных мест:#{wagon.free_space}."
  end
end
