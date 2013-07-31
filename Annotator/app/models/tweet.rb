class Tweet < ActiveRecord::Base
  attr_accessible :content, :replies, :tweetId

  has_many :annotations

  def self.find(*args)
    if args.first.to_s == "random"
      ids = connection.select_all("SELECT id FROM tweets")
      super(ids[rand(ids.length)]["id"].to_i)
    else
      super
    end
  end
end
