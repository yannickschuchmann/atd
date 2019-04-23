class Keyword < ApplicationRecord
  has_many :ranks, foreign_key: "keyword_id", class_name: "KeywordRank", dependent: :destroy
  has_many :product_performances, dependent: :destroy
  has_many :products, through: :product_performances
end
