package com.srvivr.heatserver;

import java.awt.geom.Point2D;

public class MercatorProjection {

    private static final int TILE_SIZE = 256;
    private double pixelsPerLonRadian;
    private double pixelsPerLonDegree;
    private double originX;
    private double originY;


    public MercatorProjection() {
        this.originX = this.originY = TILE_SIZE / 2.0;
        this.pixelsPerLonDegree = TILE_SIZE / 360.0;
        this.pixelsPerLonRadian = TILE_SIZE / (2.0 * Math.PI);
    }


    public Point2D.Double worldToLatLng(double worldX, double worldY) {
        double lng = (worldX - originX) / pixelsPerLonDegree;
        double latRadians = (worldY - originY) / -pixelsPerLonRadian;
        double lat = Math.toDegrees(2.0 * Math.atan(Math.exp(latRadians)) -
                Math.PI / 2.0);
        return new Point2D.Double(lng, lat);
    }


    public Point2D.Double latLngToWorld(double lat, double lng) {
        Point2D.Double point = new Point2D.Double();

        point.x = originX + lng * pixelsPerLonDegree;

        double siny = Math.min(Math.max(Math.sin(Math.toRadians(lat)), -0.9999),
                0.9999);
        point.y = originY + 0.5 * Math.log((1 + siny) / (1 - siny)) *
                -pixelsPerLonRadian;
        return point;
    }
}
