package com.srvivr.heatserver;

import java.awt.image.BufferedImage;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class HeatServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final Heatmap heatmap;
    private BufferedImage blankTile;


    public HeatServlet(Heatmap heatmap) {
        this.heatmap = heatmap;
        this.blankTile = new BufferedImage(256, 256, BufferedImage.TYPE_INT_ARGB);
    }


    @Override
    protected long getLastModified(HttpServletRequest req) {
        return System.currentTimeMillis();
    }


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int x = Integer.parseInt(req.getParameter("x"));
        int y = Integer.parseInt(req.getParameter("y"));
        int zoom = Integer.parseInt(req.getParameter("zoom"));
        BufferedImage tile = heatmap.colorTile(heatmap.getTile(x, y, zoom));

        if (tile == null) {
            tile = blankTile;
        }

        ImageIO.write(tile, "png", resp.getOutputStream());
    }
}
