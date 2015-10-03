class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token

  regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  before_create :create_activation_digest
  before_save :downcase_email
  validates :name, presence: true,
            length: {maximum: 50}
  validates :email, format: { with: regex, on: :create },
                    presence: true,
                    length: {maximum: 255},
                    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password,  length: {minimum: 6, maximum: 20},
                        presence: true,
                        allow_nil: true # note that has_secure_password runs a presence validation
                                        # on password and password_confirmation too so during updates
                                        # the user can submit empty password and password_confirmation
                                        # ONLY if they already exist


 
  # Remember a user by storing a new hashed token in the DB. Called by sessions_helper
  # to generate a token, save in the DB and in the user's cookies
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  #Takes a token and returns a hash
  def User.digest(string)
  cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                BCrypt::Engine.cost
  BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Returns true if the given token matches the digest after hashing, false if empty.
  # Rails infers that remember_digest is a field belonging to the instance of User
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

# ############ PRIVATE ###############

  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def downcase_email
    self.email.downcase!
  end

end
