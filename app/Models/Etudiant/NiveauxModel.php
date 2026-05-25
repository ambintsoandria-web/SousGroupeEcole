<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class NiveauxModel extends Model
{
    protected $table = 'niveaux';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'etablissement_id',
        'libelle',
        'ordre',
        'created_at',
    ];
    protected $useTimestamps = true;
}
