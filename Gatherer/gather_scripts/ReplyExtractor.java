package gather;

import java.util.regex.Matcher;
import java.util.regex.Pattern;


// A simple class that extracts the number of replies associated with a tweet.

public class ReplyExtractor {
   
	String numberOfReplies;
	
	public ReplyExtractor () {		
	}
	
	public int replyCounter(String rawText) {

	 	int count = 0;
     	Pattern pattern = Pattern.compile("in_reply_to_status_id_str");
     	Matcher matcher = pattern.matcher(rawText);
     
        while (matcher.find())
        count++;
    return count;    
	}

}
