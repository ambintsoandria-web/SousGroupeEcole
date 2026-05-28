<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class ProfesseurModel extends Model
{
    protected $table = 'profils_professeurs';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'user_id',
        'matricule',
        'nom',
        'prenom',
        'date_naissance',
        'sexe',
        'photo_url',
        'telephone',
        'adresse',
        'specialite',
        'type_contrat',
        'date_debut_contrat',
        'date_fin_contrat',
        'is_archived'
    ];
    protected $useTimestamps = true;
}