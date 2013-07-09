package com.srvivr.heatserver;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Date;
import java.util.Properties;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.ThreadPoolExecutor.CallerRunsPolicy;
import java.util.concurrent.TimeUnit;

import javax.imageio.ImageIO;
import javax.sql.DataSource;

import com.mchange.v2.c3p0.DataSources;

public class OfflineRenderer {
    private Heatmap heatmap;
    private ExecutorService pool;


    public static void main(String[] args) throws InstantiationException, IllegalAccessException,
            ClassNotFoundException, FileNotFoundException, IOException, SQLException {
        Runtime.getRuntime().addShutdownHook(new Thread() {

            @Override
            public void run() {
                System.out.println(new Date());
            }

        });

        Class.forName("com.mysql.jdbc.Driver").newInstance();

        Properties props = new Properties();
        props.load(new FileInputStream("config.properties"));

        DataSource unpooledDataSource = DataSources.unpooledDataSource(props.getProperty("url"), props);
        DataSource pooledDataSource = DataSources.pooledDataSource(unpooledDataSource);

        OfflineRenderer renderer = new OfflineRenderer(pooledDataSource);
        renderer.renderLevels(1, 8);
    }


    public OfflineRenderer(DataSource pooledDataSource) throws IOException, SQLException {
        heatmap = new Heatmap(new QuadTreeCachedMySqlSightingSource(pooledDataSource));
        pool = new ThreadPoolExecutor(7, 7, 0, TimeUnit.SECONDS, new ArrayBlockingQueue<Runnable>(8),
                new CallerRunsPolicy());
    }


    public void renderLevels(int from, int to) {
        System.out.println(new Date());
        for (int zoom = from; zoom <= to; zoom++) {
            pool.execute(new ZoomTask(zoom));
        }
    }

    private class ZoomTask implements Runnable {
        private final int zoom;


        public ZoomTask(int zoom) {
            this.zoom = zoom;
        }


        @Override
        public void run() {
            int levelTiles = (int) Math.pow(2, zoom);
            for (int x = 0; x < levelTiles; x++) {
                File dir = new File(String.format("tiles/%d/%d", zoom, x));
                dir.mkdirs();
                for (int y = 0; y < levelTiles; y++) {
                    BufferedImage tile = heatmap.colorTile(heatmap.getTile(x, y, zoom));
                    //System.out.printf("%d:%d,%d\n", zoom, x, y);
                    if (tile != null) {
                        try {
                            ImageIO.write(tile, "png",
                                    new File(dir, String.format("map_%d.%d.%d.png", x, y, zoom)));
                        } catch (IOException e) {
                            System.err.println("\tUnable to write image");
                            e.printStackTrace();
                        }
                    }
                }
            }
        }

    }
}
