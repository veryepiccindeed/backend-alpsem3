<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use App\Models\Driver;
use Illuminate\Support\Facades\Validator;

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

    public function editProfile(Request $request)
    {
        // Get the authenticated user from the token
        $user = $request->user();

        // Define validation rules for partial updates
        $rules = [
            'nama' => 'sometimes|required|string|max:255',
            'email' => 'sometimes|required|email|unique:users,email,' . $user->id,
            'password' => 'sometimes|nullable|string|min:8|confirmed',
            'no_hp' => 'sometimes|string|max:15',
            'alamat' => 'sometimes|string|max:255',
            'gender' => 'sometimes|in:laki-laki,perempuan',
            'tgl_lahir' => 'sometimes|date',
        ];

        // Create a validator instance
        $validator = Validator::make($request->all(), $rules);

        // Check if the validation fails
        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $validator->errors(),
            ], 422);
        }

        // Retrieve validated data
        $validatedData = $validator->validated();

        // Determine if the user is a driver based on the relationship
        if ($user->driver) {
            // Update driver record with only the provided fields
            $driver = $user->driver;
            $driver->fill($validatedData);
            if (!empty($validatedData['password'])) {
                $driver->password = bcrypt($validatedData['password']);
            }
            $driver->save();

            return response()->json(['message' => 'Driver profile updated successfully.']);
        } else {
            // Update user record with only the provided fields
            $user->fill($validatedData);
            if (!empty($validatedData['password'])) {
                $user->password = bcrypt($validatedData['password']);
            }
            if ($request->hasFile('profile_photo')) {
                $path = $request->file('profile_photo')->store('profile_photos', 'public');
                $user->profile_photo_path = $path;
            }
            $user->save();

            return response()->json(['message' => 'User profile updated successfully.']);
        }
    }


}
