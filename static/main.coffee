
initialize = ->
    console.log window.httpUrl
    $.get window.httpUrl + 'api/v1/loc', (data) ->
        mapOptions =
            zoom: 14
            center: myLoc = new google.maps.LatLng(data.lat, data.lng)

        console.log data
    
        map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

        marker = new google.maps.Marker
          position: myLoc,
          map: map,
          title: 'current location'

        infowindow = new google.maps.InfoWindow content: "<div>" + new Date(data.time) + "</div>"
        google.maps.event.addListener marker, 'click', -> 
            infowindow.open(map,marker);
            
        
        $.get window.httpUrl + 'api/v1/locSeries', (data) ->
            points = []
            data = data.split('\n')
            data.forEach (entry) ->
                if not entry then return
                point = JSON.parse(entry)
                points.push new google.maps.LatLng(point.lat, point.lng)

            path = new google.maps.Polyline
                path: points,
                geodesic: true,
                strokeColor: '#FF0000',
                strokeOpacity: 1.0,
                strokeWeight: 2
            path.setMap map



$('document').ready initialize

