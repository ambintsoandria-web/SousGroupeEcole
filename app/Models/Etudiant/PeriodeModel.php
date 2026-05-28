<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class PeriodeModel extends Model
{
    protected $table = 'periodes';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'annee_scolaire_id',
        'libelle',
        'type',
        'ordre',
        'date_debut',
        'date_fin',
        'date_publication_notes',
        'est_cloturee'
    ];

    public function getByAnnee($annee_id)
    {
        return $this->where('annee_scolaire_id', $annee_id)->orderBy('ordre')->findAll();
    }

    public function getPeriodeActuelle($annee_id)
    {
        return $this->where('annee_scolaire_id', $annee_id)
            ->where('date_debut <=', date('Y-m-d'))
            ->where('date_fin >=', date('Y-m-d'))
            ->first();
    }
}