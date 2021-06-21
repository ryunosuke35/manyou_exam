class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  before_validation { email.downcase! }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }


  after_destroy :admin_necessary
  after_update :admin_necessary

  has_many :tasks, dependent: :destroy



  def admin_necessary
    if User.where(admin: 'true').count == 0
      raise ActiveRecord::Rollback
    end
  end



end
