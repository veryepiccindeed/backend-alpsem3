<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\HalteController;
use App\Http\Controllers\Auth\RegisterController;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\Auth\ApiController;
use App\Http\Controllers\PemesananController;
use App\Http\Controllers\GeocodingController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/


// Register
Route::post('/register', [RegisterController::class, 'register']);


// Login & Logout 
Route::post('/login', [LoginController::class, 'login']);


// Middleware 
Route::middleware('auth:sanctum')->group(function () {
    // Route untuk pemesanan tiket, memerlukan autentikasi
    Route::post('/pesan-tiket', [PemesananController::class, 'pesanTiket']);
    // Logout
    Route::post('/logout', [ApiController::class, 'logout']);
    // Tes Profile Yang Ter-login
    Route::get('/profile', [ApiController::class, 'getProfile']);
    // Edit Profile
    Route::put('/edit-profile', [ApiController::class, 'editProfile']);
    // Delete account
    Route::delete('/delete-account', [ApiController::class, 'deleteUser']);

    // Filter tgl transaksi
    Route::get('/transaksi/filter/date/{date}', [TransaksiController::class, 'filterByDate']);
    Route::get('/transaksi/filter/month/{month}/year/{year}', [TransaksiController::class, 'filterByMonth']);
    Route::get('/transaksi/filter/year/{year}', [TransaksiController::class, 'filterByYear']);
    Route::get('/transaksi/filter/date/{date}/month/{month}/year/{year}', [TransaksiController::class, 'filterByDateMonthYear']);
    Route::get('/transaksi/sort/{column}/{direction?}', [TransaksiController::class, 'sortTransactions']);

});

// Yang bisa dilihat tanpa autentikasi
Route::get('/trayeks', [PemesananController::class, 'getTrayeks']);
Route::get('/haltes', [PemesananController::class, 'getHaltes']);
Route::get('/schedules', [PemesananController::class, 'getSchedules']);
Route::get('/trayek/{trayekId}/haltes', [PemesananController::class, 'getTrayekWithHalte']);


// Geocoding & Reverse geocoding
Route::get('/geocode', [GeocodingController::class, 'searchLocation']);
Route::get('/reverse-geocode', [GeocodingController::class, 'reverseGeocode']);

Route::get('/get-route', [GeocodingController::class, 'getRoute']);
Route::get('/koordinat-halte', [GeocodingController::class, 'getKoordinatHalte']);
Route::get('/circular-route', [GeocodingController::class, 'getCircularRoute']);
Route::get('/circular-route-reverse', [GeocodingController::class, 'getReverseRoute']);






