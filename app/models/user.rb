class User < ActiveRecord::Base
  before_save {self.email = email.downcase}
  validates :name, presence: true,
            length: {maximum: 50}
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, on: :create },
                    presence: true,
                    length: {maximum: 255},
                    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password,  length: {minimum: 6, maximum: 20},
                        presence: true
end
