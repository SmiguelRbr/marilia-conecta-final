<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\OcorrenciaController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
    Route::middleware('auth:api')->post('/logout', [AuthController::class, 'logout']);
    Route::post('/refresh', [AuthController::class, 'refresh']);
});

Route::middleware(['auth:api', 'check.role:user'])->group(function () {
    Route::get('/ocorrencias', [OcorrenciaController::class, 'userOcorrencias']);
    Route::post('/store', [OcorrenciaController::class, 'store']);
    Route::put('/ocorrencias/{ocorrencia}/avaliar', [OcorrenciaController::class, 'addAvaliacao']);
});