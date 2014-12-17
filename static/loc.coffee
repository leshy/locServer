
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
            zoom: 11
            center: myLoc = new google.maps.LatLng(data.lat, data.lng)
            mapTypeControlOptions: {
              mapTypeIds: [google.maps.MapTypeId.ROADMAP,google.maps.MapTypeId.SATELLITE,google.maps.MapTypeId.HYBRID,"Terminator"]
            },
            mapTypeId: google.maps.MapTypeId.ROADMAP

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
        infowindow.open(map,marker);


$('document').ready initialize

