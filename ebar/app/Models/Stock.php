<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Stock extends Model
{
    protected $fillable = [
        'boisson_id',
        'user_id',
        'quantite_initiale',
        'quantite_actuelle',
    ];

    public function boisson()
    {
        return $this->belongsTo(Boisson::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
