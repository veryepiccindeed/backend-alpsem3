<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use App\Models\Driver;

class ProfileController extends Controller
{

    // Contoh endpoint API yang memerlukan autentikasi
    public function getProfile(Request $request)
    {
        return response()->json(['message' => 'Success'], 200, [
            'Content-Type' => 'application/json',
        ]);
        
    }

    public function logout(Request $request)
    {
        // Menghapus token yang ada
        $request->user()->currentAccessToken()->delete();


        return response()->json(['message' => 'Logout berhasil']);
    }
    

}
