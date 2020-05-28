class User < ApplicationRecord
  include Clearance::User
  has_many :characters
end
