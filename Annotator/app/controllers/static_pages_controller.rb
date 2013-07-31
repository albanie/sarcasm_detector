class StaticPagesController < ApplicationController

  def home
    if signed_in?
      #@tweet = current_user.tweets.build
      @feed_item = current_user.feed
      @annotation = current_user.annotations.build
      @count = current_user.counter
      @rating = current_user.rater
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  def why_not_chrome
  end
end
