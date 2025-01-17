<?php

namespace App\Http\Controllers\Auth;

use App\Models\User;
use App\Models\Driver;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class LoginController extends Controller
{
    /**
     * @OA\Post(
     *     path="/api/login",
     *     summary="Login for customer or driver",
     *     tags={"Authentication"},
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(ref="#/components/schemas/LoginRequest")
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Login successful",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="Login successful"),
     *             @OA\Property(property="role", type="string", example="customer"),
     *             @OA\Property(property="token", type="string", example="JWT_TOKEN_HERE")
     *         )
     *     ),
     *     @OA\Response(
     *         response=401,
     *         description="Unauthorized - Invalid credentials",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="Invalid email or password.")
     *         )
     *     ),
     *     @OA\Response(
     *         response=422,
     *         description="Unprocessable Entity - Validation errors",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="Validation error."),
     *             @OA\Property(property="errors", type="object")
     *         )
     *     )
     * )
 * @OA\Schema(
 *     schema="LoginRequest",
 *     type="object",
 *     required={"email", "password", "role"},
 *     @OA\Property(property="email", type="string", format="email", example="user@example.com"),
 *     @OA\Property(property="password", type="string", format="password", example="password123"),
 *     @OA\Property(property="role", type="string", enum={"customer", "driver"}, example="customer")
 * )
 */

    public function login(Request $request)
    {
        try {
            $validated = $request->validate([
                'email' => 'required|email',
                'password' => 'required|string',
                'role' => 'required|in:customer,driver',
            ]);

            $user = $validated['role'] === 'customer'
                ? User::where('email', $validated['email'])->first()
                : Driver::where('email', $validated['email'])->first();

            if (!$user || !Hash::check($validated['password'], $user->password)) {
                return response()->json(['message' => 'Invalid email or password.'], 401);
            }

            $token = $user->createToken('MyApp')->plainTextToken;

            return response()->json([
                'message' => 'Login successful',
                'role' => $validated['role'],
                'token' => $token,
            ]);
        } catch (ValidationException $e) {
            return response()->json(['message' => 'Validation error.', 'errors' => $e->errors()], 422);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Server error occurred.'], 500);
        }
    }
}
