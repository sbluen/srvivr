package com.srvivr.fetcher;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;

import com.srvivr.fetcher.plugins.TwitterFetcher;

public abstract class StreamingBasePlugin extends BasePlugin {

	static class ConnectionManager implements Runnable {
		final static double minimumMinutesPerRun = 5.0;
		
		final StreamingBasePlugin plugin;
		public ConnectionManager(StreamingBasePlugin plugin) { this.plugin = plugin; }
		
		@Override public void run() {
			long start = System.currentTimeMillis();
			long runCount = 0;
			do {
				++runCount;
				//System.out.println("StreamingBasePlugin.ConnectionManager.run(): Calling plugin.run()");
				plugin.run();
				//System.out.println("StreamingBasePlugin.ConnectionManager.run(): Finished plugin.run()");
				long goalRunTime = (long)(minimumMinutesPerRun*60.0*1000.0) * runCount;
				long diff = goalRunTime - (System.currentTimeMillis()-start);
				if(diff > 0)
					try { Thread.sleep(diff); }
					catch (InterruptedException e) { break; }
			} while(true);
		}
		
	}
	
	HttpURLConnection stream;
	
	public StreamingBasePlugin(Connection connection) throws SQLException {
		super(connection);
	}

	public BufferedReader connect(URL url, String usernamePassword, Map<String, String> params) throws UnsupportedEncodingException, IOException {
		String urlParams = "";
		for(String key : params.keySet()) {
			if(urlParams.length() > 0) urlParams += "&";
			urlParams += URLEncoder.encode(key, "UTF-8") + "=" + URLEncoder.encode(params.get(key), "UTF-8");
		}

		stream = (HttpURLConnection) url.openConnection();
				//new Proxy(Proxy.Type.HTTP, new InetSocketAddress("localhost", 8080)));

		if(usernamePassword != null)
			stream.setRequestProperty(
					"Authorization",
					"Basic " + new String(Base64.encodeBase64(usernamePassword.getBytes()))
			);
		
		stream.setRequestMethod("POST");
		stream.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
		stream.setRequestProperty("Content-Length", "" + Integer.toString(urlParams.getBytes().length));

		stream.setUseCaches(false);
		stream.setDoInput(true);
		stream.setDoOutput(true);
		
		DataOutputStream wr = new DataOutputStream(stream.getOutputStream());
		wr.writeBytes (urlParams);
		wr.flush(); wr.close();
		
		BufferedReader in = new BufferedReader(new InputStreamReader(stream.getInputStream()));
		return in;
	}
	
	public void disconnect() { if(stream != null) stream.disconnect(); stream = null; }
	
	@Override public void schedule() { //must be non-blocking
		//System.out.println("StreamingBasePlugin.schedule(): Scheduling!");
		new Thread(new ConnectionManager(this)).start();
	}
	
}
