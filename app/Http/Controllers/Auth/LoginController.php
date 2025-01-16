<?php

namespace App\Http\Controllers\Auth;

use App\Models\User;
use App\Models\Driver;
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

        if ($validated['role'] === 'customer') {
            // Cari customer berdasarkan email
            $user = User::where('email', $validated['email'])->first();

            // Validasi password untuk customer
            if (!$user || !Hash::check($validated['password'], $user->password)) {
                return response()->json([
                    'message' => 'Email, role, atau password tidak sesuai.',
                ], 401); // Status 401 Unauthorized
            }

            // Login dan buat token untuk customer
            $token = $user->createToken('MyApp')->plainTextToken;

            return response()->json([
                'message' => 'Login berhasil',
                'role' => 'customer',
                'token' => $token,
                'nama' => $user->nama,
            ]);
        }

        // Jika role adalah driver
        if ($validated['role'] === 'driver') {
            // Cari driver berdasarkan email
            $driver = Driver::where('email', $validated['email'])->first();

            // Validasi password untuk driver
            if (!$driver || !Hash::check($validated['password'], $driver->password)) {
                return response()->json([
                    'message' => 'Email, role, atau password tidak sesuai.',
                ], 401); // Status 401 Unauthorized
            }

            // Login dan buat token untuk driver
            $token = $driver->createToken('MyApp')->plainTextToken;

            return response()->json([
                'message' => 'Login berhasil',
                'role' => 'driver',
                'token' => $token,
                'nama' => $driver->nama,
            ]);
        }

        return response()->json([
            'message' => 'Role tidak valid.',
        ], 400); // Status 400 Bad Request
    }
}
