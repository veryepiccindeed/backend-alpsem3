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
        if (!Schema::hasTable('drivers')) {
        Schema::create('drivers', function (Blueprint $table) {
            $table->id('id_driver')->constrained('users');
            $table->unsignedBigInteger('id_kendaraan');
            $table->integer('no_sim');
            $table->date('masa_berlaku_sim');
            $table->timestamps();

            $table->foreign('id_kendaraan')->references('id')->on('kendaraans')->onDelete('cascade');
        });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('drivers');
    }
};
