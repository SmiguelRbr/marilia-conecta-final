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
        Schema::create('ocorrencias', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->string('image');
            $table->text('descricao');
            $table->text('comentario_adm')->nullable();
            $table->text('avaliacao')->nullable();
            $table->string('endereco');
            $table->enum('status', ['Pendente', 'Aberto', 'Analisando', 'Recusado', 'Resolvido'])->default('Pendente');
            $table->foreignId('user_id')->constrained('users');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('ocorrencias');
    }
};
