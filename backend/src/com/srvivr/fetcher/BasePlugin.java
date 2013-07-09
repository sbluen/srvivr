package com.srvivr.fetcher;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;

public abstract class BasePlugin implements Runnable {

    protected final Connection connection;
    private PreparedStatement insertStatement;
    private HttpClient client;


    public BasePlugin(Connection connection) throws SQLException {
        this.connection = connection;
        this.insertStatement = connection.prepareStatement("INSERT INTO locations (lat,lng,created_at,Source_plus_UID) values (?,?,?,?)");
        client = new DefaultHttpClient();
    }

    public abstract String getSourceName();
    public String assembleUID(String UID) { return getSourceName() + ":" + UID; }
    public abstract void schedule();

    public String httpGet(String url) throws ClientProtocolException, IOException {
        HttpGet get = new HttpGet(url);
        String response = client.execute(get, new BasicResponseHandler());
        System.out.println(response);
        return response;
    }

    public void writeSighting(Sighting sighting) throws SQLException {
		synchronized (connection) {
		    insertStatement.setDouble(1, sighting.lat);
		    insertStatement.setDouble(2, sighting.lng);
		    insertStatement.setTimestamp(3, new Timestamp(sighting.timestamp));
		    insertStatement.setString(4, sighting.uid);
		    insertStatement.executeUpdate();
		}
    }

    // @Override
    // public void run() {
    // String url = getUrl();
    // try {
    // String response = httpGet(url);
    // List<Sighting> sightings = parse(response);
    // for (Sighting s : sightings) {
    // try {
    // writeSighting(s);
    // } catch (SQLException e) {
    // e.printStackTrace();
    // }
    // }
    // } catch (ClientProtocolException e) {
    // e.printStackTrace();
    // } catch (IOException e) {
    // e.printStackTrace();
    // }
    // }

}
