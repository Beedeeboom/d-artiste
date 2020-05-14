class User < ApplicationRecord
  rolify
  after_create :assign_default_role

  def assign_default_role
    add_role(:user)
  end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :arts, dependent: :destroy 
end
