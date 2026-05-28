<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class AffectationModel extends Model
{
    protected $table = 'affectations_enseignement';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'professeur_id',
        'matiere_id',
        'classe_id',
        'annee_scolaire_id',
        'heures_hebdo'
    ];
    protected $useTimestamps = true;

    public function getByClasseAnnee($classe_id, $annee_id)
    {
        return $this->where('classe_id', $classe_id)
            ->where('annee_scolaire_id', $annee_id)
            ->findAll();
    }

    public function getMatiereNom($matiere_id)
    {
        $model = new MatiereModel();
        $row = $model->find($matiere_id);
        return $row ? $row['nom'] : '';
    }

    public function getProfNom($professeur_id)
    {
        $model = new ProfesseurModel();
        $row = $model->find($professeur_id);
        return $row ? $row['prenom'] . ' ' . $row['nom'] : '';
    }
}