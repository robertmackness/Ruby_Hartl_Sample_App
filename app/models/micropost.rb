class Micropost < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}

  # default scope orders by descending create time 
  # the stubby lambda -> or proc just assigns the block to default_scope to be called
  default_scope -> {order(created_at: :desc)}
end
