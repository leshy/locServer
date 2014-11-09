
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
          title: 'Hello World!'


        infowindow = new google.maps.InfoWindow content: "<div>" + new Date(data.time) + "</div>"
        google.maps.event.addListener marker, 'click', -> 
            infowindow.open(map,marker);



    console.log map

$('document').ready initialize

