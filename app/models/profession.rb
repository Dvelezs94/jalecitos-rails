class Profession < ApplicationRecord
    searchkick language: "spanish", word_start: [:name]
end
