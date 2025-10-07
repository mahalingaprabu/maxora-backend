# app/models/product.rb
class Product < ApplicationRecord
  validates :title, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  # Simple nearest search using Haversine formula. Pass user lat/lng.
  # Example: Product.nearby(10.99, 77.00, 10)  # within 10 km
  scope :nearby, ->(lat, lng, radius_km = 50) {
    return all unless lat && lng
    select("#{table_name}.*, (6371 * acos(cos(radians(#{lat})) * cos(radians(latitude)) * cos(radians(longitude) - radians(#{lng})) + sin(radians(#{lat})) * sin(radians(latitude)))) AS distance")
      .where("#{table_name}.latitude IS NOT NULL AND #{table_name}.longitude IS NOT NULL")
      .having("distance <= ?", radius_km)
      .order("distance ASC")
  }
end
