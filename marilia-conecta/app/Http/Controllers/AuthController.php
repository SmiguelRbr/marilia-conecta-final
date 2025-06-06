<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Tymon\JWTAuth\Facades\JWTAuth;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'cpf' => 'required|string|unique:users',
            'telefone' => 'required|string|unique:users',
            'password' => 'required|string|min:8',
        ], [
            'required' => 'Campos Faltando',
            'cpf.unique' => 'CPF já cadastrado',
            'cpf.telefone' => 'Telefone já cadastrado',
            'min' => 'A senha deve ter no minimo 8 caracteres',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $user = User::create([
            'name' => $request->name,
            'cpf' => $request->cpf,
            'telefone' => $request->telefone,
            'password' => Hash::make($request->password),
            'role' => 'user',
        ]);

        $token = JWTAuth::fromUser($user);

        return response()->json([
            'message' => 'Usuario registrado com sucesso',
            'user' => $user,
            'token' => $token,
        ], 200);
    }

    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'cpf' => 'required|string',
            'password' => 'required|string',
        ], [
            'required' => 'Campos Faltando',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $credenciais = $request->only('cpf', 'password');

        if(!$token = JWTAuth::attempt($credenciais)){
            return response()->json([
                'message' => 'Credenciais inválidas',
            ], 401);
        }

        return response()->json([
            'message' => 'Usuario logado com sucesso',
            'token' => $token,
        ], 200);
    }

    public function logout(){
        $user = JWTAuth::parseToken()->authenticate();

        if(!$user){
            return response()->json([
                'message' => 'Usuaro não encontrado',
            ], 403);
        }

        JWTAuth::invalidate(JWTAuth::getToken());

        return response()->json([
            'message' => 'Usuario deslogado com sucesso',
        ], 200);
    }

    public function refresh(){
        $user = JWTAuth::parseToken()->authenticate();

        if(!$user){
            return response()->json([
                'message' => 'Usuaro não encontrado',
            ], 403);
        }

        $newToken = JWTAuth::refresh(JWTAuth::getToken());

        return response()->json([
            'token' => $newToken
        ], 200);
    }
}
