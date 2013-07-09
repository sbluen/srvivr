package com.srvivr.fetcher.plugins;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.srvivr.fetcher.Sighting;
import com.srvivr.fetcher.StreamingBasePlugin;

public class TwitterFetcher extends StreamingBasePlugin {
	final static String sourceName = "Twitter";
	
	String account; //username:password
	
	public TwitterFetcher(Connection connection, Properties properties) throws SQLException {
		super(connection);
		account = properties.getProperty("account");
	}

	@Override public String getSourceName() { return sourceName; }

	@Override public void run() {
		try {
			URL url = new URL("https", "stream.twitter.com", "/1/statuses/filter.json");
			Map<String, String> params = new HashMap<String, String>();
			params.put("locations", "-180,-90,180,90");

			//System.out.println("TwitterFetcher.run(): Establishing Connection...");
			BufferedReader in = connect(url, account, params); 
			//System.out.println("TwitterFetcher.run(): Connected");

			//int count = 0;
			do {
				String line = "";
				int next;
				do {
					next = in.read();
					if(next == -1 || next == '\r') break;
					line += (char) next;
				} while(true);
				if(next == -1) break;
				
				//System.out.println("TwitterFetcher.run(): Got a tweet line");
				processTwitterItem(line);
				//if(++count > 50) break;
			} while(true);
			
			disconnect();
		}
		catch (MalformedURLException e) { e.printStackTrace(); }
		catch (IOException   e) { e.printStackTrace(); }
		catch (JSONException e) { e.printStackTrace(); }
		catch (SQLException  e) { e.printStackTrace(); }
	}

	private void processTwitterItem(String entry) throws JSONException, SQLException {
		JSONObject object = new JSONObject(entry);
		
		if(object.has("delete")) {
			
		} else if(object.has("scrub_geo")) {
			
		} else if(object.has("limit")) {
			
		} else if(object.has("id")) {
			long id = object.getLong("id_str"); //"id_str" recommended over "id"
			String time = object.getString("created_at");
			
			long millis = Date.parse(time);

			//System.out.println("ID: " + id);
			//System.out.println("Created At: " + time);
			//System.out.println("            " + new Date(millis)); //compare with re-parsed time

			if(!object.getString("coordinates").equals("null")) {
				JSONObject coords = object.getJSONObject("coordinates");
				if(coords.getString("type").equals("Point")) {
					JSONArray lnglat = coords.getJSONArray("coordinates");
					writeSighting(new Sighting(assembleUID(""+id), (float)lnglat.getDouble(1), (float)lnglat.getDouble(0), millis));
				} else {
					System.out.println("Unsupported {coordinates > type}... " + coords);
				}
			} else {
				return; //we only want precise points
//				JSONObject place = object.getJSONObject("place");
//				JSONObject bb = place.getJSONObject("bounding_box");
//				if(bb.getString("type").equals("Polygon")) {
//					// Currently just averages all the vertices, including the "hole" contours
//					double lat = 0, lng = 0;
//					int count = 0;
//					JSONArray polygon = bb.getJSONArray("coordinates");
//					for(int c = 0; c < polygon.length(); ++c) {
//						JSONArray contour = polygon.getJSONArray(c);
//						for(int i = 0; i < contour.length(); ++i) {
//							JSONArray lnglat = contour.getJSONArray(i);
//							lng += lnglat.getDouble(0);
//							lat += lnglat.getDouble(1);
//							++count;
//						}
//					}
//					lat /= count;
//					lng /= count;
//					writeSighting(new Sighting(lat, lng, millis));
//				} else {
//					System.out.println("Unsupported {place > bounding_box > type}... " + bb);
//				}
			}
		} else {
			//for(String s : object.getNames(object) )
			//	System.out.println(s);
		}
	}
	
	//@Override public void writeSighting(Sighting sighting) throws SQLException { System.out.println(sighting); super.writeSighting(sighting); }
	
	static public void main(String[] params) throws SQLException, IOException, JSONException, ParseException {
		Properties prop = new Properties();
		prop.load(new FileInputStream("TwitterFetcher.properties"));
		TwitterFetcher tf = new TwitterFetcher(null, prop);
		
		tf.run();
	}

}
