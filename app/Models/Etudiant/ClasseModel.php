<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class ClasseModel extends Model
{
    protected $table = 'classes';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'niveau_id',
        'annee_scolaire_id',
        'nom',
        'capacite_max',
        'salle_id'
    ];
    protected $useTimestamps = true;
}