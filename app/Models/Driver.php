<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Driver extends Model
{
    use HasFactory;

    
    protected $primaryKey = 'id_driver';

    protected $fillable = [
        'id_driver',
        'id_kendaraan',
        'no_sim',
        'masa_berlaku_sim',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'id_driver');
    }

    public function kendaraan()
    {
        return $this->belongsTo(Kendaraan::class, 'id_kendaraan');
    }

    public function notifications()
    {
        return $this->hasMany(Notification::class, 'id_driver');
    }

    public function transactions()
    {
        return $this->hasMany(Transaction::class, 'id_driver');
    }
}
