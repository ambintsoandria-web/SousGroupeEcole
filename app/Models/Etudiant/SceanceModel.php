<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class SceanceModel extends Model
{
    protected $table = 'seances';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'date_seance',
        'jour_semaine',
        'heure_debut',
        'heure_fin',
        'classe_id',
        'matiere_id',
        'professeur_id',
        'salle_id',
        'annee_scolaire_id',
        'est_annule',
        'created_at',
    ];
    protected $useTimestamps = true;
}
