<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TrayekHalte extends Model
{
    use HasFactory;

    protected $fillable = [
        'id_trayek',
        'id_halte',
        'urutan_halte_dalam_trayek',
        'jarak_ke_halte_berikutnya',
        'estimasi_waktu',
    ];

    public function trayek()
    {
        return $this->belongsTo(Trayek::class, 'id_trayek');
    }

    public function halte()
    {
        return $this->belongsTo(Halte::class, 'id_halte');
    }
}
