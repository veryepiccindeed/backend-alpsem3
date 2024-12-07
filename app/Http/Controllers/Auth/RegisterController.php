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
            'email' => 'required|email|unique:users,email',
            'password' => 'required|string|min:8|confirmed',
            'no_hp' => 'required|string|max:15',
            'alamat' => 'required|string',
            'gender' => 'required|in:laki-laki,perempuan',
            'tgl_lahir' => 'required|date',
            'role' => 'required|in:customer,driver',
            'foto_profil' => 'nullable|file|mimes:jpg,png|max:2048',
            // Atribut driver (opsional jika role=driver)
            'id_kendaraan' => 'required_if:role,driver|exists:kendaraans,id',
            'foto_sim' => 'nullable|file|mimes:jpg,png|max:2048',
            'no_sim' => 'required_if:role,driver|numeric',
            'masa_berlaku_sim' => 'required_if:role,driver|date',
            'foto_ktp' => 'nullable|file|mimes:jpg,png|max:2048',
        ]);

        if ($validated->fails()) {
            return response()->json(['errors' => $validated->errors()], 422);
        }

        // Buat user
        $user = User::create([
            'nama' => $request->nama,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'no_hp' => $request->no_hp,
            'alamat' => $request->alamat,
            'gender' => $request->gender,
            'tgl_lahir' => $request->tgl_lahir,
            'role' => $request->role,
        ]);

        // Jika foto_profil ada, simpan sebagai BLOB
        if ($request->hasFile('foto_profil')) {
            $file = $request->file('foto_profil');
            $fotoProfilBinary = file_get_contents($file->getRealPath());  // Mengubah file menjadi data BLOB
            $user->foto_profil = $fotoProfilBinary;
            $user->save();
        }

        // Jika role = driver, buat entri di tabel drivers
        if ($request->role === 'driver') {
            $driver = Driver::create([
                'id_user' => $user->id,
                'id_kendaraan' => $request->id_kendaraan,
            ]);

            // Simpan foto SIM sebagai BLOB jika ada
            if ($request->hasFile('foto_sim')) {
                $file = $request->file('foto_sim');
                $fotoSimBinary = file_get_contents($file->getRealPath());
                $driver->foto_sim = $fotoSimBinary;
            }

            // Simpan foto KTP sebagai BLOB jika ada
            if ($request->hasFile('foto_ktp')) {
                $file = $request->file('foto_ktp');
                $fotoKtpBinary = file_get_contents($file->getRealPath());
                $driver->foto_ktp = $fotoKtpBinary;
            }

            // Menyimpan data terkait SIM
            $driver->no_sim = $request->no_sim;
            $driver->masa_berlaku_sim = $request->masa_berlaku_sim;
            $driver->save();
        }

        return response()->json(['message' => 'Registration successful', 'user' => $user], 201);
    }

    public function getFotoProfil($userId)
{
    // Cari user berdasarkan ID
    $user = User::find($userId);

    // Jika user atau foto profil tidak ditemukan, kembalikan pesan error
    if (!$user || !$user->foto_profil) {
        return response()->json(['message' => 'File not found'], 404);
    }

    // Deteksi tipe gambar dari data foto yang ada
    $imageData = $user->foto_profil;
    $imageInfo = getimagesizefromstring($imageData);  // Mendapatkan informasi gambar

    if ($imageInfo === false) {
        return response()->json(['message' => 'Invalid image data'], 400);
    }

    // Ambil MIME type dari informasi gambar
    $mimeType = $imageInfo['mime'];

    // Kembalikan foto dengan Content-Type yang sesuai
    return response($imageData)
        ->header('Content-Type', $mimeType);
}

}
