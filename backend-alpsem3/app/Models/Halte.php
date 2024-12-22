<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Halte extends Model
{
    use HasFactory;

    // Specify the table name if it doesn't follow Laravel's naming convention
    protected $table = 'haltes';

    protected $fillable = [
        'nama_halte',
        'koordinat',
    ];

    public function trayekHaltes()
    {
        return $this->hasMany(TrayekHalte::class, 'id_halte');
    }
}
