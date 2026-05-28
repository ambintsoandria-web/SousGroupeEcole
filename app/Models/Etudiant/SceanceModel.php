<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class SeanceModel extends Model
{
    protected $table = 'seances';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'emploi_du_temps_id',
        'date_seance',
        'heure_debut',
        'heure_fin',
        'a_eu_lieu'
    ];
    protected $useTimestamps = true;
}