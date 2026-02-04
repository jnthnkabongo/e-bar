<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Cloture extends Model
{
    protected $fillable = [
        'user_id',
        'date_cloture',
        'montant_total',
    ];

    protected $casts = [
        'date_cloture' => 'date',
        'montant_total' => 'decimal:2',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function clotureDetails()
    {
        return $this->hasMany(ClotureDetail::class);
    }
}
