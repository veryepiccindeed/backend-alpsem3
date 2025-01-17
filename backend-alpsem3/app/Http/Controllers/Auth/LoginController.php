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
        try {
            // Validasi input
            $validated = $request->validate([
                'email' => 'required|email',
                'password' => 'required|string',
                'role' => 'required|in:customer,driver', // Pastikan role valid
            ]);

            // Logging email dan role
            \Log::info('Login attempt', [
                'email' => $validated['email'],
                'role' => $validated['role']
            ]);

            // Role customer
            if ($validated['role'] === 'customer') {
                $user = User::where('email', $validated['email'])->first();

                if (!$user || !Hash::check($validated['password'], $user->password)) {
                    \Log::warning('Customer login failed', [
                        'email' => $validated['email']
                    ]);

                    return response()->json([
                        'success' => false,
                        'message' => 'Email atau password tidak sesuai.',
                    ], 401);
                }

                $token = $user->createToken('MyApp')->plainTextToken;

                return response()->json([
                    'message' => 'Login successful',
                    'role' => 'customer',
                    'token' => $token,
                    'user' => [
                        'name' => $user->nama,  // Mengirimkan nama yang valid
                        'email' => $user->email,
                    ]
                ]);
                
            }

            // Role driver
            if ($validated['role'] === 'driver') {
                $driver = Driver::where('email', $validated['email'])->first();

                if (!$driver || !Hash::check($validated['password'], $driver->password)) {
                    \Log::warning('Driver login failed', [
                        'email' => $validated['email']
                    ]);

                    return response()->json([
                        'success' => false,
                        'message' => 'Email atau password tidak sesuai.',
                    ], 401);
                }

                $token = $driver->createToken('MyApp')->plainTextToken;

                return response()->json([
                    'success' => true,
                    'message' => 'Login berhasil',
                    'role' => 'customer',
                    'token' => $token ?? '',
                    'user' => [
                        'name' => $user->nama, // fallback jika name null
                        'email' => $user->email, // fallback jika email null
                    ],
                ]);                
            }

            // Role tidak valid
            \Log::error('Invalid role', [
                'role' => $validated['role']
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Role tidak valid.',
            ], 400);

        } catch (ValidationException $e) {
            // Error validasi
            \Log::error('Validation error', [
                'errors' => $e->errors()
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal.',
                'errors' => $e->errors(),
            ], 422);
        } catch (\Exception $e) {
            // Error umum
            \Log::error('Login error', [
                'message' => $e->getMessage()
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan pada server.',
            ], 500);
        }
    }
}
