<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Kendaraan extends Model
{
    use HasFactory;

    protected $fillable = [
        'no_plat',
        'tahun_kendaraan',
        'is_tersedia',
        'koordinat',
    ];

    public function schedules()
    {
        return $this->hasMany(Schedule::class, 'id_kendaraan');
    }

    public function drivers()
    {
        return $this->hasMany(Driver::class, 'id_kendaraan');
    }

    public function kursis()
    {
        return $this->hasMany(Kursi::class, 'id_kendaraan');
    }
}
