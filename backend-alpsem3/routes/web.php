<?php

use App\Http\Controllers\Auth\ApiController;
use Illuminate\Support\Facades\Route;


/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/


// Testing Middleware
Route::middleware('auth:web')->get('/profile', function (Request $request) {
    return response()->json(['message' => 'You are authenticated', 'user' => $request->user()]);
});

Route::get("send-event", function(){
    broadcast(new \App\Events\HelloEvent());
});

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});