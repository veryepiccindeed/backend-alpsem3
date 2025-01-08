<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Kursi extends Model
{
    use HasFactory;

    protected $fillable = [
        'id_kendaraan', 
        'nomor_kursi', 
        'status', 
        'id_pemesan'
    ];

    public function kendaraan()
    {
        return $this->belongsTo(Kendaraan::class, 'id_kendaraan');
    }

    public function pemesan()
    {
        return $this->belongsTo(User::class, 'id_pemesan');
    }
}
