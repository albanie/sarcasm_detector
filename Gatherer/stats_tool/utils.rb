class Object

    def clean_up (tweet) 
        tweet.gsub(/\s?#(sarcasm)/i, "")
        .gsub(/\s?#(sarcastic)/i, "")
        .gsub(/@([a-z0-9_]+)/i, "@SomeUser")
        .gsub(/http\W\W\W([a-z0-9_]+)\W?\w?\w?\/?([a-z0-9_]+)?/i, "SomeLink")
        
    end
    
end