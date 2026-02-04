<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Boisson extends Model
{
    protected $fillable = [
        'nom',
        'type_boisson_id',
        'prix',
        'description',
        'image',
    ];

    protected $casts = [
        'prix' => 'decimal:2',
    ];

    public function typeBoisson()
    {
        return $this->belongsTo(TypeBoisson::class);
    }

    public function stocks()
    {
        return $this->hasMany(Stock::class);
    }

    public function ventes()
    {
        return $this->hasMany(Vente::class);
    }

    public function clotureDetails()
    {
        return $this->hasMany(ClotureDetail::class);
    }
}
