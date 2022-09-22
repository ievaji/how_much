class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :windows, dependent: :destroy
  has_many :lists, dependent: :destroy
  has_many :items, dependent: :destroy
end
