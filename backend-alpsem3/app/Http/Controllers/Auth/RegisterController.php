<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use App\Models\User;
use App\Models\Driver;

class RegisterController extends Controller
{
    /**
     * Handle user registration.
     */
    public function register(Request $request)
    {
        // Validate the request
        $validator = Validator::make($request->all(), [
            'nama' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email|unique:drivers,email',
            'password' => 'required|string|min:6',
            'no_hp' => 'required|string|max:15',
            'alamat' => 'required|string',
            'gender' => 'required|in:Laki-laki,Perempuan',
            'tgl_lahir' => 'required|date',
            'role' => 'required|in:Driver,User',
            'foto_profil' => 'nullable|string', // Base64-encoded image
        ]);

        // Return validation errors if any
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Create user or driver based on role
        if ($request->role == 'User') {
            $user = User::create([
                'nama' => $request->nama,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'no_hp' => $request->no_hp,
                'alamat' => $request->alamat,
                'gender' => $request->gender,
                'tgl_lahir' => $request->tgl_lahir,
                'foto_profil' => $request->foto_profil, // Save base64 image
            ]);

            return response()->json(['message' => 'User registered successfully', 'user' => $user], 201);
        } elseif ($request->role == 'Driver') {
            $driver = Driver::create([
                'nama' => $request->nama,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'no_hp' => $request->no_hp,
                'alamat' => $request->alamat,
                'gender' => $request->gender,
                'tgl_lahir' => $request->tgl_lahir,
                'foto_profil' => $request->foto_profil, // Save base64 image
            ]);

            return response()->json(['message' => 'Driver registered successfully', 'driver' => $driver], 201);
        }

        // If role is invalid
        return response()->json(['message' => 'Invalid role'], 400);
    }
}