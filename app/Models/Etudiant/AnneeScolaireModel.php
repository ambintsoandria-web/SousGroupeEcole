<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class AnneeScolaireModel extends Model
{
    protected $table = 'annees_scolaires';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'etablissement_id',
        'libelle',
        'date_debut',
        'date_fin',
        'est_active'
    ];
    protected $useTimestamps = true;

    public function getActive()
    {
        return $this->where('est_active', true)->first();
    }

    public function getAllDesc()
    {
        return $this->orderBy('id', 'DESC')->findAll();
    }
}