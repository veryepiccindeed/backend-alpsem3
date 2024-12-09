<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ApiController extends Controller
{
    // Middleware akan memeriksa token menggunakan Sanctum
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    // Contoh endpoint API yang memerlukan autentikasi
    public function getProfile(Request $request)
    {
        return response()->json(['message' => 'You are authenticated', 'user' => $request->user()]);
    }

    public function logout(Request $request)
    {
        // Menghapus token yang ada
        $request->user()->currentAccessToken()->delete();


        return response()->json(['message' => 'Logged out successfully']);
    }
}
