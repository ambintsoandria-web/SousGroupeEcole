<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class NotesModel extends Model
{
    protected $table = 'notes';
    protected $primaryKey = 'id_note';
    protected $returnType = 'array';
    protected $allowedFields = [
        'valeur',
        'type_evaluation',
        'date_evaluation',
        'observation',
        'etudiant_id',
        'matiere_id',
        'professeur_id',
        'periode_id',
        'created_at',
    ];
    protected $useTimestamps = true;
}
