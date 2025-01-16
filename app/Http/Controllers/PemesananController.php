<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Trayek;
use App\Models\Halte;
use App\Models\Schedule;
use App\Models\TrayekHalte;
use App\Models\Transaction;
use Illuminate\Support\Facades\Validator;


class PemesananController extends Controller
{

    // Menampilkan list trayek untuk semua orang (tidak memerlukan autentikasi)
    public function getTrayeks()
    {
        $trayeks = Trayek::all();
        return response()->json($trayeks);
    }

    // Menampilkan list halte untuk semua orang (tidak memerlukan autentikasi)
    public function getHaltes()
    {
        $haltes = Halte::all();
        return response()->json($haltes);
    }

    // Menampilkan list jadwal untuk semua orang (tidak memerlukan autentikasi)
    public function getSchedules()
    {
        $schedules = Schedule::all();
        return response()->json($schedules);
    }

    // Menampilkan list trayek halte untuk semua orang (tidak memerlukan autentikasi)
    public function getTrayekHaltes()
    {
        $trayekHaltes = TrayekHalte::all();
        return response()->json($trayekHaltes);
    }

    public function getTrayekWithHalte($trayekId)
    {
        // Ambil trayek berdasarkan ID dengan Eloquent
        $trayek = Trayek::find($trayekId);
    
        if ($trayek) {
            // Decode halte_order JSON
            $halteIds = json_decode($trayek->urutan_halte);
    
            // Ambil detail halte berdasarkan ID menggunakan Eloquent
            $haltes = Halte::whereIn('id', $halteIds)->get();
    
            return response()->json([
                'kode_trayek' => $trayek->kode_trayek,
                'urutan_halte' => $haltes
            ]);
        }
    
        return response()->json(['error' => 'Trayek tidak ditemukan'], 404);
    }
    
   
    public function pemesananTiket(Request $request)
    {

    }

}
