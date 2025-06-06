<?php

namespace App\Http\Controllers;

use App\Models\Ocorrencia;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class OcorrenciaController extends Controller
{
    public function userOcorrencias(Request $request){
        $user = $request->user();

        $ocorrencias = $user->ocorrencias()->latest()->get();

        return response()->json([
            'ocorrencias' => $ocorrencias
        ]);
    }

    public function store(Request $request){
        $validator = Validator::make($request->all(), [
            'title' => 'required|string|max:100',
            'image' => 'required|file|mimes:jpeg,jpg,png|max:4096',
            'descricao' => 'required|string|max:500',
            'endereco' => 'required|string|max:150',
        ], [
            'required' => 'Campos faltando',
            'file' => 'Arquivo invalido',
            'mimes' => 'Tipo de arquivo invalido',
            'image.max' => 'Tamanho maximo permitido: 4MB',
            'max' => 'Tamanho de texto excedido',
        ]);

        if($validator->fails()){
            return response()->json($validator->errors(), 422);
        }

        $imagePath = $request->file('image')->store('ocorencias', 'public');

        $ocorrencia = Ocorrencia::create([
            'title' => $request->title,
            'image' => $imagePath,
            'descricao' => $request->descricao,
            'endereco' => $request->endereco,
            'user_id' => auth('api')->user()->id,
        ]);

        return response()->json([
            'message' => 'Ocorrencia criada com sucesso',
            'ocorrencia' => $ocorrencia,
        ], 200);
    }

    public function addAvaliacao(Request $request, Ocorrencia $ocorrencia){
        if($ocorrencia->status !== 'Resolvido' && $ocorrencia->status !== 'Recusado'){
            return response()->json([
                'message' => 'Você ainda não pode avaliar esta ocorrência',
            ], 401);
        }

        $validator = Validator::make($request->all(), [
            'avaliacao' => 'nullable|string|max:500',
        ], [
            'max' => 'Tamanho de texto excedido',
        ]);

        if($validator->fails()){
            return response()->json($validator->errors());
        }

        $ocorrencia->update([
            'avaliacao' => $request->avaliacao,
        ]);

        return response()->json([
            'message' => 'Obrigado pela sua avaliação!',
        ], 200);
    }
}
