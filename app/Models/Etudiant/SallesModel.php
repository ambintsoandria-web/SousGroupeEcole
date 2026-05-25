<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class SallesModel extends Model
{
    protected $table = 'salles';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'etablissement_id',
        'nom',
        'capacite',
        'type',
        'is_active',
        'created_at',
    ];
    protected $useTimestamps = true;
}
