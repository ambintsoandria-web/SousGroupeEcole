<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class InscriptionModel extends Model
{
    protected $table = 'inscriptions';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'etudiant_id',
        'classe_id',
        'annee_scolaire_id',
        'type_inscription',
        'date_inscription',
        'statut',
        'rang_final',
        'est_admis'
    ];
    protected $useTimestamps = true;

    public function getClasseEtudiant($id_etudiant)
    {
        return $this->select('classes.id, classes.nom, niveaux.libelle as niveau_libelle')
            ->join('classes', 'classes.id = inscriptions.classe_id')
            ->join('niveaux', 'niveaux.id = classes.niveau_id')
            ->where('inscriptions.etudiant_id', $id_etudiant)
            ->where('inscriptions.statut', 'active')
            ->orderBy('inscriptions.created_at', 'DESC')
            ->first();
    }
}