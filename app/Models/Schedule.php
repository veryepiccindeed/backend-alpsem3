<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Schedule extends Model
{
    use HasFactory;

    protected $fillable = [
        'id_kendaraan',
        'waktu_berangkat',
        'waktu_tiba',
    ];

    public function kendaraan()
    {
        return $this->belongsTo(Kendaraan::class, 'id_kendaraan');
    }

    public function trayeks()
    {
        return $this->hasMany(Trayek::class, 'id_schedule');
    }
}
