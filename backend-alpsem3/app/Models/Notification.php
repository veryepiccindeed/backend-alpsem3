<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;



class Notification extends Model
{

/**
 * @OA\Schema(
 *     schema="Notification",
 *     @OA\Property(property="id", type="integer"),
 *     @OA\Property(property="judul", type="string"),
 *     @OA\Property(property="pesan", type="string"),
 *     @OA\Property(property="jenis", type="string"),
 *     @OA\Property(property="id_driver", type="integer", nullable=true),
 *     @OA\Property(property="id_user", type="integer", nullable=true),
 *     @OA\Property(property="created_at", type="string", format="date-time"),
 *     @OA\Property(property="updated_at", type="string", format="date-time")
 * )
 */
    
    use HasFactory;

    protected $fillable = [
        'judul',
        'pesan',
        'jenis',
        'id_driver',
        'id_user',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'id_user');
    }

    public function driver()
    {
        return $this->belongsTo(Driver::class, 'id_driver');
    }
}
