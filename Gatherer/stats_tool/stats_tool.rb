require 'mongo'
require_relative './utils.rb'
include Mongo

class Corpus_statistician 

  def initialize tweetcoll, replycoll, archive

      @total_tweets = 0
      @total_replies = 0
      @stats_array = []
      @total_conversations = 0
      @percentile_array = []
      @tweetcoll = tweetcoll
      @replycoll = replycoll
      @archive = archive

  end

  def workhorse 
      @tweetcoll.find({},{}).each {  |row| 
        @replycoll.find({"responds_to_tweet_id" => row.to_a[1][1].to_s},{:fields=>{ "_id" => 0, "results" => 1, "number_of_replies" => 1}}).each {
            |reply|    
               if reply.to_a[(reply.to_a.length)-1][1] > 0
                   @percentile_array.push reply.to_a[(reply.to_a.length)-1][1] 
                   @total_conversations += 1
               else
                  @total_conversations += 0
               end
               @total_tweets += 1
               @total_replies += reply.to_a[(reply.to_a.length)-1][1].to_i          
            }
         }
         @stats_array.push @total_tweets
         @stats_array.push @total_replies
         @stats_array.push @total_conversations
         @percentile_array.sort!

         (1..10).each { |i|
             @stats_array.push @percentile_array[((i * @percentile_array.length)/10)-1] 
         }

     @stats_array
  end


  def printer stats_array
      puts

      puts "   ,.                       '.                    ';;,.              '.                      "                                                                                                                                                                                     
      puts "   ,Xx                      ,Xx                  .xKxoc.             ,Xx                     "                                                                                                                                                                                      
      puts "   ,Nx                      ,Nk                  ;Nk.                ,Nk                     "                                                                                                                                                                                      
      puts "   ,NO:dkOx:.    .lxxxxl'   ,Nk   .xo;dkkxl.   :x0WXkkc .xl     .xl  ,Nk                     "                                                                                                                                                                                      
      puts "   ,NXd,.'dNl   :0d'...o0l  ,Nk   ,NXd,..:0O'   .:Nk..  ,Nk     ,Nk  ,Nk                     "                                                                                                                                                                                      
      puts "   ,Nk.   ,Nk  'KKl::::lK0, ,Nk   ,NO.    :Nd    ,Nx    ,Nk     ,Nk  ,Nk                     "                                                                                                                                                                                      
      puts "   ,Nx    ,Nk  ,XXdoooooo:. ,Nk   ,Nk.    ;Nd    ,Nx    ,Nk     ;Nk  ,Nk                     "                                                                                                                                                                                      
      puts "   ,Nx    ,Nk  .x0:.   .lc. ,Nk   ,NXl.  'k0;    ,Nx    'K0,  .;OWk  ,Nk                     "                                                                                                                                                                                      
      puts "   'Kd    'Kd   .cxkxxxkd,  '0d   ,N0oxkkOx,     'Ko     ,k0OkkooKd  'Kd                     "                                                                                                                                                                                      
      puts "    .      .       .....     .    ,Nx ....        .        ....  .    .                      "                                                                                                                                                                                      
      puts "                                  ,Nx                                                        "                                                                                                                                                                                      
      puts "                                  .c,                                                        "                                                                                                                                                                                      
      puts "                 .                     .     .ok:                .     .ok:                  "                                                                                                                                                                                      
      puts "                'Ko                   'Ko     ;l'               'Ko     ;l'                          "                                                                                                                                                                              
      puts "    .';;;,.   .;dW0c:,    .,;;;'    .;dW0c:,  .,.   .';;;,.   .;dW0c:,   ,.    .,;;,.     .';;;,.    "                                                                                                                                                                              
      puts "  .o0xllokKx' .ckWKol;. 'k0dlloOO,  .ckWKol:. ,Xx .o0xllokKx' .ckWKol;. ,Xx  .d0xood0x' .o0xllokKx'  "                                                                                                                                                                              
      puts "  .00:.   ';.   ,Nx     .:'....oNx    ,Nx     ,Nx .00:.   ';.   ,Nx     ,Nx .kK;    'l, .00:.   ';.  "                                                                                                                                                                              
      puts "   .ldxxxxo,    ,Nx     .oxdollkWx    ,Nx     ,Nx  .ldxxxxo,    ,Nx     ,Nx ,Xk          .ldxxxxo,   "                                                                                                                                                                              
      puts "   '.  ..'xXl   ,Nx    'K0,    cNx    ,Nx     ,Nx  '.  ..'xXl   ,Nx     ,Nx .00.    .,'  '.  ..'xXl  "                                                                                                                                                                              
      puts "       ,;cO0;   'KKc;' .OKl,;cd0Wx    'KKc;'. ,Nx .d0o;,;cO0;   'KKc;'. ,Nx  ,OOl;,:k0: .d0o;,;cO0;  "                                                                                                                                                                              
      puts "    'coool;.     'ldo:. .;oooc''l;     'ldo:. .l,   'coool;.     'ldo:. .l,   .,cool:.    'coool;.   "

      puts "                                              dba.                  "
      puts "                                         .ad88888888ba.             "
      puts "                                     .ad8888888888888888ba.         "
      puts "                                 .ad888888888888888888888888ba.     "
      puts "                             .ad88888888888888888888888888888888ba. "
      puts "                               `~888888888888888888888888888888~4   "
      puts "                                  `~888888888888888888888888~4|     "
      puts "                                     `~888888888888888888~4   |     "
      puts "                                       |`~888888888888~4|     |     "
      puts "                                       \   `~888888~4   /     A     "
      puts "                                        `-_   `~~4   _-4      H     "
      puts "                                           `--____--4               "

      puts "Sam's helpful corpus statistics :)"
      puts
      puts "Corpus Name:         " + @archive.to_s
      puts
      puts "total tweets:        " + stats_array[0].to_s
      puts
      puts "total replies:       " + stats_array[1].to_s
      puts
      puts "total conversations: " + stats_array[2].to_s
      puts
      puts "Below are the percentiles for the number of tweets per conversation."
      puts "(A conversation is defined as a non empty set of replies to a tweet)"
      puts
      (1..9).to_a.each { |i|
          puts "The " + (i*10).to_s + "th percentile is: " + stats_array[i+3].to_s
      } 
      puts
      
  end

end

# Configure the tool to collect statistics from the database that makes you happy!
db = MongoClient.new.db("tweetDB")
tweetcoll = db.collection("tweetArchiveP")
replycoll = db.collection("tweetArchivePositiveReplies")
archive = "tweetArchiveN"
 
# Collect the stats. It really is this simple.
statistician = Corpus_statistician.new tweetcoll, replycoll, archive
total = statistician.workhorse 
statistician.printer total 

