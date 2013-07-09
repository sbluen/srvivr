package com.srvivr.fetcher;

import com.google.common.base.Objects;

public class Sighting {
    public float lat, lng;
    long timestamp; //UTC
    String uid; //Source:DomainSpecificUID

    public Sighting(String ComposedUID, float lat, float lon, long timestamp) {
        this.lat = lat;
        this.lng = lon;
        this.timestamp = timestamp;
    }


    @Override
    public String toString() {
        return Objects.toStringHelper(this).add("lat", lat).add("lng", lng).toString();
    }

}
