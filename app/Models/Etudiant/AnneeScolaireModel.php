<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class AnneeScolaireModel extends Model
{
    protected $table = 'annees_scolaires';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'etablissement_id',
        'libelle',
        'date_debut',
        'date_fin',
        'est_active',
        'created_at',
    ];
    protected $useTimestamps = true;
}
