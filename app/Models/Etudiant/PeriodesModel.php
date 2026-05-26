<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class PeriodesModel extends Model
{
    protected $table = 'periodes';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'libelle',
        'type_periode',
        'date_debut',
        'date_fin',
        'annee_scolaire',
        'created_at',
    ];
    protected $useTimestamps = true;
    // SELECT * FROM periodes WHERE annee_scolaire_id = 1 GROUP BY id;
    public function getPeriodesAnnee($annee_scolaire_id)
    {
        return $this->where('annee_scolaire_id', $annee_scolaire_id)
            ->groupBy('id')
            ->findAll();
    }
    public function getAnneesScolaires()
    {
        $db = \Config\Database::connect();
        return $db->query("SELECT id, libelle FROM annees_scolaires ORDER BY id DESC")->getResultArray();
    }
    public function getAnneeActive()
    {
        return $this->db->table('annees_scolaires')
            ->where('est_active', TRUE)
            ->get()
            ->getRowArray();
    }

    public function getPeriodeActuelle($annee_scolaire_id)
    {
        return $this->db->table('periodes')
            ->where('annee_scolaire_id', $annee_scolaire_id)
            ->where('date_debut <=', date('Y-m-d'))
            ->where('date_fin >=', date('Y-m-d'))
            ->get()
            ->getRowArray();
    }

    public function getDernierePeriode($annee_scolaire_id)
    {
        return $this->db->table('periodes')
            ->where('annee_scolaire_id', $annee_scolaire_id)
            ->orderBy('id', 'DESC')
            ->limit(1)
            ->get()
            ->getRowArray();
    }
}
