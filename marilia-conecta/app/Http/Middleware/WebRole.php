<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class WebRole
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, ...$roles): Response
    {

        $user = Auth::user();

        if(!$user){
            abort(403, 'Usuario não encontrado');
        }

        if(!in_array($user->role, $roles, true)){
            abort(401, 'Não autorizado');
        }
        return $next($request);
    }
}
