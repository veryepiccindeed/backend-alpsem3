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
        'id_trayek',
        'jenis_tiket',
        'tgl_transaksi',
        'jumlah_tiket',
        'payment_method',
        'payment_amount',
        'payment_status',
    ];

    public $timestamps = false;

    public function user()
    {
        return $this->belongsTo(User::class, 'id_user');
    }

    public function driver()
    {
        return $this->belongsTo(Driver::class, 'id_driver');
    }

    public function trayek()
    {
        return $this->belongsTo(Trayek::class, 'id_trayek');
    }

}
