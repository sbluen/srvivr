package com.srvivr.heatserver;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.geom.Point2D;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.imageio.ImageIO;

import com.srvivr.fetcher.Sighting;

public class Heatmap {

    private final SightingSource dataSource;
    private MercatorProjection mercator;
    private BufferedImage blob;
    private BufferedImage gradient;


    public Heatmap(SightingSource source) throws IOException {
        this.dataSource = source;
        this.mercator = new MercatorProjection();
        this.blob = ImageIO.read(new File("blob.png"));
        this.gradient = ImageIO.read(new File("gradient.png"));
    }


    public BufferedImage getTile(int x, int y, int zoom) {
        BufferedImage tile = new BufferedImage(256 * 3, 256 * 3, BufferedImage.TYPE_INT_ARGB);
        Graphics2D g = (Graphics2D) tile.getGraphics();
        double twoToZoom = Math.pow(2, zoom);

        boolean hadSightings = false;
        for (int tileX = -1; tileX < 2; tileX++) {
            for (int tileY = -1; tileY < 2; tileY++) {
                Rectangle2D.Float bounds = getLatLong(x + tileX, y + tileY, zoom);
                List<Sighting> sightings = dataSource.getSightings(bounds);
                for (Sighting s : sightings) {
                    hadSightings = true;
                    Point2D.Double world = mercator.latLngToWorld(s.lat, s.lng);
                    int pixelX = ((int) (world.x * twoToZoom)) % 256 + 256 * (tileX + 1);
                    int pixelY = ((int) (world.y * twoToZoom)) % 256 + 256 * (tileY + 1);

                    // TODO: Accumulate 2D Gaussian functions in a float array instead (the current method only has 8-bit precision).
                    g.drawImage(blob, (int) (pixelX - 32), (int) (pixelY - 32), null);
                }
            }
        }

        return hadSightings ? tile.getSubimage(256, 256, 256, 256) : null;
    }


    public BufferedImage colorTile(BufferedImage tile) {
        if (tile != null) {
            for (int y = 0; y < tile.getHeight(); y++) {
                for (int x = 0; x < tile.getWidth(); x++) {
                    int value = new Color(tile.getRGB(x, y), true).getAlpha();
                    Color color = new Color(gradient.getRGB(value, 0), true);
                    tile.setRGB(x, y, color.getRGB());
                }
            }
        }
        return tile;
    }


    /**
     * Adapted from http://www.ponies.me.uk/maps/GoogleTileUtils.java
     * 
     * @param tileX
     * @param tileY
     * @param zoom
     * @return
     */
    private Rectangle2D.Float getLatLong(int tileX, int tileY, int zoom) {
        int pixelX = tileX * 256;
        int pixelY = tileY * 256;
        double twoToZoom = Math.pow(2, zoom);
        double worldX = pixelX / twoToZoom;
        double worldY = pixelY / twoToZoom;

        double x = tileX;
        double y = tileY;

        double lon = -180; // x
        double lonWidth = 360; // width 360

        // double lat = -90; // y
        // double latHeight = 180; // height 180
        double lat = -1;
        double latHeight = 2;

        int tilesAtThisZoom = (int) Math.pow(2, zoom);
        lonWidth = 360.0 / tilesAtThisZoom;
        lon = -180 + (x * lonWidth);
        latHeight = -2.0 / tilesAtThisZoom;
        lat = 1 + (y * latHeight);

        // convert lat and latHeight to degrees in a mercator projection
        // note that in fact the coordinates go from
        // about -85 to +85 not -90 to 90!
        latHeight += lat;
        latHeight = (2 * Math.atan(Math.exp(Math.PI * latHeight))) -
                (Math.PI / 2);
        latHeight *= (180 / Math.PI);

        lat = (2 * Math.atan(Math.exp(Math.PI * lat))) - (Math.PI / 2);
        lat *= (180 / Math.PI);

        latHeight -= lat;

        if (lonWidth < 0) {
            lon = lon + lonWidth;
            lonWidth = -lonWidth;
        }

        if (latHeight < 0) {
            lat = lat + latHeight;
            latHeight = -latHeight;
        }

        return new Rectangle2D.Float((float) lon, (float) lat, (float) lonWidth, (float) latHeight);
    }
}
