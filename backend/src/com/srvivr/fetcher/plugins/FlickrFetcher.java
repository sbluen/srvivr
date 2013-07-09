package com.srvivr.fetcher.plugins;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import org.apache.http.client.ClientProtocolException;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.srvivr.fetcher.IntervalBasePlugin;
import com.srvivr.fetcher.Sighting;

public class FlickrFetcher extends IntervalBasePlugin {
	final static String sourceName = "Flickr";

    private String searchUrl;
    private String apiKey;


    public FlickrFetcher(Connection connection, Properties properties) throws SQLException {
        super(connection);
        apiKey = properties.getProperty("api_key");
        searchUrl = String
                .format(
                        "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%s&has_geo=1&format=json&nojsoncallback=1",
                        apiKey);
    }

    @Override public String getSourceName() { return sourceName; }
    //@Override public String getUrl() { return "http://klop.in"; }


    public List<String> parseSearch(String body) throws JSONException {
        List<String> photoIds = new ArrayList<String>();

        JSONObject object = new JSONObject(body);
        JSONArray photos = object.getJSONObject("photos").getJSONArray("photo");

        for (int i = 0; i < photos.length(); i++) {
            JSONObject photo = photos.getJSONObject(i);
            photoIds.add(photo.getString("id"));
        }

        return photoIds;
    }


    @Override
    public void run() {
        List<Sighting> sightings = new ArrayList<Sighting>();

        try {
            List<String> photos = parseSearch(httpGet(searchUrl));
            for (String photo : photos) {
                String photoUrl = String
                        .format("http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=%s&photo_id=%s&format=json&nojsoncallback=1",
                                apiKey, photo);
                sightings.add(parsePhoto(httpGet(photoUrl)));
            }

        } catch (ClientProtocolException e) {
            e.printStackTrace();
        } catch (JSONException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        for (Sighting s : sightings) {
            try {
                writeSighting(s);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }


    private Sighting parsePhoto(String response) throws JSONException {
        JSONObject o = new JSONObject(response);
        JSONObject photo = o.getJSONObject("photo");
        String photoID = photo.getString("id");
        JSONObject location = photo.getJSONObject("location");
        return new Sighting(assembleUID(photoID), (float)location.getDouble("latitude"), (float)location.getDouble("longitude"),
                photo.getLong("dateuploaded") * 1000);
    }

}
