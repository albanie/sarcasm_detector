package gather_scripts;

import com.google.gson.JsonArray;
import com.google.gson.JsonParser;
import com.mongodb.*;
import com.mongodb.util.JSON;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.UnknownHostException;
import java.util.Arrays;
import java.util.Date;
import java.util.Scanner;
import org.bson.types.ObjectId;
import org.json.JSONArray;
import twitter4j.internal.org.json.JSONException;
import twitter4j.internal.org.json.JSONObject;
import twitter4j.json.DataObjectFactory;
import gather.ReplyExtractor;

public class ReplyGatherer {

	public static void main(String[] args) throws org.json.JSONException {

		try {

			// Connect to the database server on port 27017, retrieve the
			// tweetDB database and
			// find the tweetArchive collection.
			MongoClient mongo = new MongoClient("localhost", 27017);
			DB db = mongo.getDB("GEOtweetDB");
			DBCollection table = db.getCollection("GEOtweetSarcasm");
			DBCollection table2 = db.getCollection("GEOtweetSarcasmReplies");

			// Iterate over entries from the collection of tweets using the
			// cursor.
			// 	THIS STARTS FROM THE BEGINNING OF THE FILE:
			DBCursor cursor = table.find().addOption(Bytes.QUERYOPTION_NOTIMEOUT);
			
			while (cursor.hasNext()) {

				String storedTweet = cursor.next().toString();

				try {

					JSONObject jsonObj = new JSONObject(storedTweet);
					String tweetIdString = (jsonObj.get("tweetId")).toString();
					System.out.println(tweetIdString);
					String objectId = (jsonObj.get("_id")).toString();

					try {

						//We force the script to sleep to prevent it from going over the Twitter API limit.
						Thread.sleep(16000);

					} catch (InterruptedException ex) {

						Thread.currentThread().interrupt();
					}

					try {

						// Use the following twitter API URL to retrieve replies:
						URL url = new URL("https://api.twitter.com/1/related_results/show/" + tweetIdString
								+ ".json?include_entities=1");
						HttpURLConnection conn = (HttpURLConnection) url.openConnection();
						conn.setRequestMethod("GET");
						conn.setRequestProperty("Accept", "application/json");
						
						if (conn.getResponseCode() == 403 || conn.getResponseCode() == 400) {
							try {

								System.out.println("Reached API rate limit.");

								//Put the script to sleep before retrying.
								Thread.sleep(60000);
								BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
								String output;

								while ((output = br.readLine()) != null) {

									System.out.println(output);
									ReplyExtractor extractor = new ReplyExtractor();
									int numberOfReplies = extractor.replyCounter(output);
									System.out.println(numberOfReplies);

									if (output.length() == 2) {

										BasicDBObject doc = new BasicDBObject();
										doc.put("relates_to_obj_id", (jsonObj.get("_id")).toString());
										doc.put("responds_to_tweet_id",tweetIdString );
										doc.put("number_of_replies", numberOfReplies);
										table2.insert(doc);
									}

									else {
										
										String content = output.substring(1, output.length() - 1);
										DBObject dbObject = (DBObject) JSON.parse(content);
										System.out.println(Arrays.toString(dbObject.keySet().toArray()));
										dbObject.put("relates_to_obj_id",(jsonObj.get("_id")).toString());
										dbObject.put("responds_to_tweet_id", (tweetIdString));
										dbObject.put("number_of_replies", numberOfReplies);
										System.out.println(Arrays.toString(dbObject.keySet().toArray()));
										table2.insert(dbObject);
									}
								}

							} catch (InterruptedException ex) {

								Thread.currentThread().interrupt();
							}
						}
							
						else if (conn.getResponseCode() != 200) {
					
							throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
							}

							else {

						BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));

						String output;
						System.out.println("Collecting something.");
						while ((output = br.readLine()) != null) {

							System.out.println(output);
							ReplyExtractor extractor = new ReplyExtractor();
							int numberOfReplies = extractor.replyCounter(output);
							System.out.println(numberOfReplies);
							if (output.length() == 2) {
								BasicDBObject doc = new BasicDBObject();
								doc.put("relates_to_obj_id", (jsonObj.get("_id")).toString());
								doc.put("responds_to_tweet_id",tweetIdString );
								doc.put("number_of_replies", numberOfReplies);
								table2.insert(doc);
							}
							else {
								
							String content = output.substring(1, output.length() - 1);
							DBObject dbObject = (DBObject) JSON.parse(content);
							System.out.println(Arrays.toString(dbObject.keySet().toArray()));
							dbObject.put("relates_to_obj_id",(jsonObj.get("_id")).toString());
							dbObject.put("responds_to_tweet_id", (tweetIdString));
							dbObject.put("number_of_replies", numberOfReplies);
							System.out.println(Arrays.toString(dbObject.keySet().toArray()));
							table2.insert(dbObject);					
							}

						}
					}

						conn.disconnect();

					} catch (MalformedURLException e) {

						e.printStackTrace();

				} catch (IOException e) {

						e.printStackTrace();
					}

				} catch (JSONException e) {
	
					e.printStackTrace();
		      }

		  }

		} catch (UnknownHostException e) {

			e.printStackTrace();

		} catch (MongoException e) {

			e.printStackTrace();
		}

	}
}
