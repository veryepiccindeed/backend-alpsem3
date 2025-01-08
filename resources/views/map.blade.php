<!DOCTYPE html>
<html>
<head>
    <title>Leaflet Map</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
    <style>
        #map {
            height: 500px;
            width: 100%;
        }
    </style>
</head>
<body>
    <h1>Leaflet with Nominatim</h1>
        <div id="map"></div>
        <input type="text" id="search" placeholder="Enter location" autocomplete="off" />
        <ul id="suggestions"></ul>
        <button onclick="searchLocation()">Search</button>

        <script>
            // Initialize the map
            var map = L.map('map').setView([-6.2088, 106.8456], 13); // Jakarta

            // Add OpenStreetMap tile layer
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 19,
                attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            }).addTo(map);

            const searchInput = document.getElementById('search');
            const suggestionsList = document.getElementById('suggestions');

            // Fetch and display suggestions
            searchInput.addEventListener('input', function () {
                const query = searchInput.value;
                if (!query) {
                    suggestionsList.innerHTML = '';
                    return;
                }

                fetch(`/api/geocode?query=${query}`)
                    .then(response => response.json())
                    .then(data => {
                        suggestionsList.innerHTML = '';
                        data.forEach(location => {
                            const li = document.createElement('li');
                            li.textContent = location.display_name;
                            li.dataset.lat = location.lat;
                            li.dataset.lon = location.lon;
                            li.addEventListener('click', () => {
                                searchInput.value = location.display_name;
                                suggestionsList.innerHTML = '';
                                moveToLocation(location.lat, location.lon);
                            });
                            suggestionsList.appendChild(li);
                        });
                    })
                    .catch(error => console.error('Error:', error));
            });

            // Move to selected location
            function moveToLocation(lat, lon) {
                const marker = L.marker([lat, lon]).addTo(map);
                map.setView([lat, lon], 15);
                marker.bindPopup(`<b>${searchInput.value}</b>`).openPopup();
            }

            // Function to search location
            function searchLocation() {
                const query = searchInput.value;
                if (!query) return alert('Please enter a location');
                
                fetch(`/api/geocode?query=${query}`)
                    .then(response => response.json())
                    .then(data => {
                        if (data.length > 0) {
                            const { lat, lon } = data[0]; // Ambil hasil pertama
                            moveToLocation(lat, lon);
                        } else {
                            alert('Location not found');
                        }
                    })
                    .catch(error => console.error('Error:', error));
            }
        </script>
    </body>
    </html>
