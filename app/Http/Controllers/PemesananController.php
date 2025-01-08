<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Trayek;
use App\Models\Halte;
use App\Models\Schedule;
use App\Models\TrayekHalte;
use App\Models\Transaction;
use App\Traits\RouteHelper;
use App\Traits\LocationHelper;
use Illuminate\Support\Facades\Validator;


class PemesananController extends Controller
{
    use RouteHelper, LocationHelper;

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

    public function hitungJarakLangsung(Request $request)
    {
        // Validasi input
        $validated = Validator::make($request->all(), [
            'lokasi_awal.latitude' => 'required|numeric',
            'lokasi_awal.longitude' => 'required|numeric',
            'lokasi_tujuan.latitude' => 'required|numeric',
            'lokasi_tujuan.longitude' => 'required|numeric',
        ]);

        if ($validated->fails()) {
            return response()->json(['errors' => $validated->errors()], 422);
        }

        $lokasiAwalLatitude = $request->input('lokasi_awal.latitude');
        $lokasiAwalLongitude = $request->input('lokasi_awal.longitude');
        $lokasiTujuanLatitude = $request->input('lokasi_tujuan.latitude');
        $lokasiTujuanLongitude = $request->input('lokasi_tujuan.longitude');

        try {
            // Menghitung jarak menggunakan Haversine formula
            $distance = $this->hitungJarak($lokasiAwalLatitude, $lokasiAwalLongitude, $lokasiTujuanLatitude, $lokasiTujuanLongitude);

            return response()->json([
                'distance' => $distance
            ]);
        } catch (Exception $e) {
            return response()->json(['message' => 'Terjadi kesalahan saat menghitung jarak.', 'error' => $e->getMessage()], 500);
        }
    }

    public function hitungJarakDanHalte(Request $request)
    {   
        $validated = Validator::make($request->all(), [
            'jenis_tiket' => 'required|in:fixed,flexible',
            'lokasi_awal.latitude' => 'required|numeric',
            'lokasi_awal.longitude' => 'required|numeric',
            'lokasi_tujuan.latitude' => 'required|numeric',
            'lokasi_tujuan.longitude' => 'required|numeric',
        ]);

        if ($validated->fails()) {
            return response()->json(['errors' => $validated->errors()], 422);
        }

        $jenisTiket = $request->input('jenis_tiket');
        $lokasiAwalLatitude = $request->input('lokasi_awal.latitude');
        $lokasiAwalLongitude = $request->input('lokasi_awal.longitude');
        $lokasiTujuanLatitude = $request->input('lokasi_tujuan.latitude');
        $lokasiTujuanLongitude = $request->input('lokasi_tujuan.longitude');

        try {
            // Logika untuk mencari halte terdekat dari lokasi awal dan tujuan
            $halteAwal = $this->halteTerdekat($lokasiAwalLatitude, $lokasiAwalLongitude);
            $halteTujuan = $this->halteTerdekat($lokasiTujuanLatitude, $lokasiTujuanLongitude);
    
            if (!$halteAwal || !$halteTujuan) {
                return response()->json(['message' => 'Tidak dapat menemukan halte terdekat untuk lokasi yang diberikan.'], 404);
            }
    
            // Membentuk graph halte
            $graph = $this->createHalteGraph();
    
            // Menggunakan algoritma Dijkstra untuk mencari rute terpendek
            $route = $this->dijkstra($graph, $halteAwal->id, $halteTujuan->id);
    
            // Menghitung harga berdasarkan jenis tiket
            if ($jenisTiket == 'fixed') {
                $result = $this->tiketFixed($route['path'], count($route['path']));
            } else {
                $result = $this->tiketFlexible($route['path'], count($route['path']));
            }

            return response()->json([
                'path' => $result['path'],
                'distance' => $result['distance'],
                'harga' => $result['harga'],
                'jenis_tiket' => $jenisTiket
            ]);
    
        } catch (Exception $e) {
            return response()->json(['message' => 'Terjadi kesalahan saat menghitung jarak.', 'error' => $e->getMessage()], 500);
        }
    }

   
    public function pemesananTiket(Request $request)
    {
        // Validasi input
        $validated = Validator::make($request->all(), [
            'path' => 'required|array',
            'path.*' => 'integer',
            'jenis_tiket' => 'required|in:fixed,flexible',
            'jumlah_penumpang' => 'required|integer|min:1',
        ]);
    
        if ($validated->fails()) {
            return response()->json(['errors' => $validated->errors()], 422);
        }
    
        try {
            // Mendapatkan data user yang terautentikasi
            $user = $request->user();   
            
            // Cek apakah user adalah customer atau driver
            $customer = User::find($user->id);
            $driver = Driver::find($user->id);
    
            // Jika tidak ditemukan di kedua tabel, berarti bukan customer atau driver
            if (!$customer && !$driver) {
                return response()->json(['message' => 'User harus memiliki role!'], 403);
            }
    
            // Pastikan role user adalah customer (karena hanya customer yang bisa pesan tiket)
            if ($driver) {
                return response()->json(['message' => 'Driver tidak dapat memesan tiket!'], 403);
            } 
    
            $path = $request->input('path');
            $jenisTiket = $request->input('jenis_tiket');
            $jumlahPenumpang = $request->input('jumlah_penumpang');
    
            // Logika untuk menghitung harga tiket berdasarkan rute
            $graph = $this->createHalteGraph();
            $distance = 0;
            for ($i = 0; $i < count($path) - 1; $i++) {
                if (!isset($graph[$path[$i]]) || !isset($graph[$path[$i]][$path[$i + 1]])) {
                    return response()->json(['message' => 'Path yang diberikan tidak valid.'], 400);
                }
                $distance += $graph[$path[$i]][$path[$i + 1]];
            }
    
            if ($jenisTiket == 'fixed') {
                $result = $this->tiketFixed($path, $jumlahPenumpang);
            } else {
                $result = $this->tiketFlexible($path, $jumlahPenumpang);
            }
    
            // Proses transaksi untuk pemesanan tiket
            $transaksi = Transaction::create([
                'id_user' => $user->id,
                'path' => json_encode($path),
                'jenis_tiket' => $jenisTiket,
                'jumlah_penumpang' => $jumlahPenumpang,
                'payment_amount' => $harga,
                'payment_status' => 0, // 0 berarti belum dibayar
            ]);
    
            return response()->json([
                'path' => $path,
                'distance' => $distance,
                'harga' => $harga,
                'message' => 'Pemesanan tiket berhasil'
            ], 201);
    
        } catch (Exception $e) {
            return response()->json(['message' => 'Terjadi kesalahan saat melakukan pemesanan tiket.', 'error' => $e->getMessage()], 500);
        }
    }
}
