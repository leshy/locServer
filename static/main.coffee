
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
            counter = 0
            data.forEach (entry) ->
                if not entry then return
                counter++
#                if counter > 100 then return
                point = JSON.parse(entry)
                points.push new google.maps.LatLng(point.lat, point.lng)

#                circle = new google.maps.Circle
#                    map: map
#                    center: new google.maps.LatLng(point.lat, point.lng)
#                    radius: 5
#                    strokeColor: '#0000ff',
#                    strokeOpacity: 0.8,
#                    strokeWeight: 0,
#                    fillColor: '#0000ff',
#                    fillOpacity: 0.35,

                    
            path = new google.maps.Polyline
                path: points,
                geodesic: true,
                strokeColor: '#ff0000',
                strokeOpacity: 0.3,
                strokeWeight: 2
            path.setMap map



$('document').ready initialize

