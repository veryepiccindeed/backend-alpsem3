<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Trayek extends Model
{
    use HasFactory;

    protected $fillable = [
        'kode_trayek',
        'total_jarak',
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
}
