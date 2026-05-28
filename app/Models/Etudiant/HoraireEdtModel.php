<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class HoraireEdtModel extends Model
{
    protected $table = 'horaire_edt';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'libelle',
        'heure_debut',
        'heure_fin',
        'ordre',
        'is_active'
    ];
    protected $useTimestamps = true;
}