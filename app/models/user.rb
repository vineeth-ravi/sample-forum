class User < ApplicationRecord
  has_many :posts
  has_many :user_actions
  has_many :user_follow_details
end
