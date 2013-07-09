package com.srvivr.fetcher.plugins;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

import com.srvivr.fetcher.IntervalBasePlugin;

public class StaleUnfetcher extends IntervalBasePlugin {
	final static String sourceName = "StaleUnfetcher";
	final static long targetMaxEntries = 100000;

	public StaleUnfetcher(Connection connection, Properties properties) throws SQLException {
		super(connection);
	}

	@Override public int getInterval() { return 120; } //every 2 hours
	
	@Override
	public void run() {
		synchronized (connection) {
			try {
				Statement statement = connection.createStatement();
				ResultSet result = statement.executeQuery("SELECT COUNT(*) FROM locations");
				result.first();
				long count = result.getLong(1);
				if(count > targetMaxEntries) {
					result = statement.executeQuery("SELECT id FROM locations ORDER BY id DESC LIMIT 1");
					result.first();
					long top = result.getLong(1);
					statement.executeUpdate("DELETE FROM locations WHERE id < " + (top-targetMaxEntries));
				}
			} catch (SQLException e) { e.printStackTrace(); }
		}
	}

	//@Override public String getUrl() { return null; }

	@Override public String getSourceName() { return sourceName; }

}
