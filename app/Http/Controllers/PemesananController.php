<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Trayek;
use App\Models\Halte;
use App\Models\Schedule;
use App\Models\TrayekHalte;


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

    // Pemesanan tiket hanya untuk yang terautentikasi
    public function pemesananTiket(Request $request)
    {
        $user = $request->user();  // Mendapatkan data user yang terautentikasi
        
        // Validasi apakah role user adalah customer atau driver
        if ($user->role !== 'customer') {
            return response()->json(['message' => 'Hanya customer yang dapat memesan tiket.'], 403);
        }

        // Proses pemesanan tiket
        // Di sini Anda bisa menambahkan alur pemesanan, seperti pemilihan trayek, halte, dan pembayaran
        
        // Contoh response sukses pemesanan tiket
        return response()->json(['message' => 'Pemesanan tiket berhasil.']);
    }
}
