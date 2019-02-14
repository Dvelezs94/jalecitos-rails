class City < ApplicationRecord
  searchkick language: "spanish"
  # only send these fields to elasticsearch
  def search_data
    {
      name: name
    }
  end
  belongs_to :state
end
