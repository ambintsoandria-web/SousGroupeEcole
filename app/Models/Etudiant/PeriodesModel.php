<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class PeriodesModel extends Model
{
    protected $table = 'periodes';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'libelle',
        'type_periode',
        'date_debut',
        'date_fin',
        'annee_scolaire',
        'created_at',
    ];
    protected $useTimestamps = true;
}
