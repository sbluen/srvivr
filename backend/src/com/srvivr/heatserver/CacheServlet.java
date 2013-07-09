package com.srvivr.heatserver;

import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.eclipse.jetty.server.HttpConnection;

public class CacheServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private File root;
    private int maxLevel;


    public CacheServlet(String rootDir) {
        this.root = new File(rootDir);
        File[] levels = root.listFiles(new FileFilter() {

            @Override
            public boolean accept(File file) {
                return file.isDirectory();
            }
        });
        maxLevel = levels.length; // TODO
    }


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int x = Integer.parseInt(req.getParameter("x"));
        int y = Integer.parseInt(req.getParameter("y"));
        int zoom = Integer.parseInt(req.getParameter("zoom"));

        if (zoom <= maxLevel) {
            String tileName = String.format("map_%d.%d.%d.png", x, y, zoom);
            File tile = new File(root, String.format("%d/%d/%s", zoom, x, tileName));
            ((HttpConnection.Output) resp.getOutputStream()).sendContent(new FileInputStream(tile));
        } else {
            resp.sendRedirect("/heatmap?" + req.getQueryString());
        }
    }
}
