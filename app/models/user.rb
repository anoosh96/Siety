class User < ApplicationRecord

  attr_accessor :remember_token, :activation_token, :reset_token
  has_many :microposts, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy

  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower




  before_save {self.email = email.downcase}

  before_create :create_activation_digest
  validates :name, presence:true, length:{maximum: 50}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@.*[a-z\d\-]+\.[a-z]+\z/i

  validates :email, presence:true, length:{maximum: 100}, format:{with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, presence:true, length: {minimum: 6}


  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST
 :
 BCrypt::Engine.cost
 BCrypt::Password.create(string, cost: cost)
 end

 def User.new_token
   SecureRandom.urlsafe_base64
 end

  def remember

   self.remember_token = User.new_token
     update_attribute(:remember_digest, User.digest(remember_token))
   end


   def forget
        update_attribute(:remember_digest, nil)
   end


  def authenticated?(attribute,token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end


  def activate
    update_columns(activated: true, activated_at: Time.zone.now)

  end

  def feed
      microposts
  end


  def sendActivationEmail

    UserMailer.account_activation(self).deliver_now

  end

  def create_reset_digest

      self.reset_token = User.new_token
      update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)

  end

  def send_reset_email

    UserMailer.password_reset(self).deliver_now

  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end
  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
   # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  private

      def create_activation_digest

           self.activation_token = User.new_token
           self.activation_digest = User.digest(activation_token)

      end

end
