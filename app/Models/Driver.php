<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Model;

class Driver extends Model
{
    use HasApiTokens, HasFactory, Notifiable;

    
    protected $primaryKey = 'id_driver';

    protected $fillable = [
            'id_driver',
            'nama',
            'email',
            'password',
            'alamat',
            'tgl_lahir',
            'no_hp',
            'gender',
            'id_kendaraan'
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
    ];


   
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
