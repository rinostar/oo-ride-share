require_relative 'csv_record'
require_relative 'trip'
require_relative 'passenger'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
      @vin = vin
      @status = status.to_sym
      @trips = trips || []

      if @vin.length != 17
        raise ArgumentError, "The length must be 17 characters"
      end

      unless [:AVAILABLE, :UNAVAILABLE].include?(@status)
        raise ArgumentError, "Invalid input"
      end
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      rating = []
      @trips.each do |trip|
        ratings << trip.rating
      end
      average_rating = ratings.sum.to_f / ratings.length.to_f
        return average_rating
      end

      if trips.length == 0
        return 0
      end
    end

    def total_revenue
    end
     
    private

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status]
      )
    end

  end
end

