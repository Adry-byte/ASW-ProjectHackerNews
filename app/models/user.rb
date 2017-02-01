class User < ActiveRecord::Base

  acts_as_voter

  before_save { email.downcase! }
  validates :username, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence:   true,
            format:     { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, :presence => true, :confirmation => true, length: {minimum: 7}, :if => :password


  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  has_many :authentications, :dependent => :destroy

  def apply_omniauth(omniauth)
    self.email = omniauth['info']['email'] if email.blank?
    apply_trusted_services(omniauth) if self.new_record?
  end
  def apply_trusted_services(omniauth)
    user_info = omniauth['info']
    if omniauth['extra'] && omniauth['extra']['user_hash']
      user_info.merge!(omniauth['extra']['user_hash'])
    end
    if self.username.blank?
      self.username   = user_info['name']   unless user_info['name'].blank?
      self.username ||= user_info['nickname'] unless user_info['nickname'].blank?
      self.username ||= (user_info['first_name']+" "+user_info['last_name']) unless \
        user_info['first_name'].blank? || user_info['last_name'].blank?
    end
    if self.email.blank?
      self.email = user_info['email'] unless user_info['email'].blank?
    end
    self.password, self.password_confirmation = RandomString(16)
    #self.confirmed_at, self.confirmation_sent_at = Time.now
  end

  RAND_CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789"
  def RandomString(len)
    rand_max = RAND_CHARS.size
    ret = ""
    len.times{ ret << RAND_CHARS[rand(rand_max)] }
    ret
  end
  
  def timestamp
    self.created_at
  end
  def as_json(options={})
    super(:methods => [:timestamp],
          except: [:created_at, :updated_at, :karma, :password_digest, :password, :apiKey])
  end

end
