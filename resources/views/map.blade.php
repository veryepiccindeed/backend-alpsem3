<!DOCTYPE html>
<html>
<head>
    <title>Leaflet Map</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/mapbox-polyline/1.2.1/polyline.min.js"></script>

    <style>
        #map {
            height: 500px;
            width: 100%;
        }
        #suggestions-start, #suggestions-end {
            list-style: none;
            padding: 0;
        }
        #suggestions-start li, #suggestions-end li {
            cursor: pointer;
            margin: 5px 0;
        }
    </style>
</head>
<body>
    <h1>Leaflet with Nominatim</h1>
        <div>
            <input type="text" id="start-location" placeholder="Start location" autocomplete="off" />
            <ul id="suggestions-start"></ul>
            <input type="text" id="end-location" placeholder="End location" autocomplete="off" />
            <ul id="suggestions-end"></ul>
            <button onclick="getRoute()">Get Route</button>
            <button onclick="generateCircularRoute()">Generate Route</button>
            <button onclick="generateReverseRoute()">Generate Reverse Route</button>
        </div>

       
        <div id="map"></div>
        
        <script>
        // Initialize the map
        const map = L.map('map').setView([-5.132704287622194, 119.4091723088454], 13); 
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19,
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(map);

        // Suggestions handling
        function handleSuggestions(inputElement, suggestionsElement, isStart) {
            inputElement.addEventListener('input', function () {
                const query = inputElement.value;
                if (!query) {
                    suggestionsElement.innerHTML = '';
                    return;
                }

                fetch(`/api/geocode?query=${query}`)
                    .then(response => response.json())
                    .then(data => {
                        suggestionsElement.innerHTML = '';
                        data.forEach(location => {
                            const li = document.createElement('li');
                            li.textContent = location.display_name;
                            li.dataset.lat = location.lat;
                            li.dataset.lon = location.lon;
                            li.addEventListener('click', () => {
                                inputElement.value = location.display_name;
                                inputElement.dataset.lat = location.lat;
                                inputElement.dataset.lon = location.lon;
                                suggestionsElement.innerHTML = '';
                            });
                            suggestionsElement.appendChild(li);
                        });
                    })
                    .catch(error => console.error('Error:', error));
            });
        }

        const startInput = document.getElementById('start-location');
        const startSuggestions = document.getElementById('suggestions-start');
        const endInput = document.getElementById('end-location');
        const endSuggestions = document.getElementById('suggestions-end');

        handleSuggestions(startInput, startSuggestions, true);
        handleSuggestions(endInput, endSuggestions, false);

        // Fetch and display route from OSRM
        function getRoute() {
            const startLat = startInput.dataset.lat;
            const startLon = startInput.dataset.lon;
            const endLat = endInput.dataset.lat;
            const endLon = endInput.dataset.lon;

            if (!startLat || !startLon || !endLat || !endLon) {
                alert('Please select both start and end locations.');
                return;
            }


            const osrmUrl = `/api/get-route?start_lat=${startLat}&start_lon=${startLon}&end_lat=${endLat}&end_lon=${endLon}`;
                 fetch(osrmUrl)
                .then(response => response.json())
                .then(data => {
                    if (data.routes && data.routes.length > 0) {
                        const route = data.routes[0];

                        // Decode polyline dari OSRM menggunakan mapbox-polyline
                        const decodedCoordinates = polyline.decode(route.geometry);

                        // Buat polyline Leaflet dari koordinat yang didekodekan
                        const leafletPolyline = L.polyline(decodedCoordinates, { color: 'blue' }).addTo(map);

                        // Zoom untuk menampilkan polyline sepenuhnya di peta
                        map.fitBounds(leafletPolyline.getBounds());
                    } else {
                        alert('No route found');
                    }
                })
                .catch(error => console.error('Error:', error));

        }


        // Function to generate route polyline
        function generateCircularRoute() {
            fetchHalteCoordinates().then(stops => {
                const waypoints = stops.map(stop => `${stop.lon},${stop.lat}`).join(';');
                const routeUrl = `/api/circular-route?waypoints=${waypoints}`;

                fetch(routeUrl)
                    .then(response => response.json())
                    .then(data => {
                        if (data.routes && data.routes.length > 0) {
                            const route = data.routes[0];
                            const decodedCoordinates = polyline.decode(route.geometry);
                            const routeLine = L.polyline(decodedCoordinates.map(coord => [coord[0], coord[1]]), { color: 'blue' }).addTo(map);
                            map.fitBounds(routeLine.getBounds());

                            // Add markers for each stop
                            stops.forEach(stop => {
                                const markerIcon = L.icon({
                                    iconUrl: '/images/busmarker.png', // Use custom marker image
                                    iconSize: [25, 25],
                                    iconAnchor: [12, 12], // Icon anchor
                                    popupAnchor: [0, -12] // Popup position
                                });

                                L.marker([stop.lat, stop.lon], { icon: markerIcon })
                                    .addTo(map)
                                    .bindPopup(`<b>${stop.name}</b>`);
                            });
                        } else {
                            alert('No route found');
                        }
                    })
                    .catch(error => console.error('Error generating route:', error));
            });
        }

         // Function to generate reverse route
         function generateReverseRoute() {
            fetchHalteCoordinates().then(stops => {
                const reversedStops = stops.reverse();  // Reverse the order of stops
                const waypoints = reversedStops.map(stop => `${stop.lon},${stop.lat}`).join(';');
                const routeUrl = `/api/circular-route?waypoints=${waypoints}`;

                fetch(routeUrl)
                    .then(response => response.json())
                    .then(data => {
                        if (data.routes && data.routes.length > 0) {
                            const route = data.routes[0];
                            const decodedCoordinates = polyline.decode(route.geometry);
                            const routeLine = L.polyline(decodedCoordinates.map(coord => [coord[0], coord[1]]), { color: 'red' }).addTo(map);  // Different color for reverse route
                            map.fitBounds(routeLine.getBounds());

                            // Add markers for each reversed stop
                            reversedStops.forEach(stop => {
                                const markerIcon = L.icon({
                                    iconUrl: '/images/busmarker.png', // Use custom marker image
                                    iconSize: [25, 25],
                                    iconAnchor: [12, 12], // Icon anchor
                                    popupAnchor: [0, -12] // Popup position
                                });

                                L.marker([stop.lat, stop.lon], { icon: markerIcon })
                                    .addTo(map)
                                    .bindPopup(`<b>${stop.name}</b>`);
                            });
                        } else {
                            alert('No reverse route found');
                        }
                    })
                    .catch(error => console.error('Error generating reverse route:', error));
            });
        }

               // Function to fetch Halte Coordinates from API
               function fetchHalteCoordinates() {
                    return fetch('/api/koordinat-halte')
                        .then(response => response.json())
                        .catch(error => {
                            console.error('Error fetching halte coordinates:', error);
                        });
                }

        </script>
    </body>
    </html>
