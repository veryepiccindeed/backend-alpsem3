<?php
namespace App\Http\Controllers\Auth;

use App\Models\Notification;
use App\Http\Controllers\Controller;


class NotificationController extends Controller
{
    /**
     * @OA\Get(
     *     path="/api/notifications/{id}",
     *     summary="Get Notification by ID",
     *     description="Menampilkan notifikasi berdasarkan ID",
     *     @OA\Parameter(
     *         name="id",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer")
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Notifikasi ditemukan",
     *         @OA\JsonContent(ref="#/components/schemas/Notification")
     *     ),
     *     @OA\Response(
     *         response=404,
     *         description="Notifikasi tidak ditemukan"
     *     )
     * )
     */
    public function show($id)
    {
        $notification = Notification::find($id);

        if (!$notification) {
            return response()->json(['message' => 'Notifikasi tidak ditemukan'], 404);
        }

        return response()->json($notification);
    }
}
