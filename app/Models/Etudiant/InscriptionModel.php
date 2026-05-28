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

    public function getClasseId($etudiant_id)
    {
        $row = $this->where('etudiant_id', $etudiant_id)
            ->where('statut', 'active')
            ->first();
        return $row ? $row['classe_id'] : null;
    }

    public function getAnneeScolaireId($etudiant_id)
    {
        $row = $this->where('etudiant_id', $etudiant_id)
            ->where('statut', 'active')
            ->first();
        return $row ? $row['annee_scolaire_id'] : null;
    }
    public function getNomClasse($classe_id)
    {
        $db = \Config\Database::connect();
        $result = $db->table('classes c')
            ->select('c.nom, n.libelle')
            ->join('niveaux n', 'n.id = c.niveau_id')
            ->where('c.id', $classe_id)
            ->get()
            ->getRowArray();

        return $result ? $result['libelle'] . ' ' . $result['nom'] : '';
    }
}