<?php

use App\Http\Controllers\WebController;
use Illuminate\Support\Facades\Route;

//Rotas get
Route::get('/login', [WebController::class, 'showLogin'])->name('form.login');
Route::get('/register', [WebController::class, 'showRegister'])->name('form.register');

//Rotas post
Route::post('/login', [WebController::class, 'login'])->name('login');
Route::post('/register', [WebController::class, 'register'])->name('register');

//Rotas protegidas
Route::middleware(['auth:web', 'web.role:admin'])->group(function () {
    Route::get('/dashboard', [WebController::class, 'index'])->name('dashboard');
    Route::post('/abrir/{ocorrencia}', [WebController::class, 'abrir'])->name('ocorrencia.abrir');
    Route::post('/atualizar/{ocorrencia}', [WebController::class, 'atualizar'])->name('ocorrencia.atualizar');
    Route::post('/logout', [WebController::class, 'logout'])->name('logout');
    Route::get('/admin', [WebController::class, 'adm'])->name('form');
    Route::post('/registeradm', [WebController::class, 'admRegister'])->name('registeradm');
});
    
