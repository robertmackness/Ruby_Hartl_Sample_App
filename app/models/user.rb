class User < ActiveRecord::Base
  regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  before_save {self.email.downcase!}
  validates :name, presence: true,
            length: {maximum: 50}
  validates :email, format: { with: regex, on: :create },
                    presence: true,
                    length: {maximum: 255},
                    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password,  length: {minimum: 6, maximum: 20},
                        presence: true


  def User.digest(string)
  cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                BCrypt::Engine.cost
  BCrypt::Password.create(string, cost: cost)
  end

end
