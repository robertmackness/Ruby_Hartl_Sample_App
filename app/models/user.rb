class User < ActiveRecord::Base
  validates(:name, presence: true)
  validates(:name, length: {maximum: 50})
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, on: :create }
  validates(:email, presence: true)
  validates(:email, length: {maximum: 255})
end
