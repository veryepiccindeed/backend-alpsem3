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

            // Logging role dan email yang diterima
            \Log::info('Login attempt', [
                'email' => $validated['email'],
                'role' => $validated['role']
            ]);

            // Jika role adalah customer
            if ($validated['role'] === 'customer') {
                // Cari user di tabel User
                $user = User::where('email', $validated['email'])->first();

                // Validasi password
                if (!$user || !Hash::check($validated['password'], $user->password)) {
                    \Log::warning('Customer login failed', [
                        'email' => $validated['email']
                    ]);

                    return response()->json([
                        'message' => 'Email atau password tidak sesuai.',
                    ], 401); // Status 401 Unauthorized
                }

                // Generate token
                $token = $user->createToken('MyApp')->plainTextToken;

                return response()->json([
                    'message' => 'Login successful',
                    'role' => 'customer',
                    'token' => $token,
                ]);
            }

            // Jika role adalah driver
            if ($validated['role'] === 'driver') {
                // Cari driver di tabel Driver
                $driver = Driver::where('email', $validated['email'])->first();

                // Validasi password
                if (!$driver || !Hash::check($validated['password'], $driver->password)) {
                    \Log::warning('Driver login failed', [
                        'email' => $validated['email']
                    ]);

                    return response()->json([
                        'message' => 'Email atau password tidak sesuai.',
                    ], 401); // Status 401 Unauthorized
                }

                // Generate token
                $token = $driver->createToken('MyApp')->plainTextToken;

                return response()->json([
                    'message' => 'Login successful',
                    'role' => 'driver',
                    'token' => $token,
                ]);
            }

            // Jika role tidak valid
            \Log::error('Invalid role', [
                'role' => $validated['role']
            ]);

            return response()->json([
                'message' => 'Role tidak valid.',
            ], 400); // Status 400 Bad Request
        } catch (ValidationException $e) {
            // Menangkap error validasi
            \Log::error('Validation error', [
                'errors' => $e->errors()
            ]);

            return response()->json([
                'message' => $e->errors(),
            ], 422); // Status 422 Unprocessable Entity
        } catch (\Exception $e) {
            // Menangkap error lain
            \Log::error('Login error', [
                'message' => $e->getMessage()
            ]);

            return response()->json([
                'message' => 'Terjadi kesalahan pada server.',
            ], 500); // Status 500 Internal Server Error
        }
    }
}
