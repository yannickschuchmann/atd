class Product < ApplicationRecord
  has_many :product_performances, dependent: :destroy
end
