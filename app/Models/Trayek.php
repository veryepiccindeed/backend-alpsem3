<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Trayek extends Model
{
    use HasFactory;

    protected $fillable = [
        'kode_trayek',
        'urutan_halte',
        'id_schedule',
    ];

    public function schedule()
    {
        return $this->belongsTo(Schedule::class, 'id_schedule');
    }

    public function trayekHaltes()
    {
        return $this->hasMany(TrayekHalte::class, 'id_trayek');
    }
    
    public function haltes()
    {
        return $this->hasMany(Halte::class, 'kode_trayek', 'kode_trayek');
    }

    public function kendaraan()
    {
        return $this->hasMany(Kendaraan::class, 'trayek_id');
    }

    public function transaksi()
    {
        return $this->hasMany(Transaction::class, 'id_trayek');
    }

}
