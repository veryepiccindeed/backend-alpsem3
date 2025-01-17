<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    // /**
    //  * Run the migrations.
    //  */
    public function up(): void
    {
        if (!Schema::hasTable('trayeks')) {
        Schema::create('trayeks', function (Blueprint $table) {
            $table->id();
            $table->string('kode_trayek');
            $table->integer('total_jarak');
            $table->unsignedBigInteger('id_schedule');
            $table->timestamps();

            $table->foreign('id_schedule')->references('id')->on('schedules')->onDelete('cascade');
        });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('trayeks');
    }
};
