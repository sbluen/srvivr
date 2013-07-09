package com.srvivr.heatserver;

import java.awt.geom.Rectangle2D;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import com.srvivr.fetcher.Sighting;

public class MySqlSightingSource implements SightingSource {

    private static final String STATEMENT = "SELECT lat, lng FROM locations WHERE lat BETWEEN ? and ? AND lng BETWEEN ? and ?";
    private DataSource dataSource;


    public MySqlSightingSource(DataSource ds) throws SQLException {
        this.dataSource = ds;
    }


    @Override
    public List<Sighting> getSightings(Rectangle2D.Float bounds) {
        List<Sighting> sightings = new ArrayList<Sighting>();

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            PreparedStatement statement = connection.prepareStatement(STATEMENT);
            statement.setFloat(1, bounds.y);
            statement.setFloat(2, bounds.y + bounds.height);
            statement.setFloat(3, bounds.x);
            statement.setFloat(4, bounds.x + bounds.width);

            ResultSet results = statement.executeQuery();
            while (results.next()) {
                Sighting s = new Sighting("", results.getFloat(1), results.getFloat(2), 0);
                sightings.add(s);
            }
            results.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    // Ignored.
                }
            }
        }

        return sightings;
    }

}
