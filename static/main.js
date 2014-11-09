// Generated by CoffeeScript 1.7.1
(function() {
  var initialize;

  initialize = function() {
    console.log(window.httpUrl);
    return $.get(window.httpUrl + 'api/v1/loc', function(data) {
      var infowindow, map, mapOptions, marker, myLoc;
      mapOptions = {
        zoom: 14,
        center: myLoc = new google.maps.LatLng(data.lat, data.lng)
      };
      console.log(data);
      map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
      marker = new google.maps.Marker({
        position: myLoc,
        map: map,
        title: 'current location'
      });
      infowindow = new google.maps.InfoWindow({
        content: "<div>" + new Date(data.time) + "</div>"
      });
      google.maps.event.addListener(marker, 'click', function() {
        return infowindow.open(map, marker);
      });
      return $.get(window.httpUrl + 'api/v1/locSeries', function(data) {
        var counter, path, points;
        points = [];
        data = data.split('\n');
        counter = 0;
        data.forEach(function(entry) {
          var point;
          if (!entry) {
            return;
          }
          counter++;
          point = JSON.parse(entry);
          return points.push(new google.maps.LatLng(point.lat, point.lng));
        });
        path = new google.maps.Polyline({
          path: points,
          geodesic: true,
          strokeColor: '#ff0000',
          strokeOpacity: 0.3,
          strokeWeight: 2
        });
        return path.setMap(map);
      });
    });
  };

  $('document').ready(initialize);

}).call(this);
