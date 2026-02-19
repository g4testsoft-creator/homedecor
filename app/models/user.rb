class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reviews, dependent: :destroy

  def full_name
    [first_name, last_name].map { |v| v.to_s.strip }.reject(&:empty?).join(" ")
  end

  def admin?
    admin == true
  end
end
