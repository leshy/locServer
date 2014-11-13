
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
            zoom: 1
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

#        panoramioLayer = new google.maps.panoramio.PanoramioLayer();
#        panoramioLayer.setMap(map);
#
#        photoPanel = document.getElementById('photo-panel');
#        map.controls[google.maps.ControlPosition.RIGHT_TOP].push(photoPanel);
#
#        google.maps.event.addListener panoramioLayer, 'click', (photo) -> 
#            li = document.createElement('li');
#            link = document.createElement('a');
#            link.innerHTML = photo.featureDetails.title + ': ' +
#            photo.featureDetails.author;
#            link.setAttribute('href', photo.featureDetails.url);
#            li.appendChild(link);
#            photoPanel.appendChild(li);
#            photoPanel.style.display = 'block';
#                                    


        $.get window.httpUrl + 'api/v1/locSeries', (data) ->

            matchers = []
            buildMatcher = (properties={},conditional=(-> true)) -> 
                collection = []
                matchers.push (point) ->
                    if point is "draw"
                        path = new google.maps.Polyline _.extend({
                            path: collection,
                            geodesic: true,
                            strokeColor: '#ff0000',
                            strokeOpacity: 0.7,
                            strokeWeight: 2 }, properties)
                            
                        path.setMap map

                    if conditional(point) then collection.push point.loc; return true else return false

            day = 1000 * 60 * 60 * 24
            now = new Date().getTime()
            

#            buildMatcher { strokeColor: '#8800bb', strokeWeight: 3 }, (point) -> (point.time < now - day) and (point.time > now - day*3)
#            buildMatcher { strokeColor: '#bb0088', strokeWeight: 2 }, (point) -> (point.time < now - day*3) and point.time > now - day*6
            buildMatcher { strokeColor: '#ff0000', strokeWeight: 2 }, (point) -> point.time < now - day
            buildMatcher { strokeColor: '#0000ff', strokeWeight: 2 }, (point) -> point.time > now - day
                                                
            data.split('\n').forEach (entry) ->
                if not entry then return
                point = JSON.parse(entry)
                point.loc = new google.maps.LatLng(point.lat, point.lng)
                _.map matchers, (matcher) -> matcher(point)

            matchers.forEach (matcher) -> matcher('draw')





$('document').ready initialize

