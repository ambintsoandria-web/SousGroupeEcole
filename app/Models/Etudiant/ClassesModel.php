<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class ClassesModel extends Model
{
    protected $table = 'classes';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'niveau_id',
        'annee_scolaire_id',
        'nom',
        'capacite_max',
        'created_at',
    ];
    protected $useTimestamps = true;
}
