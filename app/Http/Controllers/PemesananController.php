<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Trayek;
use App\Models\Halte;
use App\Models\Schedule;
use App\Models\TrayekHalte;
use App\Models\Transaction;
use App\Models\User;
use App\Models\Driver;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;


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
    
   
    public function pesanTiket(Request $request)
    {
        // Pastikan user terautentikasi dan memiliki role customer
        if (auth()->check() && auth()->user()->role != 'customer') {
            return response()->json(['message' => 'Hanya customer yang dapat memesan tiket'], 403);
        }

        // Validasi input
        $request->validate([
            'trayek_id' => 'required|exists:trayeks,id',
            'jumlah_tiket' => 'required|integer|min:1',
            'payment_method' => 'required|in:cash,cashless',
        ], [
            'payment_method.required' => 'Metode pembayaran harus diisi.',
            'payment_method.in' => 'Metode pembayaran hanya bisa cash atau cashless.',
        ]);
        
        $user = auth()->user(); // Ambil user yang terautentikasi
        $trayekId = $request->input('trayek_id');
        $jumlahTiket = $request->input('jumlah_tiket');
        $paymentMethod = $request->input('payment_method');
        $hargaPerTiket = 7000; // Harga tiket per tiket

        // Cari trayek berdasarkan ID
        $trayek = Trayek::find($trayekId);
        if (!$trayek) {
            return response()->json(['message' => 'Trayek tidak ditemukan'], 404);
        }

        // Cari kendaraan yang tersedia di trayek yang dipilih
        $kendaraan = Kendaraan::where('is_tersedia', 1)
            ->where('trayek_id', $trayekId)
            ->get();

        if ($kendaraan->isEmpty()) {
            return response()->json(['message' => 'Tidak ada kendaraan yang tersedia untuk trayek ini'], 404);
        }

        // Cari kendaraan yang memiliki kursi tersedia sesuai jumlah tiket yang dipesan
        $angkotTersedia = null;
        foreach ($kendaraan as $kendaraanItem) {
            // Decode kursi_tersedia untuk memeriksa apakah cukup untuk jumlah tiket yang dipesan
            $kursiTersedia = json_decode($kendaraanItem->kursi_tersedia, true);

            // Periksa apakah ada kursi yang tersedia sesuai dengan jumlah tiket yang dipesan
            $kursiCukup = 0;
            foreach ($kursiTersedia as $noKursi => $status) {
                if ($status === 'tersedia') {
                    $kursiCukup++;
                }
            }

            if ($kursiCukup >= $jumlahTiket) {
                $angkotTersedia = $kendaraanItem;
                break;
            }
        }

        if (!$angkotTersedia) {
            return response()->json(['message' => 'Tidak ada kendaraan dengan kursi cukup'], 404);
        }

        // Simpan transaksi ke tabel transaksi
        $transaksi = new Transaction();
        $transaksi->id_user = $user->id;
        $transaksi->id_driver = $angkotTersedia->driver_id;
        $transaksi->id_trayek = $trayek->id;
        $transaksi->jumlah_tiket = $jumlahTiket;
        $transaksi->payment_method = $paymentMethod; 
        $transaksi->payment_amount = $jumlahTiket * 10000; // Harga tiket per tiket
        $transaksi->payment_status = 1; // Status pembayaran, bisa disesuaikan
        $transaksi->save();

        // Update status kendaraan menjadi tidak tersedia
        $angkotTersedia->is_tersedia = 0;
        $angkotTersedia->save();

        return response()->json([
            'message' => 'Tiket berhasil dipesan',
            'transaksi' => $transaksi
        ]);
    }

}
