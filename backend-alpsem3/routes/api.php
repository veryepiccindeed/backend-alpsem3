<?php

use App\Http\Controllers\Auth\NotificationController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\HalteController;
use App\Http\Controllers\Auth\RegisterController;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\Auth\ApiController;
use App\Http\Controllers\PemesananController;


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
Route::get('/login', [LoginController::class, 'login']);


// Middleware 
Route::middleware('auth:sanctum')->group(function () {
    // Route untuk pemesanan tiket, memerlukan autentikasi
    Route::post('/pemesanan', [PemesananController::class, 'pemesananTiket']);
    // Logout
    Route::post('/logout', [ApiController::class, 'logout']);
    // Tes Profile Yang Ter-login
    Route::get('/profile', [ApiController::class, 'getProfile']);
});

// Yang bisa dilihat tanpa autentikasi
Route::get('/trayeks', [PemesananController::class, 'getTrayeks']);
Route::get('/haltes', [PemesananController::class, 'getHaltes']);
Route::get('/schedules', [PemesananController::class, 'getSchedules']);
Route::get('/trayek-haltes', [PemesananController::class, 'getTrayekHaltes']);

Route::get("send-event", function(){
    broadcast(new \App\Events\HelloEvent());
});



Route::get('notifications/{id}', [NotificationController::class, 'show']);
use Illuminate\Support\Facades\Broadcast;

