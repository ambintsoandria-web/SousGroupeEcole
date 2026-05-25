<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class EmploiduTempsModel extends Model
{
    protected $table = 'emploi_du_temps';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'jour_semaine',
        'heure_debut',
        'heure_fin',
        'date',
        'annee_scolaire',
        'classe_id',
        'matiere_id',
        'professeur_id',
        'salle_id',
        'created_at',
    ];
    protected $useTimestamps = true;
}
