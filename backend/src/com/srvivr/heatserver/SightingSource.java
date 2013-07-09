package com.srvivr.heatserver;

import java.awt.geom.Rectangle2D;
import java.util.List;

import com.srvivr.fetcher.Sighting;

public interface SightingSource {
    public List<Sighting> getSightings(Rectangle2D.Float bounds);
}
