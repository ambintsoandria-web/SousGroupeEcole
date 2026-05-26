<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class EtudiantModel extends Model
{
    protected $table = 'profils_etudiants';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = ['user_id', 'matricule', 'nom', 'prenom', 'date_naissance', 'lieu_naissance', 'sexe', 'photo_url', 'adresse', 'commune', 'region', 'nationalite', 'cin', 'telephone', 'is_archived'];
    protected $useTimestamps = true;

    public function getInitials($nom, $prenom)
    {
        return strtoupper(substr($nom, 0, 1) . substr($prenom, 0, 1));
    }
    public function getClasseEtudiant($id_etudiant)
    {
        $db = \Config\Database::connect();

        $query = $db->table('inscriptions')
            ->select('classe_id')
            ->where('etudiant_id', '=', $id_etudiant)
            ->orderBy('date_inscription')
            ->limit(1)->get();

        $result = $query->getRow();

        if ($result) {
            return $result->id;
        }

        return null;
    }
}
