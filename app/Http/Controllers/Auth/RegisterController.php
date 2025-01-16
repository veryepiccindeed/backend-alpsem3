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
        // Validasi input
        $validated = Validator::make($request->all(), [
            'nama' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email|unique:drivers,email', // Email harus unik untuk customer dan driver
            'password' => 'required|string|min:8|confirmed',
            'no_hp' => 'required|string|max:15',
            'alamat' => 'required|string|max:255',
            'gender' => 'required|in:laki-laki,perempuan',
            'tgl_lahir' => 'required|date',
            'role' => 'required|in:customer,driver',  // Pastikan role dikirimkan dan valid
            'foto_profil' => 'nullable|file|mimes:jpg,png|max:2048',
        ]);

        if ($validated->fails()) {
            return response()->json(['errors' => $validated->errors()], 422);
        }

        // Jika role adalah customer
        if ($request->role == 'customer') {
            // Buat user
            $user = User::create([
                'nama' => $request->nama,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'no_hp' => $request->no_hp,
                'alamat' => $request->alamat,
                'gender' => $request->gender,
                'tgl_lahir' => $request->tgl_lahir,
            ]);

            // Jika foto_profil ada, simpan sebagai BLOB
            if ($request->hasFile('foto_profil')) {
                $file = $request->file('foto_profil');
                $fotoProfilBinary = file_get_contents($file->getRealPath());  // Mengubah file menjadi data BLOB
                $user->foto_profil = $fotoProfilBinary;
                $user->save();
            }

            return response()->json(['message' => 'Registrasi customer berhasil', 'user' => $user], 201);
        }

        // Jika role adalah driver
        if ($request->role == 'driver') {
            // Validasi tambahan untuk driver (misalnya, jika driver perlu melampirkan dokumen lainnya nanti)
            $driver = Driver::create([
                'nama' => $request->nama,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'no_hp' => $request->no_hp,
                'alamat' => $request->alamat,
                'gender' => $request->gender,
                'tgl_lahir' => $request->tgl_lahir,
                // Kolom lainnya untuk driver seperti foto SIM dan KTP bisa ditambahkan nanti oleh admin
            ]);

            return response()->json(['message' => 'Registrasi akun driver berhasil', 'driver' => $driver], 201);
        }

        return response()->json(['message' => 'Role tidak valid'], 400);
    }

}
