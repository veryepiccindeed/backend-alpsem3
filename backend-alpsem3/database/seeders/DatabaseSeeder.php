<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        DB::statement('SET FOREIGN_KEY_CHECKS=0;');


        // Truncate tables to reset auto-increment
        DB::table('users')->truncate();
        DB::table('kendaraans')->truncate();
        DB::table('haltes')->truncate();
        DB::table('schedules')->truncate();
        DB::table('trayeks')->truncate();
        DB::table('drivers')->truncate();
        DB::table('notifications')->truncate();
        DB::table('transactions')->truncate();
        DB::table('trayek_haltes')->truncate();

        // Enable foreign key checks
        DB::statement('SET FOREIGN_KEY_CHECKS=1;');


        // Users
        DB::table('users')->insert([
            [
            'nama' => 'John Doe',
            'email' => 'john.doe@example.com',
            'password' => 'inipassword', 
            'no_hp' => '081234567890',
            'alamat' => 'Jl. Contoh No. 1',
            'gender' => 'laki-laki',
            'tgl_lahir' => '1990-01-01',
            'role' => 'customer',
            'foto_profil' => null,
            ],
            [
                'nama' => 'John Doe 2',
                'email' => 'john.doe2@example.com',
                'password' => 'inipassword2', 
                'no_hp' => '081234567899',
                'alamat' => 'Jl. Contoh No. 2',
                'gender' => 'laki-laki',
                'tgl_lahir' => '1990-01-02',
                'role' => 'driver',
                'foto_profil' => null,
            ]
                        [
                'nama' => 'John Doe 2',
                'email' => 'john.doe2@example.com',
                'password' => 'inipassword2', 
                'no_hp' => '081234567899',
                'alamat' => 'Jl. Contoh No. 2',
                'gender' => 'laki-laki',
                'tgl_lahir' => '1990-01-02',
                'role' => 'driver',
                'foto_profil' => null,
            ]
        ]);

        // Kendaraans
        DB::table('kendaraans')->insert([
            'no_plat' => 'B 1234 ABC',
            'tahun_kendaraan' => 2020,
            'is_tersedia' => true,
            'koordinat' => 'X 696969, Y 707070', 
        ]);

        // Haltes
        DB::table('haltes')->insert([
            ['nama_halte' => 'Halte A', 'koordinat' => 'X 696969, Y 707070'],
            ['nama_halte' => 'Halte B', 'koordinat' => 'X 696969, Y 707070'],
        ]);

        // Schedules
        DB::table('schedules')->insert([
            [
                'id_kendaraan' => 1, // Ensure this ID exists in kendaraans
                'waktu_berangkat' => now(),
                'waktu_tiba' => now()->addHours(1),
            ],
        ]);

        // Trayeks
        DB::table('trayeks')->insert([  
            'kode_trayek' => 'A',
            'total_jarak' => 10,
            'id_schedule' => 1, // Ensure this ID exists in schedules
        ]);

        // Drivers
        DB::table('drivers')->insert([
            'id_driver' => 2, // Ensure this ID exists in users
            'id_kendaraan' => 1, // Ensure this ID exists in kendaraans
            'no_sim' => 123456789,
            'masa_berlaku_sim' => '2025-01-01',
            'foto_profil' => null,
            'foto_ktp' => null,
            'foto_sim' => null,
        ]);

        // Notifications
        DB::table('notifications')->insert([
            [
                'judul' => 'Info Perjalanan',
                'pesan' => 'Perjalanan Anda dimulai.',
                'jenis' => 'info',
                'id_driver' => 2, // Ensure this ID exists in drivers
                'id_user' => 1, // Ensure this ID exists in users
            ],
            [
                'judul' => 'Promo Spesial',
                'pesan' => 'Dapatkan diskon 20% untuk perjalanan berikutnya.',
                'jenis' => 'promo',
                'id_driver' => null,
                'id_user' => 1, // Ensure this ID exists in users
            ],
        ]);

        // Transactions
        DB::table('transactions')->insert([
            [
                'id_user' => 1, // Ensure this ID exists in users
                'id_driver' => 2, // Ensure this ID exists in drivers
                'payment_amount' => 100000,
                'payment_status' => 1, // Sukses
                'jumlah_tiket' => 2,
            ],
        ]);

        // Trayek Haltes
        DB::table('trayek_haltes')->insert([
            [
                'id_trayek' => 1, // Ensure this ID exists in trayeks
                'id_halte' => 1, // Ensure this ID exists in haltes
                'urutan_halte_dalam_trayek' => 1,
                'jarak_ke_halte_berikutnya' => 5,
                'estimasi_waktu' => '15 menit',
            ],
            [
                'id_trayek' => 1, // Ensure this ID exists in trayeks
                'id_halte' => 2, // Ensure this ID exists in haltes
                'urutan_halte_dalam_trayek' => 2,
                'jarak_ke_halte_berikutnya' => 5,
                'estimasi_waktu' => '20 menit',
            ],
        ]);
    }
}
