class TweetsController < ApplicationController
    before_filter :signed_in_user

    def create
      @tweet = current_user.tweets.build(params[:tweet])
      if @tweet.save
         flash[:success] = "tweet created!"
         redirect_to root_url
      else
        @feed_items = []
        render 'static_pages/home'
      end  
    end

    def destroy
    end
end
