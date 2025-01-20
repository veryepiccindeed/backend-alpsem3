<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class GeocodingController extends Controller
{
        public function searchLocation(Request $request)
    {
        $query = $request->input('query'); // Ambil input lokasi dari user

        $response = Http::withHeaders([
            'User-Agent' => 'Universitas Ciputra',
            'Referer' => 'https://www.ciputra.ac.id/'
        ])->get('https://nominatim.openstreetmap.org/search', [
            'q' => $query,
            'format' => 'json',
            'limit' => 5,
        ]);

        if ($response->successful()) {
            return response()->json($response->json());
        }

        return response()->json(['error' => 'Failed to fetch location'], 500);
    }   

        public function reverseGeocode(Request $request)
    {
        $lat = $request->input('lat');
        $lon = $request->input('lon');

        // Panggil API Nominatim
        $response = Http::withHeaders([
            'User-Agent' => 'Universitas Ciputra',
            'Referer' => 'https://www.ciputra.ac.id/'
        ])->get('https://nominatim.openstreetmap.org/reverse', [
            'lat' => $lat,
            'lon' => $lon,
            'format' => 'json',

        ]);
        if ($response->successful()) {
            return response()->json($response->json());
        }

        return response()->json(['error' => 'Failed to fetch address'], 500);
    }

        public function getRoute(Request $request)
    {
            $startLat = $request->query('start_lat');
            $startLon = $request->query('start_lon');
            $endLat = $request->query('end_lat');
            $endLon = $request->query('end_lon');

            // Validasi input
            if (!$startLat || !$startLon || !$endLat || !$endLon) {
                return response()->json(['error' => 'Missing required parameters'], 400);
            }

            // OSRM Routing API URL
            $osrmUrl = "http://localhost:5000/route/v1/driving/{$startLon},{$startLat};{$endLon},{$endLat}?overview=full&geometries=polyline";

            // Fetch data dari OSRM
            $response = Http::get($osrmUrl);

            if ($response->ok()) {
                return response()->json($response->json());
            }

            return response()->json(['error' => 'Failed to fetch route from OSRM'], 500);
    }

        public function getKoordinatHalte()
    {
            // Inisialisasi data halte
            $stops = [
                ['name' => 'Kampus Unhas Teknik Gowa', 'lat' => -5.2299394697095245, 'lon' => 119.50211253693419],
                ['name' => 'Halte CSA Unhas', 'lat' => -5.230279153107808, 'lon' => 119.50271553823227],
                ['name' => 'Asrama Rindam Gowa', 'lat' => -5.225254, 'lon' => 119.496872],
                ['name' => 'Citraland Hertasning', 'lat' => -5.18092218503825, 'lon' => 119.46426590725011],
                ['name' => 'Mall Panakkukang', 'lat' => -5.156793513683525, 'lon' => 119.44766356706735],
                ['name' => 'Taman Pakui', 'lat' => -5.151616686795926, 'lon' => 119.43729584824564],
                ['name' => 'Halte GPIB Mangngamaseang', 'lat' => -5.145760125553669, 'lon' => 119.46944072857308],
                ['name' => 'Fakultas Sospol Unhas', 'lat' => -5.131505037510745, 'lon' => 119.49023242996354], // Kembali ke awal 
            ];
    
           
            return response()->json($stops);
    }

        public function getCircularRoute(Request $request)
    {
        $waypoints = $request->query('waypoints'); // Waypoints dalam format lon,lat;lon,lat;...

        if (!$waypoints) {
            return response()->json(['error' => 'Missing required parameters'], 400);
        }

        // OSRM Routing API URL
        $osrmUrl = "http://localhost:5000/route/v1/driving/{$waypoints}?overview=full&geometries=polyline";

        // Fetch data dari OSRM
        $response = Http::get($osrmUrl);

        if ($response->ok()) {
            return response()->json($response->json());
        }

        return response()->json(['error' => 'Failed to fetch route from OSRM'], 500);
    }


}
