<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Historique extends Model
{
    protected $fillable = [
        'user_id',
        'type_action',
        'details',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
