package com.srvivr.fetcher;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class Fetcher {
    static List<BasePlugin> plugins = new ArrayList<BasePlugin>();


    public static void main(String[] args) throws SQLException, FileNotFoundException, IOException {
        Properties props = new Properties();
        props.load(new FileInputStream("config.properties"));
        Connection connection = DriverManager.getConnection(props.getProperty("url"), props);

        String[] names = props.getProperty("plugins").split(",");

        for (String name : names) {
            name = name.trim();
            if (name.startsWith("#")) {
                continue;
            }
            try {
            	Class<?> clazz = Class.forName(name);
                Properties p = new Properties();
                p.load(new FileInputStream(clazz.getSimpleName() + ".properties"));
                BasePlugin plugin = (BasePlugin) clazz.getConstructor(Connection.class, Properties.class).newInstance(
                		connection, p);
                plugins.add(plugin);

                System.out.println("Initialized plugin " + name);
            }
            catch (SecurityException         e) { e.printStackTrace(); }
            catch (NoSuchMethodException     e) { e.printStackTrace(); }
            catch (ClassNotFoundException    e) { e.printStackTrace(); }
            catch (IllegalArgumentException  e) { e.printStackTrace(); }
            catch (InstantiationException    e) { e.printStackTrace(); }
            catch (IllegalAccessException    e) { e.printStackTrace(); }
            catch (InvocationTargetException e) { e.printStackTrace(); }
        }

		for (BasePlugin p : plugins)
			p.schedule();
    }
}
