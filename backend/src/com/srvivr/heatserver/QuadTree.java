package com.srvivr.heatserver;

import java.awt.geom.Rectangle2D;
import java.util.ArrayList;
import java.util.List;

import com.srvivr.fetcher.Sighting;

/**
 * A Quadtree implementation designed to store Sightings.
 * Based on http://algs4.cs.princeton.edu/92search/QuadTree.java.html
 * 
 * @author Ian
 * 
 */
public class QuadTree {
    private SightingNode root;

    private class SightingNode {
        private final float x, y;
        private final Sighting sighting;

        SightingNode NW, NE, SE, SW;


        SightingNode(Sighting s) {
            this.x = s.lng;
            this.y = s.lat;
            this.sighting = s;
        }
    }


    public void insert(Sighting s) {
        root = insert(root, s);
    }


    private SightingNode insert(SightingNode h, Sighting s) {
        float x = s.lng;
        float y = s.lat;
        if (h == null) {
            return new SightingNode(s);
        } else if (x < h.x && y < h.y) {
            h.SW = insert(h.SW, s);
        } else if (x < h.x && !(y < h.y)) {
            h.NW = insert(h.NW, s);
        } else if (!(x < h.x) && y < h.y) {
            h.SE = insert(h.SE, s);
        } else if (!(x < h.x) && !(y < h.y)) {
            h.NE = insert(h.NE, s);
        }
        return h;
    }


    public List<Sighting> query2D(Rectangle2D.Float rect) {
        List<Sighting> sightings = new ArrayList<Sighting>();
        query2D(root, rect, sightings);
        return sightings;
    }


    private void query2D(SightingNode h, Rectangle2D.Float rect, List<Sighting> list) {
        if (h == null) {
            return;
        }

        float xmin = rect.x;
        float ymin = rect.y;
        float xmax = rect.x + rect.width;
        float ymax = rect.y + rect.height;

        if (rect.contains(h.x, h.y)) {
            list.add(h.sighting);
        }
        if (xmin < h.x && ymin < h.y) {
            query2D(h.SW, rect, list);
        }
        if (xmin < h.x && !(ymax < h.y)) {
            query2D(h.NW, rect, list);
        }
        if (!(xmax < h.x) && ymin < h.y) {
            query2D(h.SE, rect, list);
        }
        if (!(xmax < h.x) && !(ymax < h.y)) {
            query2D(h.NE, rect, list);
        }
    }

}