# Guide de Sauvegarde Hybride - E-Bar

## 🎯 Objectif

Configurer l'application E-Bar pour fonctionner principalement en local avec sauvegarde périodique des données vers une base de données en ligne.

---

## 🏗️ Architecture Hybride

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Application   │    │   API Local     │    │   Base de       │
│   Mobile        │◄──►│   (Laravel)     │◄──►│   Données       │
│   (Flutter)     │    │   (Local)       │    │   (Locale)      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                │ Sauvegarde périodique
                                ▼
                       ┌─────────────────┐    ┌─────────────────┐
                       │   API Distant    │    │   Base de       │
                       │   (Laravel)      │◄──►│   Données       │
                       │   (En ligne)     │    │   (En ligne)    │
                       └─────────────────┘    └─────────────────┘
```

---

## 🚀 Étapes de Configuration

### Étape 1: Configuration de l'API Locale

#### 1.1 Installation Locale
```bash
# Cloner le projet dans un dossier local
git clone [repository-url] ebar-local
cd ebar-local

# Installer les dépendances
composer install

# Configuration de l'environnement local
cp .env.example .env.local
php artisan key:generate
```

#### 1.2 Configuration Base de Données Locale
```env
# .env.local
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=ebar_local
DB_USERNAME=root
DB_PASSWORD=

# URL locale
APP_URL=http://localhost:8000
```

#### 1.3 Migration Base de Données Locale
```bash
php artisan migrate --database=mysql_local
```

#### 1.4 Démarrage Serveur Local
```bash
php artisan serve --host=0.0.0.0 --port=8000
```

### Étape 2: Configuration de l'API En Ligne

#### 2.1 Hébergement (Options)
- **Heroku**: Gratuit pour petit projet
- **DigitalOcean**: VPS à $5/mois
- **AWS EC2**: Instance t2.micro gratuite
- **Shared Hosting**: Support Laravel

#### 2.2 Configuration Environnement En Ligne
```env
# .env.production
DB_CONNECTION=mysql
DB_HOST=votre-hosting-db.com
DB_PORT=3306
DB_DATABASE=ebar_online
DB_USERNAME=db_user
DB_PASSWORD=db_password

# URL en ligne
APP_URL=https://votre-domaine.com
```

#### 2.3 Déploiement En Ligne
```bash
# Sur le serveur distant
git pull origin main
composer install --no-dev
php artisan migrate --force
php artisan config:cache
php artisan route:cache
```

---

## 📱 Configuration Application Mobile

### Modification du Service API

#### 3.1 Créer un Service Hybride
```dart
// lib/services/hybrid_service.dart
class HybridApiService {
  static const String localUrl = 'http://192.168.1.100:8000/api';
  static const String onlineUrl = 'https://votre-domaine.com/api';
  
  // Utiliser API locale par défaut
  static Future<Map<String, dynamic>> login(Map<String, dynamic> credentials) async {
    return await _makeRequest('POST', '/login', credentials, useLocal: true);
  }
  
  // Sauvegarde périodique vers l'API en ligne
  static Future<Map<String, dynamic>> syncToOnline() async {
    try {
      // Récupérer toutes les données non synchronisées
      final unsyncedData = await _getUnsyncedData();
      
      // Envoyer vers l'API en ligne
      final response = await _makeRequest('POST', '/sync/bulk', unsyncedData, useLocal: false);
      
      if (response['success']) {
        // Marquer comme synchronisé
        await _markAsSynced();
      }
      
      return response;
    } catch (e) {
      return {'success': false, 'message': 'Erreur de synchronisation: $e'};
    }
  }
  
