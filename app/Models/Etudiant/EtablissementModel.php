<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class EtablissementModel extends Model
{
    protected $table = 'profils_etudiants';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'user_id',
        'matricule',
        'nom',
        'prenom',
        'date_naissance',
        'lieu_naissance',
        'sexe',
        'photo_url',
        'adresse',
        'commune',
        'region',
        'nationalite',
        'cin',
        'telephone',
        'is_archived',
        'created_at',
        'updated_at',
    ];
    protected $useTimestamps = true;
}
