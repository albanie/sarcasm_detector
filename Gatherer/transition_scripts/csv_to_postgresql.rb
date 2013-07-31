# This script moves the csv file contents into the postgres database for the app.  It contains many printing 
# statements to make it clear if the data is being transferred correctly.

require 'csv'
require 'pg'
require_relative './helper_functions'

class Relayer

counter = 0
insert_counter = 0
conn = PGconn.connect('dbname=tweet_app_db_3')

 File.open("app_tweets_2.csv").readlines.each do |line|
  	puts 'sarcasm level:'
    sarcasm_level = CSV.parse_line(line)[0].to_s[1..-2]
  	puts sarcasm_level
  	puts 'content:'
    content = (CSV.parse_line(line)[1].to_s[1..-2]) 
    puts content
  	puts 'tweetId:'
  	puts counter
  	tweet_id = counter
  	counter += 1
  	reply_1 = CSV.parse_line(line)[2].to_s[1..-2]
  	reply_2 = CSV.parse_line(line)[3].to_s[1..-2] 
  	reply_3 = CSV.parse_line(line)[4].to_s[1..-2]
  	reply_4 = CSV.parse_line(line)[5].to_s[1..-2]
  	reply_5 = CSV.parse_line(line)[6].to_s[1..-2]
  	
    if reply_1 == ''
  		puts 'replies: 0'
  		num_of_replies = 0

  	elsif reply_2 == ''
  		puts 'replies: 1'
  		num_of_replies = 1

  	elsif reply_3 == ''
  		puts 'replies: 2'
  		num_of_replies = 2

  	elsif reply_4 == ''
  		puts 'replies: 3'
  		num_of_replies = 3

  	elsif reply_5 == ''
  		puts 'replies: 4'
  		num_of_replies = 4

  	else
  		puts 'replies: 5'
  		num_of_replies = 5
  	end
  	puts reply_1, reply_2, reply_3, reply_4, reply_5


      conn.prepare("#{insert_counter}", 'insert into tweets ( content, "tweetId", replies, sarcastic, reply_1, reply_2, reply_3, reply_4, reply_5) values ($1, $2, $3, $4, $5, $6, $7, $8, $9)')
      conn.exec_prepared("#{insert_counter}", [ "#{content}","#{counter}", "#{num_of_replies}",
                                          "#{sarcasm_level}","#{reply_1}","#{reply_2}","#{reply_3}","#{reply_4}","#{reply_5}" ])
      puts 'inserted'
	 insert_counter += 1
end

                  
end


