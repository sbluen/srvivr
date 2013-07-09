var Map = (function(){
    var map, options, selfMarker, relocationMarker;
    var directionsDisplay = new google.maps.DirectionsRenderer();
    var directionsService = new google.maps.DirectionsService();

    var heatmapOptions = {
        getTileUrl: function(coord, zoom) {
            return "/heatmap?" + "zoom=" + zoom + "&x=" + coord.x + "&y=" + coord.y;
        },
        tileSize: new google.maps.Size(256, 256)
    };

    var heatmapType = new google.maps.ImageMapType(heatmapOptions);

    function calcRoute() {
      var start = selfMarker.getPosition();
      var end = relocationMarker.getPosition();
      var request = {
        origin:start,
        destination:end,
        travelMode: google.maps.TravelMode.WALKING
      };
      directionsService.route(request, function(result, status) {
        if (status == google.maps.DirectionsStatus.OK) {
          directionsDisplay.setDirections(result);
        }
      });
    }

    function initialize(optionsjson) {
        options = optionsjson;
        var myOptions = {
            zoom: options.zoom,
            panControl: false,
            scaleControl: false,
            streetViewControl: false,
            mapTypeControl: true,
            mapTypeControlOptions: {
                style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
            },
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        var mapcanvas = document.getElementById("map_canvas");
        map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
        map.overlayMapTypes.insertAt(0, heatmapType);
        directionsDisplay.setMap(map);

        selfMarker = new google.maps.Marker({
          map: map,
          position: new google.maps.LatLng(options.lat, options.lng), // Goleta, CA
          icon: "http://www.google.com/intl/en_us/mapfiles/ms/micons/blue-dot.png",
          shadow: new google.maps.MarkerImage("http://www.google.com/chart?chst=d_map_pin_shadow",
            new google.maps.Size(37, 34),
            new google.maps.Point(0,0),
            new google.maps.Point(14,35)),
          draggable: true
        });

        relocationMarker = new google.maps.Marker({
          map: map,
          position: new google.maps.LatLng(options.lat, options.lng), // Goleta, CA
          icon: "http://www.google.com/intl/en_ALL/mapfiles/marker_orange.png",
          shadow: new google.maps.MarkerImage("http://www.google.com/chart?chst=d_map_pin_shadow",
            new google.maps.Size(37, 34),
            new google.maps.Point(0,0),
            new google.maps.Point(14,35)),
          draggable: true,
          visible: false
        });

        google.maps.event.addListener(selfMarker, 'dragend', function(){
            var pos = selfMarker.getPosition();
            $.ajax({
                type: "POST",
                url: "/profiles/updatelocation",
                data: {lat: pos.lat(), lng: pos.lng()}
                });
            calcRoute();
        });

        google.maps.event.addListener(relocationMarker, 'dragend', function(){
            calcRoute();
        });

        google.maps.event.addListener(relocationMarker, 'visible_changed', function(){
            calcRoute();
        });

        // Add Home button.
        addMapControl('Home', 'Return to your location.', function(){
          map.panTo(selfMarker.getPosition());
        });

        // Add destination marker
        addMapControl('Relocate', 'Drop a relocation marker.', function(){
          relocationMarker.setPosition(map.getCenter())
          relocationMarker.setVisible(true);  
        });

        function success(position) {
            var pos = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
            selfMarker.setPosition(pos);
            map.setCenter(pos);
        };

        // Try HTML5 geolocation
        if(navigator.geolocation) {
          navigator.geolocation.getCurrentPosition(success, function() {});
        }; // end initialize()

        map.setCenter(selfMarker.getPosition());
  }

  function addMapControl(name, description, onClickFunction){
    var controlDiv = document.createElement('DIV');
    $(controlDiv).addClass("controldiv");
    var controlUI = document.createElement('DIV');
    $(controlUI).addClass("controlui");
    controlUI.title = description;
    controlDiv.appendChild(controlUI);
    var controlText = document.createElement('DIV');
    $(controlText).addClass("controltext");
    controlText.innerHTML = name;
    controlUI.appendChild(controlText);

    google.maps.event.addDomListener(controlUI, 'click', onClickFunction);

    controlDiv.index = 1;
    map.controls[google.maps.ControlPosition.TOP_RIGHT].push(controlDiv);
  }

  // Set public methods.
  return{
     initialize: initialize
  };

}());