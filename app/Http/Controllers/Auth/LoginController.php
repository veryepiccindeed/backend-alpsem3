<?php

namespace App\Http\Controllers\Auth;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class LoginController extends Controller
{
        public function login(Request $request)
        {
            // Validasi input
            $validated = $request->validate([
                'email' => 'required|email',
                'password' => 'required|string',
                'role' => 'required|in:customer,driver', // Pastikan role dikirimkan
            ]);
    
            // Cari user berdasarkan email
            $user = User::where('email', $validated['email'])->first();
    
            // Validasi password dan role
            if (!$user || !Hash::check($validated['password'], $user->password) || $user->role !== $validated['role']) {
                throw ValidationException::withMessages([
                    'email' => ['Email, password, atau role tidak sesuai.'],
                ]);
            }
    
            // Login dan buat token
            $token = $user->createToken('MyApp')->plainTextToken;
    
            return response()->json([
                'message' => 'Login successful',
                'role' => $user->role,
                'token' => $token,
            ]);
        }
}
