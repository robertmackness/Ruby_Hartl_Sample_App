class Micropost < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  # Custom validators use validate not validateS
  validate :picture_size

  # default scope orders by descending create time 
  # the stubby lambda -> or proc just assigns the block to default_scope to be called
  default_scope -> {order(created_at: :desc)}

  #tie PictureUploader to the model
  mount_uploader :picture, PictureUploader



  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

end
