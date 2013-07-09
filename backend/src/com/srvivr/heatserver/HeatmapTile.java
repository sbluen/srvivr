package com.srvivr.heatserver;

public class HeatmapTile {
    float[][] data;


    public HeatmapTile(int size) {
        data = new float[size][size];
    }


    public float[][] getData() {
        return data;
    }

}
