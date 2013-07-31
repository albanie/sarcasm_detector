# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  email                 :string(255)
#  number_of_annotations :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  password_digest       :string(255)
#  remember_token        :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  has_many :annotations, dependent: :destroy

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name, presence: true, length: { minimum: 3 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 40 }, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def feed
    # Collect the next tweet to be annotated, in order of preference
     Tweet.find('random')
    #  thesetweets = Tweet.where("id > ?", 0)
    #  thesetweets[0]
   # thistweet = Tweet.where("id > ?", 0)
   # thistweetId = thistweet.tweetId
    #if (Annotation.where("tweetId=?",tweetId) == null)
    
  end

  def counter
    @userId = User.where(:email => self.email).pluck(:id)
    Annotation.where(:user_id => @userId).count()
  end

  def rater
    if counter < 15
      ["A dour serf","adourserf.jpeg"]
    elsif counter < 30
      ["A humourless yeoman", "ahumourlessyeoman.png"]
    elsif counter < 50
      ["A mildly amusing jester", "amildlyamusingjester.png"]
    elsif counter < 70
      ["A cheerful merchant", "acheerfulmerchant.png"]
    elsif counter < 100
      ["A witty knight", "awittyknight.png"]
    elsif counter < 135
      ["A banterous baron", "abanterousbaron.png"]
    elsif counter < 170
      ["A sarcastic prince", "asarcasticprince.png"]
    else
      ["An ironic emperor", "anironicemperor.png"]
    end
  end


  

   private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
