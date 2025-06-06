<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;
use Tymon\JWTAuth\Facades\JWTAuth;

class CheckRole
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, ...$roles): Response
    {

        try {
            $user = JWTAuth::parseToken()->authenticate();

            if (!$user) {
                return response()->json([
                    'message' => 'Usuario não encontrado'
                ], Response::HTTP_FORBIDDEN);
            }

            if (!in_array($user->role, $roles, true)) {
                return response()->json([
                    'message' => 'Não autorizado'
                ], Response::HTTP_UNAUTHORIZED);
            }

            return $next($request);
        } catch (TokenInvalidException) {
            return response()->json([
                'message' => 'Token inválido'
            ], Response::HTTP_FORBIDDEN);
        } catch (TokenExpiredException) {
            return response()->json([
                'message' => 'Token expirado'
            ], Response::HTTP_FORBIDDEN);
        } catch (JWTException) {
            return response()->json([
                'message' => 'Token não identificado'
            ], Response::HTTP_FORBIDDEN);
        }
    }
}
