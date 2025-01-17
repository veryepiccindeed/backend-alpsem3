<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    use HasFactory;

    protected $fillable = [
        'id_user',
        'id_driver',
        'payment_amount',
        'payment_status',
        'jumlah_tiket',
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
