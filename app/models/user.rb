class User < ApplicationRecord

  # remember_token属性を追加する
  attr_accessor :remember_token

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
  
  def remember 

    self.remember_token = User.new_token
    update_attribute(:remember_digest,User.digest(remember_token))
  end

  # 渡された文字列のハッシュ値を返す
  def self.digest(string)

    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ログアウト時にtokenを削除する
  def forget
    update_attribute(:remember_digest,nil)
  end
end
