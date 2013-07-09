package com.srvivr.heatserver;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import com.srvivr.fetcher.Sighting;

public class QuadTreeCachedMySqlSightingSource implements SightingSource {

    private QuadTree cache;
    private final DataSource ds;


    public QuadTreeCachedMySqlSightingSource(DataSource ds) {
        this.ds = ds;
        cache = new QuadTree();
        try {
            fillCache();
        } catch (SQLException e) {
            e.printStackTrace();
            // TODO
        }
    }


    @Override
    public List<Sighting> getSightings(java.awt.geom.Rectangle2D.Float bounds) {
        return cache.query2D(bounds);
    }


    private void fillCache() throws SQLException {
        ResultSet resultSet = ds.getConnection().createStatement().executeQuery("SELECT lat, lng FROM locations");
        int size = 0;
        while (resultSet.next()) {
            Sighting s = new Sighting("", resultSet.getFloat(1), resultSet.getFloat(2), 0);
            cache.insert(s);
            size++;
        }
        System.out.printf("Cached %d sightings\n", size);
        resultSet.close();
    }

}
