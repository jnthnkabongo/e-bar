<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TypeBoisson extends Model
{
    protected $fillable = [
        'type',
    ];

    public function boissons()
    {
        return $this->hasMany(Boisson::class);
    }
}
