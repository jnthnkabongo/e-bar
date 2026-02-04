<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ClotureDetail extends Model
{
    protected $fillable = [
        'cloture_id',
        'boisson_id',
        'quantite_vendue',
        'montant_vendu',
    ];

    protected $casts = [
        'montant_vendu' => 'decimal:2',
    ];

    public function cloture()
    {
        return $this->belongsTo(Cloture::class);
    }

    public function boisson()
    {
        return $this->belongsTo(Boisson::class);
    }
}
