<?php

namespace App\Http\Controllers;

use App\Models\Ocorrencia;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class WebController extends Controller
{
    public function showRegister()
    {
        return view('register');
    }

    public function showLogin()
    {
        return view('login');
    }

    public function adm(){
        return view('admregister');
    }

    public function admRegister(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'cpf' => 'required|string|unique:users',
            'telefone' => 'required|string|unique:users',
            'password' => 'required|string|confirmed|min:8',
        ], [
            'required' => 'Campos Faltando',
            'cpf.unique' => 'CPF já cadastrado',
            'telefone.unique' => 'Telefone já cadastrado',
            'min' => 'A senha deve ter no minimo 8 caracteres',
            'confirmed' => 'Senhas não conferem'
        ]);

        if ($validator->fails()) {
            return redirect()->back()->withErrors($validator)->withInput();
        }

        User::create([
            'name' => $request->name,
            'cpf' => $request->cpf,
            'telefone' => $request->telefone,
            'password' => Hash::make($request->password),
            'role' => 'admin',
        ]);

        return redirect()->route('form.login')->with('success', 'Usuario registrado com sucesso');
    }

    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'cpf' => 'required|string|unique:users',
            'telefone' => 'required|string|unique:users',
            'password' => 'required|string|confirmed|min:8',
        ], [
            'required' => 'Campos Faltando',
            'cpf.unique' => 'CPF já cadastrado',
            'telefone.unique' => 'Telefone já cadastrado',
            'min' => 'A senha deve ter no minimo 8 caracteres',
            'confirmed' => 'Senhas não conferem'
        ]);

        if ($validator->fails()) {
            return redirect()->back()->withErrors($validator)->withInput();
        }

        User::create([
            'name' => $request->name,
            'cpf' => $request->cpf,
            'telefone' => $request->telefone,
            'password' => Hash::make($request->password),
            'role' => 'user',
        ]);

        return redirect()->route('form.login')->with('success', 'Usuario registrado com sucesso');
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
            return redirect()->back()->withErrors($validator)->withInput();
        }

        $credenciais = $request->only('cpf', 'password');

        if (Auth::attempt($credenciais)) {
            $request->session()->regenerate();
            return redirect()->route('dashboard');
        }

        return redirect()->back()->withErrors([
            'Credemciais Inválidas'
        ])->withInput();
    }

    public function logout(Request $request)
    {
        Auth::logout();

        $request->session()->invalidate();
        $request->session()->regenerate();
        return redirect()->route('form.login')->with('success', 'Usuario deslogado com sucesso');
    }

    public function index(Request $request)
    {

        $ocorrencias = Ocorrencia::with('user')->latest()->get();

        return view('dashboard', compact('ocorrencias'));
    }

    public function abrir(Request $request, Ocorrencia $ocorrencia)
    {
        if ($ocorrencia->status == 'Pendente') {
            $ocorrencia->status = 'Aberto';
            $ocorrencia->save();
        }

        return redirect()->back()->with('opened', $ocorrencia->id);
    }

    public function atualizar(Request $request, Ocorrencia $ocorrencia)
    {
        if ($ocorrencia->status !== 'Pendente') {
            $ocorrencia->status = $request->status;
            $ocorrencia->comentario_adm = $request->comentario_adm;
            $ocorrencia->save();
        }

        return redirect()->back();
    }
}
