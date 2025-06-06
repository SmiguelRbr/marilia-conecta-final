<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Ocorrencia extends Model
{
    protected $fillable = [
        'title',
        'image',
        'descricao',
        'comentario_adm',
        'avaliacao',
        'status',
        'user_id',
        'endereco',
    ];

    public function user(){
        return $this->belongsTo(User::class);
    }
}
