<?php

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

Route::get('/', function () {
    return view('welcome');
});

// Testing Middleware
Route::middleware('auth:web')->get('/profile', function (Request $request) {
    return response()->json(['message' => 'You are authenticated', 'user' => $request->user()]);
});

