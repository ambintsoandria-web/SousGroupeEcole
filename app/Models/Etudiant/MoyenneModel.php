<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class MoyenneModel extends Model
{
    protected $table = 'moyennes';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'etudiant_id',
        'inscription_id',
        'periode_id',
        'matiere_id',
        'valeur',
        'rang',
        'effectif_classe'
    ];
    protected $useTimestamps = false;
    protected $createdField = 'calculated_at';
}