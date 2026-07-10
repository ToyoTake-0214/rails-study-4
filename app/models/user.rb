class User < ApplicationRecord
  has_secure_password
  has_secure_password :recovery_password, validations: false

  enum role: { general: 0, admin: 1 }

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:password_digest] }
  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  validates :reset_password_token, uniqueness: true, allow_nil: true

  has_many :boards, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_boards, through: :bookmarks, source: :board
  mount_uploader :avatar, AvatarUploader

  def bookmark(board)
    bookmark_boards << board
  end

  def unbookmark(board)
    bookmark_boards.destroy(board)
  end

  def bookmark?(board)
    bookmark_boards.include?(board)
  end


  def own?(object)
    id == object&.user_id
  end
  
  def generate_reset_password_token!
    reset_password_token = SecureRandom.hex(16)
    while User.exists?(reset_password_token:)
      reset_password_token = SecureRandom.hex(16)
    end
    self.reset_password_token = reset_password_token
    update!(reset_password_token_expires_at: 1.hour.from_now)
  end
end
