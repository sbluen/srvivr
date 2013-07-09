package com.srvivr.fetcher;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public abstract class IntervalBasePlugin extends BasePlugin {

	static ScheduledExecutorService pool = Executors.newScheduledThreadPool(10);

	public IntervalBasePlugin(Connection connection) throws SQLException {
		super(connection);
	}

    //public abstract String getUrl();

    /**
     * Return interval in minutes.
     */
    public int getInterval() {
        return 1;
    }

    @Override
    public void schedule() {
		pool.scheduleWithFixedDelay(this, 0, getInterval(), TimeUnit.MINUTES);
    }
}
