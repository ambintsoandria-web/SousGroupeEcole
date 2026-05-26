<?php


namespace App\Models\Etudiant;

error_reporting(E_ALL);
ini_set('display_errors', 1);

use CodeIgniter\Model;

class MatiereModel extends Model
{
    protected $table = 'users';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = ['code_matiere', 'intitule', 'coefficient', 'unite', 'niveau', 'serie', 'created_at'];
    protected $useTimestamps = true;
    public function getNomProf($id_prof)
    {
        $db = \Config\Database::connect();

        $query = $db->table('profils_professeurs')
            ->select('nom')
            ->where('id', $id_prof)
            ->get();

        $result = $query->getRow();

        if ($result) {
            return $result->nom;
        }
        return null;
    }

    public function getPrenomProf($id_prof)
    {
        $db = \Config\Database::connect();

        $query = $db->table('profils_professeurs')
            ->select('prenom')
            ->where('id', $id_prof)
            ->get();

        $result = $query->getRow();

        if ($result) {
            return $result->prenom;
        }
        return null;
    }
    public function getInfoProf($id_prof)
    {
        return $this->getNomProf($id_prof) . ' ' . $this->getPrenomProf($id_prof);
    }
}
