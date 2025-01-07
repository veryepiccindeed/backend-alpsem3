<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    // /**
    //  * Run the migrations.
    //  */
    // public function up(): void
    // {
    //     if (!Schema::hasTable('trayek_haltes')) {
    //     Schema::create('trayek_haltes', function (Blueprint $table) {
    //         $table->id();
    //         $table->unsignedBigInteger('id_trayek');
    //         $table->unsignedBigInteger('id_halte');
    //         $table->integer('urutan_halte_dalam_trayek');
    //         $table->integer('jarak_ke_halte_berikutnya');
    //         $table->string('estimasi_waktu')->nullable();
    //         $table->timestamps();

    //         $table->foreign('id_trayek')->references('id')->on('trayeks')->onDelete('cascade');
    //         $table->foreign('id_halte')->references('id')->on('haltes')->onDelete('cascade');
    //     });
    //     }
    // }

    // /**
    //  * Reverse the migrations.
    //  */
    // public function down(): void
    // {
    //     Schema::dropIfExists('trayek_haltes');
    // }
};
