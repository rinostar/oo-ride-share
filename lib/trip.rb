require 'csv'
require 'time'

require_relative 'csv_record'
require_relative 'driver'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :driver_id, :driver

    def initialize(id:,
      passenger: nil, passenger_id: nil,
      start_time:, end_time:, cost: nil, rating:, driver_id: nil, driver: nil)
      super(id)

      @passenger = passenger
      @passenger_id = passenger_id
      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating
      @driver_id = driver_id
      # @driver = driver[:id]

      if end_time < start_time
        raise ArgumentError.new, "end time can't be earlier than start time"
      end

      if passenger
        @passenger = passenger
        @passenger_id = passenger.id

      elsif passenger_id
        @passenger_id = passenger_id

      else
        raise ArgumentError, 'Passenger or passenger_id is required'
      end

      if @rating > 5 || @rating < 1
        raise ArgumentError, "Invalid rating #{@rating}"
      end

      if @driver_id = nil && @driver = nil
        raise ArgumentError, "Either driver ID or driver is required"
      end
    end

    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

    def connect(passenger, driver)
      @passenger = passenger
      passenger.add_trip(self)
      @driver = driver
      driver.add_trip(self)
    end

    def duration
      a = Time.parse(@end_time.to_s)
      b = Time.parse(@start_time.to_s)
      c = (a - b)
      return c
    end

    private
    
    def self.from_csv(record)
      return self.new(
        id: record[:id],
        passenger: record[:passenger]
        passenger_id: record[:passenger_id],
        start_time: Time.parse("#{record[:start_time]}"),
        end_time: Time.parse("#{record[:end_time]}"),
        cost: record[:cost],
        rating: record[:rating],
        driver_id: record[:driver_id],
        driver: record[:driver]
        )
    end
  end
end
