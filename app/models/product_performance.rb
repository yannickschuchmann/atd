class ProductPerformance < ApplicationRecord
  belongs_to :keyword
  belongs_to :product
end
