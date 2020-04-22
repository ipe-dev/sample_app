class User < ApplicationRecord

  # 登録する前に呼び出すコールバック。emailを小文字にする
  # before_save { self.email = email.downcase }
  before_save { self.email.downcase! }

  # nameの文字数は50まで
  validates :name, presence: true, length:{maximum:50}

  # emailの長さは255まで
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length:{maximum:255},
                    # 一意性をなくす
                    uniqueness: { case_sensitive: false },
                    # emailのフォーマットのvalidate
                    format: { with: VALID_EMAIL_REGEX }

  has_secure_password
  validates :password, presence: true, length:{minimum:6}

  def User.digest(string)

    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
