class Keyword < ApplicationRecord
  has_many :ranks, foreign_key: "keyword_id", class_name: "KeywordRank"
  has_many :product_performances
end
