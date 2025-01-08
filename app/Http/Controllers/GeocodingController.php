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
}
