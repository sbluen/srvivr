package com.srvivr.heatserver;

import java.io.FileInputStream;
import java.util.Properties;

import javax.sql.DataSource;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.servlet.ServletContextHandler;
import org.eclipse.jetty.servlet.ServletHolder;

import com.mchange.v2.c3p0.DataSources;

public class Main {
    public static void main(String[] args) throws Exception {
        Class.forName("com.mysql.jdbc.Driver").newInstance();

        Properties props = new Properties();
        props.load(new FileInputStream("config.properties"));

        DataSource unpooledDataSource = DataSources.unpooledDataSource(props.getProperty("url"), props);
        DataSource pooledDataSource = DataSources.pooledDataSource(unpooledDataSource);

        Server server = new Server(3001);
        ServletContextHandler context = new ServletContextHandler(ServletContextHandler.SESSIONS);
        context.setContextPath("/");
        server.setHandler(context);

        Heatmap heatmap = new Heatmap(new QuadTreeCachedMySqlSightingSource(pooledDataSource));
        context.addServlet(new ServletHolder(new HeatServlet(heatmap)), "/heatmap");
        context.addServlet(new ServletHolder(new CacheServlet("tiles/")), "/cache");

        server.start();

    }

}
