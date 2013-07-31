package gather_scripts;

import java.net.UnknownHostException;
import java.util.Date;
import twitter4j.FilterQuery;
import twitter4j.StallWarning;
import twitter4j.Status;
import twitter4j.StatusDeletionNotice;
import twitter4j.StatusListener;
import twitter4j.TwitterException;
import twitter4j.TwitterStream;
import twitter4j.TwitterStreamFactory;
import twitter4j.User;
import twitter4j.conf.ConfigurationBuilder;
import twitter4j.json.DataObjectFactory;
import com.mongodb.*;
import com.mongodb.util.JSON;


public class TweetGatherer {
	
    public static void main(String[] args) {
    	
    	// In order to utilize the streaming API, we must first authenticate using Oauth.  
    	// This is achieved with an instance of Configuration Builder, which stores the necessary settings.	
    	 ConfigurationBuilder cb = new ConfigurationBuilder();
   
        // We enable debug output.
         cb.setDebugEnabled(true);
                 
     	// The consumer secret and token for the twitter application are embedded into the instance of Configuration Builder
         cb.setOAuthConsumerKey("CONSUMER KEY");
         cb.setOAuthConsumerSecret("CONSUMER SECRET");
         cb.setOAuthAccessToken("ACCESS TOKEN");
         cb.setOAuthAccessTokenSecret("ACCESS TOKEN SECRET");

        // Twitter Stream is the interface offered by Twitter4J to handle the streaming API. We create an instance using our
        // authentication details defined above.
         TwitterStream twitterStream = new TwitterStreamFactory(cb.build()).getInstance();
    	
    	// Next we set up a connection to our local Mongo DB server, running on port 27017. This will create a new 
        // database called tweetStore. We must run this in a try/catch block to handle the unknown host exception.
		 try {
			
		   // The default port for the Mongo server is 27017.
			MongoClient m = new MongoClient( "localhost" , 27017 );
			DB db = m.getDB("GEOtweetsDB");
			final DBCollection table = db.getCollection("GEOtweetNegative");
			
		   // Status listener - fairly self explanatory
            StatusListener listener = new StatusListener() {

                // Upon receiving a statement, this code *should* get the status of the user, print the user name to the screen 
               // to demonstrate it has been received, then write the user name, location and tweet id to the DB. Finally, it should
               // print this information out to the screen. At the moment, it prints the user name but nothing after that works...
                @Override
                public void onStatus(Status status) {
                User user = status.getUser();
                String username = user.getScreenName();
                String text = status.getText();
                long tweetId = status.getId();
                long inReplyToStatusId = status.getInReplyToStatusId();
                long inReplyToUserId = status.getInReplyToUserId();
                String inReplyToScreenName = status.getInReplyToScreenName();
                double latitude = status.getGeoLocation().getLatitude();
                double longitude = status.getGeoLocation().getLongitude();
                System.out.println("latitude:" + latitude + ", longitude:" + longitude);
                String isFavorited = status.isFavorited() + "";
                    
                // Print out the tweet and the username
                System.out.println(text);
                System.out.println(username);
                    
                    
                // This block should write the tweet to the DB
                BasicDBObject document = new BasicDBObject(); 
                document.put("tweetId", tweetId);
                document.put("screenName", username);
                document.put("text", text);
                document.put("inReplyToStatusId", inReplyToStatusId);
                document.put("inReplyToUserId", inReplyToUserId);
                document.put("inReplyToScreenName", inReplyToScreenName);
                document.put("latitude", latitude);
                document.put("longitude", longitude);
                document.put("isFavorited", isFavorited);
                            
                table.insert(document);
                    
                // This line never executes - :(
                System.out.println("Printed to the db.");
                                    
                }

            }
        };
        
       // Filter query allows us to include an array of search terms to filter tweets:
        String keywords[] = {"#sad","#frustrated"};
        FilterQuery fq = new FilterQuery();
        fq.track(keywords);
        twitterStream.addListener(listener);
        twitterStream.filter(fq);  
    
	} catch (UnknownHostException e) {		
		e.printStackTrace();
	}
   }
}