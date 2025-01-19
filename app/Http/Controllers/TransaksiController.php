<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Transaction;
use Carbon\Carbon;

class TransaksiController extends Controller
{

    public function getUserTransactions()
    {
    // Pastikan user terautentikasi
    if (!auth()->check()) {
        return response()->json(['message' => 'User tidak terautentikasi'], 401);
    }

    $userId = auth()->user()->id; // Ambil ID user yang terautentikasi

    // Ambil transaksi yang melibatkan user ini
    $transaksi = Transaction::where('id_user', $userId)->get();

    if ($transaksi->isEmpty()) {
        return response()->json(['message' => 'Tidak ada transaksi untuk user ini'], 404);
    }

    return response()->json($transaksi);
    }

    public function getDriverTransactions()
    {
    // Pastikan user terautentikasi dan memiliki role 'driver'
    if (auth()->check() && auth()->user()->role != 'driver') {
        return response()->json(['message' => 'Hanya driver yang dapat melihat transaksi ini'], 403);
    }

    $driverId = auth()->user()->id; // Ambil ID driver yang terautentikasi

    // Ambil transaksi yang melibatkan driver ini
    $transaksi = Transaction::where('id_driver', $driverId)->get();

    if ($transaksi->isEmpty()) {
        return response()->json(['message' => 'Tidak ada transaksi untuk driver ini'], 404);
    }

    return response()->json($transaksi);
    }

    public function filterByDate($date)
    {
        $user = $request->user();
    
        // Cek apakah user adalah driver atau customer
        if ($user->driver) {
            // User adalah driver, filter berdasarkan id_driver
            $transaksi = Transaction::whereDate('tgl_transaksi', $date)
                                ->where('id_driver', $user->id) // Menampilkan transaksi yang terkait dengan driver
                                ->get();
        } else {
            // User adalah customer, filter berdasarkan id_user
            $transaksi = Transaction::whereDate('tgl_transaksi', $date)
                                ->where('id_user', $user->id) // Menampilkan transaksi yang terkait dengan customer
                                ->get();
        }
    
        return response()->json($transaksi);
    }
    
    public function filterByMonth($month, $year)
    {
        $user = $request->user();
    
        // Cek apakah user adalah driver atau customer
        if ($user->driver) {
            // User adalah driver, filter berdasarkan id_driver
            $transaksi = Transaction::whereMonth('tgl_transaksi', $month)
                                ->whereYear('tgl_transaksi', $year)
                                ->where('id_driver', $user->id) // Menampilkan transaksi yang terkait dengan driver
                                ->get();
        } else {
            // User adalah customer, filter berdasarkan id_user
            $transaksi = Transaction::whereMonth('tgl_transaksi', $month)
                                ->whereYear('tgl_transaksi', $year)
                                ->where('id_user', $user->id) // Menampilkan transaksi yang terkait dengan customer
                                ->get();
        }
    
        return response()->json($transaksi);
    }
    
    public function filterByYear($year)
    {
        $user = $request->user();
    
        // Cek apakah user adalah driver atau customer
        if ($user->driver) {
            // User adalah driver, filter berdasarkan id_driver
            $transaksi = Transaction::whereYear('tgl_transaksi', $year)
                                ->where('id_driver', $user->id) // Menampilkan transaksi yang terkait dengan driver
                                ->get();
        } else {
            // User adalah customer, filter berdasarkan id_user
            $transaksi = Transaction::whereYear('tgl_transaksi', $year)
                                ->where('id_user', $user->id) // Menampilkan transaksi yang terkait dengan customer
                                ->get();
        }
    
        return response()->json($transaksi);
    }
    
    public function filterByDateMonthYear($date, $month, $year)
    {
        $user = $request->user();
    
        // Cek apakah user adalah driver atau customer
        if ($user->driver) {
            // User adalah driver, filter berdasarkan id_driver
            $transaksi = Transaction::whereDate('tgl_transaksi', $date)
                                ->whereMonth('tgl_transaksi', $month)
                                ->whereYear('tgl_transaksi', $year)
                                ->where('id_driver', $user->id) // Menampilkan transaksi yang terkait dengan driver
                                ->get();
        } else {
            // User adalah customer, filter berdasarkan id_user
            $transaksi = Transaction::whereDate('tgl_transaksi', $date)
                                ->whereMonth('tgl_transaksi', $month)
                                ->whereYear('tgl_transaksi', $year)
                                ->where('id_user', $user->id) // Menampilkan transaksi yang terkait dengan customer
                                ->get();
        }
    
        return response()->json($transaksi);
    }

}
 