<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;

// Route login / création d'utilisateur
Route::post('/login', [AuthController::class, 'apiConnexion']);

// Exemple route protégée (token requis)
Route::middleware('auth:sanctum')->group(function () {

    Route::get('/user-profile', [AuthController::class, 'profile']);

    Route::get('/dashboard', [AuthController::class, 'dashboard']);
    Route::get('/listeStock', [AuthController::class, 'listeStock']);
    Route::get('/stockParTypeBoisson', [AuthController::class, 'stockParTypeBoisson']);
    Route::get('/listeVente', [AuthController::class, 'listeVente']);
    Route::get('/historiques', [AuthController::class, 'historiques']);
    Route::get('/listeBoisson', [AuthController::class, 'listeBoisson']);
    Route::get('/listeTypeBoisson', [AuthController::class, 'listeTypeBoisson']);
    Route::get('/listeUser', [AuthController::class, 'listeUser']);
    Route::get('/listeCloture', [AuthController::class, 'listeCloture']);
    Route::get('/listeRole', [AuthController::class, 'listeRole']);
    Route::post('/ajouterStock', [AuthController::class, 'ajouterStock']);
    Route::post('/ajouterBoisson', [AuthController::class, 'ajouterBoisson']);
    Route::post('/ajouterTypeBoisson', [AuthController::class, 'ajouterTypeBoisson']);
    Route::post('/ajouterUser', [AuthController::class, 'ajouterUser']);
    Route::post('/ajouterUtilisateur', [AuthController::class, 'ajouterUtilisateur']);
    Route::post('/ajouterRole', [AuthController::class, 'ajouterRole']);
    Route::post('/ajouterCloture', [AuthController::class, 'ajouterCloture']);
    Route::post('/ajouterVente', [AuthController::class, 'ajouterVente']);
    Route::put('/updateStock/{stockId}', [AuthController::class, 'updateStock']);
    Route::delete('/deleteStock/{stockId}', [AuthController::class, 'deleteStock']);
    // (optionnel) logout
    Route::post('/logout', [AuthController::class, 'logout']);
});

