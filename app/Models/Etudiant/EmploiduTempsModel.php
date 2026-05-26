<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class EmploiduTempsModel extends Model
{
    protected $table = 'emploi_du_temps';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'classe_id',
        'annee_scolaire_id',
        'date_debut',
        'date_fin',
        'created_at',
    ];
    protected $useTimestamps = true;
}