  static Future<Map<String, dynamic>> _makeRequest(
    String method, 
    String endpoint, 
    Map<String, dynamic> data,
    {bool useLocal = true}
  ) async {
    final url = useLocal ? localUrl : onlineUrl + endpoint;
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    // Ajouter le token si disponible
    final token = await _getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    try {
      final response = await http.Request(method, Uri.parse(url))
        ..headers.addAll(headers)
        ..body = jsonEncode(data);
      
      final streamedResponse = await response.send();
      final httpResponse = await http.Response.fromStream(streamedResponse);
      
      return {
        'success': httpResponse.statusCode >= 200 && httpResponse.statusCode < 300,
        'data': jsonDecode(httpResponse.body),
        'status': httpResponse.statusCode
      };
    } catch (e) {
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }
}
```

#### 3.2 Modification des Ventes pour Support Hybride
```dart
// Dans service.dart - modifier la méthode ajouterVente
static Future<Map<String, dynamic>> ajouterVente(Map<String, dynamic> venteData) async {
  try {
    // 1. Enregistrer localement d'abord
    final localResponse = await _makeLocalRequest('POST', '/ajouterVente', venteData);
    
    if (localResponse['success']) {
      // 2. Ajouter un marqueur de synchronisation
      final venteId = localResponse['data']['vente']['id'];
      await _markForSync('vente', venteId);
      
      // 3. Tenter synchronisation en ligne (async)
      _syncToOnlineAsync('vente', venteId, venteData);
    }
    
    return localResponse;
  } catch (e) {
    return {'success': false, 'message': 'Erreur: $e'};
  }
}
```

---

## 🔄 Système de Synchronisation

### Étape 4: Implémentation de la Synchronisation

#### 4.1 Table de Synchronisation
```sql
-- Créer une table pour suivre les synchronisations
CREATE TABLE sync_queue (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(50) NOT NULL,
    record_id BIGINT NOT NULL,
    action ENUM('create', 'update', 'delete') NOT NULL,
    data JSON NOT NULL,
    synced_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### 4.2 Modèle de Synchronisation
```php
// app/Models/SyncQueue.php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SyncQueue extends Model
{
    protected $fillable = [
        'table_name',
        'record_id',
        'action',
        'data',
        'synced_at'
    ];

    protected $casts = [
        'data' => 'array',
        'synced_at' => 'datetime',
    ];

    public function scopeUnsynced($query)
    {
        return $query->whereNull('synced_at');
    }
}
```

#### 4.3 Controller de Synchronisation
```php
// app/Http/Controllers/Api/SyncController.php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\SyncQueue;
use Illuminate\Http\Request;

class SyncController extends Controller
{
    public function bulkSync(Request $request)
    {
        $data = $request->all();
        $synced = [];
        $errors = [];
        
        foreach ($data['items'] ?? [] as $item) {
            try {
                $this->syncItem($item);
                $synced[] = $item['id'];
            } catch (\Exception $e) {
                $errors[] = [
                    'id' => $item['id'],
                    'error' => $e->getMessage()
                ];
            }
        }
        
        return response()->json([
            'success' => true,
            'synced_count' => count($synced),
            'error_count' => count($errors),
            'errors' => $errors
        ]);
    }
    
    private function syncItem($item)
    {
        $model = $this->getModelClass($item['table_name']);
        
        switch ($item['action']) {
            case 'create':
                $model::create($item['data']);
                break;
            case 'update':
                $record = $model::find($item['record_id']);
                if ($record) {
                    $record->update($item['data']);
                }
                break;
            case 'delete':
                $model::destroy($item['record_id']);
                break;
        }
    }
    
    private function getModelClass($tableName)
    {
        $models = [
            'ventes' => \App\Models\Vente::class,
            'stocks' => \App\Models\Stock::class,
            'boissons' => \App\Models\Boisson::class,
            'users' => \App\Models\User::class,
            'clotures' => \App\Models\Cloture::class,
        ];
        
        return $models[$tableName] ?? null;
    }
}
```

---

## ⚙️ Configuration Automatique

### Étape 5: Automatisation de la Sauvegarde

#### 5.1 Synchronisation Périodique dans Flutter
```dart
// lib/services/sync_service.dart
class SyncService {
  static Timer? _syncTimer;
  
  static void startPeriodicSync() {
    _syncTimer = Timer.periodic(Duration(minutes: 15), (timer) {
      _performSync();
    });
  }
  
  static Future<void> _performSync() async {
    try {
      // Vérifier la connexion internet
      if (await _hasInternetConnection()) {
        final result = await HybridApiService.syncToOnline();
        
        if (result['success']) {
          print('Synchronisation réussie: ${result['synced_count']} éléments');
        } else {
          print('Erreur de synchronisation: ${result['message']}');
        }
      }
    } catch (e) {
      print('Erreur lors de la synchronisation automatique: $e');
    }
  }
  
  static Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  static void stopPeriodicSync() {
    _syncTimer?.cancel();
  }
}
```

#### 5.2 Démarrage de la Synchronisation
```dart
// Dans main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Démarrer la synchronisation périodique
  SyncService.startPeriodicSync();
  
  runApp(MyApp());
}
```

---

## 📊 Monitoring et Gestion

### Étape 6: Interface de Monitoring

#### 6.1 Page de Synchronisation
```dart
// lib/pages/sync_page.dart
class SyncPage extends StatefulWidget {
  @override
  _SyncPageState createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
  bool _isSyncing = false;
  Map<String, dynamic>? _syncStatus;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Synchronisation')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text('Statut de la synchronisation'),
                subtitle: Text(_isSyncing ? 'En cours...' : 'Prêt'),
                trailing: _isSyncing 
                  ? CircularProgressIndicator() 
                  : Icon(Icons.check_circle, color: Colors.green),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSyncing ? null : _manualSync,
              child: Text('Synchroniser maintenant'),
            ),
            if (_syncStatus != null) ...[
              SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dernière synchronisation:', 
                        style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Éléments synchronisés: ${_syncStatus!['synced_count'] ?? 0}'),
                      Text('Erreurs: ${_syncStatus!['error_count'] ?? 0}'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Future<void> _manualSync() async {
    setState(() => _isSyncing = true);
    
    try {
      final result = await HybridApiService.syncToOnline();
      setState(() {
        _syncStatus = result;
        _isSyncing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['success'] ? 'Synchronisation réussie' : 'Erreur de synchronisation'),
          backgroundColor: result['success'] ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      setState(() => _isSyncing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
      );
    }
  }
}
```

---

## 🔧 Configuration Réseau

### Étape 7: Configuration Réseau Local

#### 7.1 Accès Réseau Local
```bash
# Trouver votre IP locale
ipconfig getifaddr en0  # macOS
# ou
hostname -I  # Linux

# Démarrer Laravel avec accès réseau
php artisan serve --host=0.0.0.0 --port=8000
```

#### 7.2 Configuration Mobile
```dart
// lib/config/app_config.dart
class AppConfig {
  // IP locale à adapter selon votre réseau
  static const String LOCAL_IP = '192.168.1.100';
  static const int LOCAL_PORT = 8000;
  
  static const String LOCAL_API_URL = 'http://$LOCAL_IP:$LOCAL_PORT/api';
  static const String ONLINE_API_URL = 'https://votre-domaine.com/api';
}
```

---

## 🚨 Gestion des Erreurs

### Étape 8: Stratégie de Gestion des Erreurs

#### 8.1 Mode Dégradé
```dart
// Si l'API en ligne n'est pas accessible, continuer en local
Future<Map<String, dynamic>> _smartSync() async {
  try {
    // Essayer l'API en ligne
    final onlineResult = await _makeRequest('POST', '/sync', data, useLocal: false);
    if (onlineResult['success']) {
      return onlineResult;
    }
  } catch (e) {
    print('API en ligne indisponible, utilisation locale');
  }
  
  // Revenir à l'API locale
  return await _makeRequest('POST', '/sync', data, useLocal: true);
}
```

#### 8.2 File d'Attente de Synchronisation
```dart
// Stocker les actions échouées pour réessayer plus tard
class SyncQueue {
  static final List<Map<String, dynamic>> _queue = [];
  
  static void addToQueue(Map<String, dynamic> item) {
    _queue.add(item);
    _saveQueueLocally();
  }
  
  static Future<void> processQueue() async {
    while (_queue.isNotEmpty) {
      final item = _queue.first;
      
      try {
        final result = await _syncItem(item);
        if (result['success']) {
          _queue.removeAt(0);
          _saveQueueLocally();
        } else {
          break; // Arrêter si erreur
        }
      } catch (e) {
        break;
      }
    }
  }
}
```

---

## 📈 Avantages de cette Architecture

### ✅ Avantages
- **Performance**: Rapidité du fonctionnement local
- **Fiabilité**: L'application fonctionne même sans internet
- **Sauvegarde**: Sécurité des données en ligne
- **Flexibilité**: Choix du moment de synchronisation
- **Coût**: Réduction des coûts d'hébergement

### ⚠️ Considérations
- **Complexité**: Architecture plus complexe à maintenir
- **Conflits**: Gestion des conflits de données
- **Stockage**: Double stockage des données
- **Sécurité**: Sécurisation des deux environnements

---

## 🎯 Recommandations

1. **Commencer en local** pour la performance
2. **Synchroniser régulièrement** (toutes les 15-30 minutes)
3. **Tester la connexion** avant synchronisation
4. **Gérer les erreurs** gracieusement
5. **Monitorer** l'état de synchronisation
6. **Sauvegarder** régulièrement la base en ligne

Cette configuration hybride vous offre le meilleur des deux mondes : la rapidité du local et la sécurité du cloud !
