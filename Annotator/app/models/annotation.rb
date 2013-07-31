class Annotation < ActiveRecord::Base
  attr_accessible :email, :tweetId, :value
  belongs_to :user
  belongs_to :tweet 

end
