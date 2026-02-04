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
        Schema::create('cloture_details', function (Blueprint $table) {
            $table->id();
            $table->foreignId('cloture_id')->constrained()->onDelete('cascade');
            $table->foreignId('boisson_id')->constrained()->onDelete('cascade');
            $table->integer('quantite_vendue');
            $table->decimal('montant_vendu', 10, 2);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cloture_details');
    }
};
