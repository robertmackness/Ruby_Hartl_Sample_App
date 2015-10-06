class User < ActiveRecord::Base

  attr_accessor :remember_token, :activation_token, :reset_token

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
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account
  def activate
    update_columns( activated:     true,
                    activated_at:  Time.zone.now)
  end

  # Sends activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Creates a password reset digest
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns( reset_digest:  User.digest(reset_token),
                    reset_sent_at: Time.zone.now )
  end

  # Send a password reset email
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if password reset has expired
  def password_reset_expired?
    self.reset_sent_at < 2.hours.ago
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
