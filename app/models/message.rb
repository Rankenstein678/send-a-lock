class Message < ApplicationRecord
  validates :content, presence: true, length: { minimum: 1 }
end
  