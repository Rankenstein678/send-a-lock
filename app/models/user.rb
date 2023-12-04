require 'securerandom'

class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: { with: /\w+\.\w+@schiller-og\.de/ }
  validates :public_key, presence: true

  def self.init(params)
    user = User.new(params)
    if user.valid?
      names = user.email.split('@')[0].split '.'
      user.name = "#{names[0].capitalize} #{names[1].capitalize}"
      user.verified = false
      user.confirmation_code = SecureRandom.alphanumeric(10)
    end
    user
  end
end
