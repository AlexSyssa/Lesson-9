# frozen_string_literal: true

class Station
  include InstanceCounter
  include Validation

  NAME_FORMAT = /^[0-9а-яa-z]{3,33}$/i.freeze

  attr_accessor :name, :trains

  validate :name, :presence
  validate :name, :format, NAME_FORMAT

  @@stations = []

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
    register_instance
  end

  def trains_on_station(&block)
    trains.each { |train| block.call(train) }
    puts 'На станции нет поездов' if trains.empty?
  end

  def self.all
    @@stations.each { |station| puts station.name }
  end

  def add_train(train)
    @trains << train
  end

  def output_trains
    trains.each { |train| puts train.id }
  end

  def train_dispatch(train)
    trains.delete(train) if trains.include?(train)
  end
end
