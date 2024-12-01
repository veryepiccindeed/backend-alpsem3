<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        if (!Schema::hasTable('notifications')) {
        Schema::create('notifications', function (Blueprint $table) {
            $table->id();
            $table->string('judul');
            $table->string('pesan'); 
            $table->enum('jenis', ['info', 'promo', 'akun']); 
            $table->unsignedBigInteger('id_driver')->nullable(); 
            $table->unsignedBigInteger('id_user')->nullable(); 
            $table->timestamps();
    
            $table->foreign('id_user')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('id_driver')->references('id_driver')->on('drivers')->onDelete('cascade');
        });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('notifications');
    }
};
