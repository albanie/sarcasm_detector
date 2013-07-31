require 'mongo'
require 'csv'
include Mongo
require_relative './helper_functions'

class Relayer

  db = MongoClient.new.db("tweetDB")
  tweetcoll = db.collection("tweetArchiveN")
  replycoll = db.collection("tweetArchiveNegativeReplies")
  simple_regex = Regexp.new('\"text\"\W\W\"[^"]*"')
  content_array = []
  reply_no = 0
  counter = 0

  tweetcoll.find({},{}).each { 
    |row| 

      content_array = []
      content_array.push (clean_up(row.to_a[3][1]).gsub(/\'/,"''"))    
      
      replycoll.find({"responds_to_tweet_id" => row.to_a[1][1].to_s},{:fields=>{ "_id" => 0,
         "results" => 1, "number_of_replies" => 1}}).to_a.each { 
         |reply| 

            reply.to_a[0].to_s.scan(simple_regex).each { 
                |entry|
                    if entry == 0
                        content_array.push "NULL"
                    else           
                        content_array.push clean_up(entry).gsub(/\'/,"''").gsub(/\"text\"\W\W/,"")
                        #puts content_array.inspect
                    end
                      }     

                    reply_no = reply.to_a[(reply.to_a.length)-1][1]

                    content_array.push row.to_a[1][1]
                    content_array.push reply_no  

                    #This prints out everything to the screen before we push it into the database.
                    puts content_array.inspect  

                    if content_array.length <= 3
                          reply_1 = ""
                    else
                      reply_1 = content_array[1]
                    end   

                    if content_array.length <= 4
                          reply_2 = ""
                    else
                      reply_2 = content_array[2]
                    end   

                    if content_array.length <= 5
                          reply_3 = ""
                    else
                      reply_3 = content_array[3]
                    end   

                    if content_array.length <= 6
                          reply_4 = ""
                    else
                      reply_4 = content_array[4]
                    end   

                    if content_array.length <= 7
                          reply_5 = ""
                    else
                      reply_5 = content_array[5]
                    end 
                    counter+= 1

                    CSV.open("negative_reply_store.csv", "a") do |csv|
                      csv <<  [ "|negative|","|#{(content_array[0])}|",
                                          "|#{reply_1}|","|#{reply_2}|","|#{reply_3}|","|#{reply_4}|","|#{reply_5}|" ]
                    end
                      }
                    }
end


