<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use App\Models\Stock;
use App\Models\Vente;
use App\Models\TypeBoisson;
use App\Models\Historique;
use App\Models\Boisson;
use App\Models\Role;
use App\Models\Cloture;
use App\Models\ClotureDetail;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class AuthController extends Controller
{
   
//  Connexion API
    protected function ajouterHistorique(string $typeAction, ?string $details = null){
        $user = Auth::user();

        if ($user) {
            Historique::create([
                'user_id' => $user->id,
                'type_action' => $typeAction,
                'details' => $details,
            ]);
        }
    }

    
    public function apiConnexion(Request $request)
    {
        $credentials = $request->only('email','password');

        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        if (Auth::attempt($credentials)) {
            $user = Auth::user();
            $user->load('role'); // Charger la relation après auth
            
            // Debug pour voir les données
            \Log::info('User ID: ' . $user->id);
            \Log::info('Role ID: ' . $user->role_id);
            \Log::info('Role Name: ' . optional($user->role)->nom);

            //Enregistrement historiques
            $this->ajouterHistorique('Connexion', 'Utilisateur connecté avec succès');

            return response()->json([
                'message' => 'Connexion réussie',
                'acces_token' => $user->createToken('auth_token')->plainTextToken,
                'user' => [
                    'id' => $user->id,
                    'email' => $user->email,
                    'name' => $user->nom,
                    'role_id' => (int)$user->role_id, // Forcer en entier
                    'role_name' => optional($user->role)->nom
                ],
            ], 200);
        }
        
        return response()->json([
            'message' => 'Identifiants invalides'
        ], 401);
    }
    //Profile de l'utilisateur
    public function profile(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'user' => [
                'id' => $user->id,
                'email' => $user->email,
                'name' => $user->nom,
                'role_id' => $user->role_id,
                'role_name' => optional($user->role)->nom,
            ],
            'access_token' => $request->bearerToken(),
        ], 200);
    }
    //Dashboard 
    public function dashboard(){
        $user = Auth::user(); 

        if (!$user) {
            return response()->json([
                'message' => 'Non authentifié'
            ], 401);
        }

        $sommeStock = Stock::where('quantite_actuelle', '>', 0)->sum('quantite_actuelle');
        $sommeVente = Vente::whereDate('created_at', Carbon::today())->sum('quantite');
        $sommeUtilisateur = User::count();
        $sommeVendu = Vente::where('quantite', '>', '0')->sum('quantite');
        
        $sommeMontantVenteToday = Vente::with('boisson')
            ->where('created_at', '>=', Carbon::today())
            ->get()
            ->sum(function ($vente) {
                return $vente->quantite * $vente->boisson->prix;
            });

        // Somme des prix des boissons dans quantite_initial
        $sommePrixQuantiteInitiale = Stock::with('boisson')
            ->where('quantite_initiale', '>', 0)
            ->get()
            ->sum(function ($stock) {
                return $stock->quantite_initiale * $stock->boisson->prix;
            });

        //Somme des prix des boissons dans quantite_acuel
        $sommePrixQuantiteActuelle = Stock::with('boisson')
            ->where('quantite_actuelle', '>', 0)
            ->get()
            ->sum(function ($stock) {
                return $stock->quantite_actuelle * $stock->boisson->prix;
        });

        return response()->json([
            'user' => [
                'id' => $user->id,
                'email' => $user->email,
                'name' => $user->nom,
                'role_id' => $user->role_id,
                'role_name' => optional($user->role)->nom,
            ],
            'stats' => [
                'total_stock' => $sommeStock,
                'total_vente' => $sommeVente,
                'total_utilisateurs' => $sommeUtilisateur,
                'total_vendu' => $sommeVendu,
                'somme_prix_quantite_initiale' => $sommePrixQuantiteInitiale,
                'somme_prix_quantite_actuel' => $sommePrixQuantiteActuelle,
                'somme_vente_today' => $sommeMontantVenteToday,
            ]
        ], 200);
    }

    // Ajout de stock
    public function ajouterStock(Request $request)
    {
        $user = Auth::user();

        if (!$user) {
            return response()->json([
                'message' => 'Non authentifié'
            ], 401);
        }

        $request->validate([
            'boisson_id' => 'required|exists:boissons,id',
            'quantite' => 'required|integer|min:1'
        ]);

        // Vérifier si un stock existe déjà pour cette boisson
        $stockExist = Stock::where('boisson_id', $request->boisson_id)->first();

        if ($stockExist) {
            // Mettre à jour le stock existant
            $stockExist->quantite_actuelle += $request->quantite;
            $stockExist->quantite_initiale += $request->quantite;
            $stockExist->save();
        } else {
            // Créer un nouveau stock
            Stock::create([
                'boisson_id' => $request->boisson_id,
                'user_id' => $user->id,
                'quantite_initiale' => $request->quantite,
                'quantite_actuelle' => $request->quantite,
            ]);
        }

        $this->ajouterHistorique('Ajout Stock', "Ajout de {$request->quantite} unités pour la boisson ID: {$request->boisson_id}");

        return response()->json([
            'message' => 'Stock ajouté avec succès',
            'quantite_ajoutee' => $request->quantite
        ], 200);
    }

    // Ajout de boisson
    public function ajouterBoisson(Request $request)
    {
        $user = Auth::user();

        if (!$user) {
            return response()->json([
                'message' => 'Non authentifié'
            ], 401);
        }

        $request->validate([
            'nom' => 'required|string|max:255',
            'type_boisson_id' => 'required|exists:type_boissons,id',
            'prix' => 'required|numeric|min:0',
            'description' => 'nullable|string',
            'image' => 'nullable|string'
        ]);

        $boisson = Boisson::create([
            'nom' => $request->nom,
            'type_boisson_id' => $request->type_boisson_id,
            'prix' => $request->prix,
            'description' => $request->description,
            'image' => $request->image,
        ]);

        $this->ajouterHistorique('Ajout Boisson', "Ajout de la boisson: {$boisson->nom}");

        return response()->json([
            'message' => 'Boisson ajoutée avec succès',
            'boisson' => $boisson
        ], 201);
    }

    // Ajout de clôture
    public function ajouterCloture(Request $request)
    {
        $user = Auth::user();

        if (!$user) {
            return response()->json([
                'message' => 'Non authentifié'
            ], 401);
        }

        // Si aucune donnée n'est fournie, générer automatiquement la clôture du jour
        if (!$request->has('date_cloture') && !$request->has('details')) {
            $dateCloture = now()->format('Y-m-d');
            
            // Récupérer toutes les ventes du jour
            $ventesDuJour = Vente::with('boisson')
                ->whereDate('created_at', $dateCloture)
                ->get();
            
            if ($ventesDuJour->isEmpty()) {
                return response()->json([
                    'message' => 'Aucune vente trouvée pour aujourd\'hui',
                    'date_cloture' => $dateCloture
                ], 400);
            }
            
            // Grouper les ventes par boisson
            $ventesParBoisson = $ventesDuJour->groupBy('boisson_id');
            
            $details = [];
            foreach ($ventesParBoisson as $boissonId => $ventes) {
                $quantiteTotale = $ventes->sum('quantite');
                $montantTotal = $ventes->sum(function ($vente) {
                    return $vente->quantite * $vente->prix;
                });
                
                $details[] = [
                    'boisson_id' => $boissonId,
                    'quantite_vendue' => $quantiteTotale,
                    'montant_vendu' => $montantTotal
                ];
            }
            
            $montantTotal = $ventesDuJour->sum(function ($vente) {
                return $vente->quantite * $vente->prix;
            });
            
            // Créer la clôture principale
            $cloture = Cloture::create([
                'user_id' => $user->id,
                'date_cloture' => $dateCloture,
                'montant_total' => $montantTotal,
            ]);
            
            // Créer les détails de la clôture
            foreach ($details as $detail) {
                ClotureDetail::create([
                    'cloture_id' => $cloture->id,
                    'boisson_id' => $detail['boisson_id'],
                    'quantite_vendue' => $detail['quantite_vendue'],
                    'montant_vendu' => $detail['montant_vendu'],
                ]);
            }
            
            $this->ajouterHistorique('Clôture automatique', "Clôture automatique du {$dateCloture} - Total: {$montantTotal} - {$ventesDuJour->count()} ventes");
            
            return response()->json([
                'message' => 'Clôture automatique effectuée avec succès',
                'cloture' => $cloture->load('clotureDetails.boisson'),
                'montant_total' => $montantTotal,
                'nombre_ventes' => $ventesDuJour->count(),
                'date_cloture' => $dateCloture
            ], 201);
        }
        
        $request->validate([
            'date_cloture' => 'required|date',
            'details' => 'required|array',
            'details.*.boisson_id' => 'required|exists:boissons,id',
            'details.*.quantite_vendue' => 'required|integer|min:1',
            'details.*.montant_vendu' => 'required|numeric|min:0'
        ]);

        // Calculer le montant total
        $montantTotal = collect($request->details)->sum('montant_vendu');

        // Créer la clôture principale
        $cloture = Cloture::create([
            'user_id' => $user->id,
            'date_cloture' => $request->date_cloture,
            'montant_total' => $montantTotal,
        ]);

        // Créer les détails de la clôture
        foreach ($request->details as $detail) {
            ClotureDetail::create([
                'cloture_id' => $cloture->id,
                'boisson_id' => $detail['boisson_id'],
                'quantite_vendue' => $detail['quantite_vendue'],
                'montant_vendu' => $detail['montant_vendu'],
            ]);
        }

        $this->ajouterHistorique('Clôture', "Clôture du {$request->date_cloture} - Total: {$montantTotal}");

        return response()->json([
            'message' => 'Clôture ajoutée avec succès',
            'cloture' => $cloture->load('clotureDetails.boisson'),
            'montant_total' => $montantTotal
        ], 201);
    }

    // Ajout de vente
    public function ajouterVente(Request $request)
    {
        $user = Auth::user();

        if (!$user) {
            return response()->json([
                'message' => 'Non authentifié'
            ], 401);
        }

        $request->validate([
            'boisson_id' => 'required|exists:boissons,id',
            'quantite' => 'required|integer|min:1',
            'prix' => 'required|numeric|min:0'
        ]);

        // Vérifier si le stock est suffisant
        $stock = Stock::where('boisson_id', $request->boisson_id)->first();
        
        if (!$stock || $stock->quantite_actuelle < $request->quantite) {
            return response()->json([
                'message' => 'Stock insuffisant pour cette vente'
            ], 400);
        }

        // Créer la vente
        $vente = Vente::create([
            'boisson_id' => $request->boisson_id,
            'user_id' => $user->id,
            'quantite' => $request->quantite,
            'prix' => $request->prix,
        ]);

        // Mettre à jour le stock
        $stock->quantite_actuelle -= $request->quantite;
        $stock->save();

        $montantTotal = $request->quantite * $request->prix;

        $this->ajouterHistorique('Vente', "Vente de {$request->quantite} unités - Boisson ID: {$request->boisson_id} - Montant: {$montantTotal}");

        return response()->json([
            'message' => 'Vente effectuée avec succès',
            'vente' => $vente->load('boisson'),
            'stock_restant' => $stock->quantite_actuelle,
            'montant_total' => $montantTotal
        ], 201);
    }

    //liste stock
    public function listeStock(){

        $user = Auth::user(); 

        if (!$user) {
            return response()->json([
                'message' => 'Non authentifié'
            ], 401);
        }

        $this->ajouterHistorique('Consultation Stock', 'A consulté la liste des stocks');

        // 1️⃣ Liste des stocks avec boisson + type
        $stocks = Stock::with('boisson.typeBoisson')->get();

        // 2️⃣ Somme totale du stock
        $sommeStock = Stock::sum('quantite_actuelle');

        // 3️⃣ Somme par type de boisson
        $sommeParType = TypeBoisson::with(['boissons.stocks'])
        ->get()
        ->map(function ($type) {
            return [
                'type_boisson_id' => $type->id,
                'type_boisson' => $type->type,
                'quantite_totale' => $type->boissons
                    ->flatMap->stocks
                    ->sum('quantite_actuelle'),
            ];
        });

        return response()->json([
            'stock' => $stocks,
            'sommeStock' => $sommeStock,
            'sommeParType' => $sommeParType,
        ], 200);
    }
    //liste cloture
    public function listeCloture(){
        $user = Auth::user(); 

        if (!$user) {
            return response()->json([
                'message' => 'Non authentifié'
            ], 401);
        }

        $this->ajouterHistorique('Consultation Cloture', 'A consulté la liste de cloture'); 
        $clotutes = Cloture::all();
        return response()->json([
            'clotures' => $clotutes,
        ], 200);
    }
    //Liste vente
    public function listeVente(){
        $user = Auth::user(); 

        if (!$user) {
            return response()->json([
                'message' => 'Non authentifié'
            ], 401);
        }

        $this->ajouterHistorique('Consultation Vente', 'A consulté la liste de vente');

         // Récupérer toutes les ventes avec les relations
        $ventes = Vente::with(['boisson', 'user'])
            ->orderBy('created_at', 'desc')
            ->get();

        // Grouper par date (YYYY-MM-DD)
        $ventesParDate = $ventes->groupBy(function ($vente) {
            return $vente->created_at->format('Y-m-d');
        });

        return response()->json([
            'ventes_par_date' => $ventesParDate,
        ], 200);
    }

    //Historiques liste 
  
    public function historiques()
    {
        $user = Auth::user();

        if (!$user) {
            return response()->json(['message' => 'Non authentifié'], 401);
        }

        $historiques = Historique::with('user')
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'historiques' => $historiques,
        ], 200);
    }

    // Ajout d'utilisateur
    public function ajouterUtilisateur(Request $request)
    {
        $user = Auth::user();

        if (!$user) {
            return response()->json([
                'message' => 'Non authentifié'
            ], 401);
        }

        $request->validate([
            'nom' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|string|min:6',
            'role_id' => 'required|exists:roles,id'
        ]);

        try {
            $nouvelUtilisateur = User::create([
                'nom' => $request->nom,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'role_id' => $request->role_id,
            ]);

            // Enregistrement dans l'historique
            $this->ajouterHistorique('Ajout utilisateur', "Nouvel utilisateur ajouté: {$nouvelUtilisateur->nom} ({$nouvelUtilisateur->email})");

            return response()->json([
                'message' => 'Utilisateur ajouté avec succès',
                'user' => [
                    'id' => $nouvelUtilisateur->id,
                    'nom' => $nouvelUtilisateur->nom,
                    'email' => $nouvelUtilisateur->email,
                    'role_id' => $nouvelUtilisateur->role_id,
                    'role_name' => optional($nouvelUtilisateur->role)->nom,
                    'created_at' => $nouvelUtilisateur->created_at
                ]
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Erreur lors de l\'ajout de l\'utilisateur',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Liste des utilisateurs avec leurs rôles
    public function listeUser()
    {
        $user = Auth::user();

        if (!$user) {
            return response()->json([
                'message' => 'Non authentifié'
            ], 401);
        }

        $this->ajouterHistorique('Consultation Utilisateurs', 'A consulté la liste des utilisateurs');

        // Récupérer tous les utilisateurs avec leurs rôles
        $users = User::with('role')->orderBy('created_at', 'desc')->get();

        // Transformer les données pour inclure les informations du rôle
        $usersWithRoles = $users->map(function ($user) {
            return [
                'id' => $user->id,
                'nom' => $user->nom,
                'email' => $user->email,
                'role_id' => $user->role_id,
                'is_active' => $user->is_active ?? true,
                'created_at' => $user->created_at,
                'updated_at' => $user->updated_at,
                'role' => $user->role ? [
                    'id' => $user->role->id,
                    'nom' => $user->role->nom
                ] : null,
            ];
        });

        return response()->json([
            'users' => $usersWithRoles,
            'total' => $users->count()
        ], 200);
    }

    // Liste des types de boissons
    public function listeTypeBoisson()
    {
        $user = Auth::user();

        if (!$user) {
            return response()->json([
                'message' => 'Non authentifié'
            ], 401);
        }

        $this->ajouterHistorique('Consultation Types Boissons', 'A consulté la liste des types de boissons');

        // Récupérer tous les types de boissons
        $typeBoissons = TypeBoisson::orderBy('type', 'asc')->get();

        // Transformer les données
        $typeBoissonsFormatted = $typeBoissons->map(function ($typeBoisson) {
            return [
                'id' => $typeBoisson->id,
                'type' => $typeBoisson->type,
                'nombre_boissons' => $typeBoisson->boissons()->count(),
                'created_at' => $typeBoisson->created_at,
                'updated_at' => $typeBoisson->updated_at
            ];
        });

        return response()->json([
            'type_boissons' => $typeBoissonsFormatted,
            'total' => $typeBoissons->count()
        ], 200);
    }

    // Ajout d'un type de boisson
    public function ajouterTypeBoisson(Request $request)
    {
        $user = Auth::user();

        if (!$user) {
            return response()->json([
                'message' => 'Non authentifié'
            ], 401);
        }

        // Validation des données
        $request->validate([
            'type' => 'required|string|max:255|unique:type_boissons,type',
        ]);

        try {
            // Création du type de boisson
            $typeBoisson = TypeBoisson::create([
                'type' => $request->type,
            ]);

            // Enregistrement dans l'historique
            $this->ajouterHistorique('Ajout Type Boisson', "Nouveau type de boisson ajouté: {$typeBoisson->type}");

            return response()->json([
                'message' => 'Type de boisson ajouté avec succès',
                'type_boisson' => [
                    'id' => $typeBoisson->id,
                    'type' => $typeBoisson->type,
                    'created_at' => $typeBoisson->created_at
                ]
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Erreur lors de l\'ajout du type de boisson',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function listeBoisson(){
        $user = Auth::user();

        if (!$user) {
            return response()->json([
                'message' => 'Non authentifié'
            ], 401);
        }

        $this->ajouterHistorique('Consultation Boissons', 'A consulté la liste des boissons');
        $boissons = Boisson::with(['typeBoisson', 'stocks'])
        ->get()
        ->map(function ($boisson) {
            return [
                'id' => $boisson->id,
                'boisson' => $boisson->nom,
                'type_boisson' => optional($boisson->typeBoisson)->type,
                'prix' => $boisson->prix,
                'quantite_totale' => $boisson->stocks->sum('quantite_actuelle'),
            ];
        });

        return response()->json([
            'boissons' => $boissons,
            'total' => $boissons->count()
        ], 200);
    }
    public function logout(Request $request)
    {
        $user = $request->user();

        if (!$user) {
            return response()->json([
                'message' => 'Non authentifié'
            ], 401);
        }

        // Supprimer le token courant
        $request->user()->currentAccessToken()->delete();

        // Historique
        $this->ajouterHistorique('Déconnexion', 'Utilisateur déconnecté');

        return response()->json([
            'message' => 'Déconnexion réussie'
        ], 200);
    }

}
