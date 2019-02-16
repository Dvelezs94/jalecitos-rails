class City < ApplicationRecord
  searchkick language: "spanish", word_start: [:name]
  # only send these fields to elasticsearch
  def search_data
    {
      name: name
    }
  end
  belongs_to :state

  has_many :gigs
  has_many :requests
  has_many :users
end
