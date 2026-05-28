<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class SalleModel extends Model
{
    protected $table = 'salles';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'etablissement_id',
        'nom',
        'capacite',
        'type',
        'is_active'
    ];
    protected $useTimestamps = true;
}