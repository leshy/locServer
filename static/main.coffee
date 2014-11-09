
initialize = ->
    console.log window.httpUrl
    $.get window.httpUrl + 'api/v1/loc', (data) ->

        featureOpts = [
            {
              stylers: [
                { hue: '#008900' },
                { visibility: 'simplified' },
                { gamma: 0.5 },
                { weight: 0.5 }
              ]
            },
            {
              elementType: 'labels',
              stylers: [
                { visibility: 'off' }
              ]
            },
            {
              featureType: 'water',
              stylers: [
                { color: '#008900' }
              ]
            }
          ]


        mapOptions =
            zoom: 18
            center: myLoc = new google.maps.LatLng(data.lat, data.lng)
            mapTypeControlOptions: {
              mapTypeIds: [google.maps.MapTypeId.ROADMAP,google.maps.MapTypeId.SATELLITE,google.maps.MapTypeId.HYBRID,"Terminator"]
            },
            mapTypeId: google.maps.MapTypeId.SATELLITE

        console.log data
    
        map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

        customMapType = new google.maps.StyledMapType featureOpts, { name: 'Terminator' }

        map.mapTypes.set "Terminator", customMapType



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
                strokeOpacity: 0.7,
                strokeWeight: 2
            path.setMap map



$('document').ready initialize

