<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class EmploiDuTempsModel extends Model
{
    protected $table = 'emploi_du_temps';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'affectation_id',
        'salle_id',
        'jour_semaine',
        'heure_debut',
        'heure_fin',
        'date_debut_validite',
        'date_fin_validite',
        'horaire_edt_id'
    ];
    protected $useTimestamps = true;

    public function getByAffectation($affectation_id)
    {
        return $this->where('affectation_id', $affectation_id)->findAll();
    }

    public function getPlanning($etudiant_id, $annee_id, $periode_id)
    {
        $inscriptionModel = new InscriptionModel();
        $classe_id = $inscriptionModel->getClasseId($etudiant_id);

        if (!$classe_id)
            return [];

        $affectationModel = new AffectationModel();
        $affectations = $affectationModel->getByClasseAnnee($classe_id, $annee_id);

        $planning = [];
        $jours = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi'];

        foreach ($affectations as $a) {
            $cours = $this->where('affectation_id', $a['id'])->findAll();

            $matiere = $affectationModel->getMatiereNom($a['matiere_id']);
            $prof = $affectationModel->getProfNom($a['professeur_id']);

            foreach ($cours as $c) {
                $jour = $jours[$c['jour_semaine'] - 1];
                $heure = substr($c['heure_debut'], 0, 5);
                $planning[$jour][$heure] = [
                    'matiere' => $matiere,
                    'professeur' => $prof
                ];
            }
        }

        return $planning;
    }
    public function getCreneaux()
    {
        $model = new HoraireEdtModel();
        $rows = $model->orderBy('ordre')->findAll();

        $creneaux = [];
        foreach ($rows as $row) {
            $heure = substr($row['heure_debut'], 0, 5);
            $creneaux[$heure] = $row['libelle'];
        }
        return $creneaux;
    }

    public function getJours()
    {
        return ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi'];
    }

    public function getNomClasse($etudiant_id)
    {
        $db = \Config\Database::connect();
        $result = $db->table('inscriptions i')
            ->select('c.nom, n.libelle')
            ->join('classes c', 'c.id = i.classe_id')
            ->join('niveaux n', 'n.id = c.niveau_id')
            ->where('i.etudiant_id', $etudiant_id)
            ->where('i.statut', 'active')
            ->get()
            ->getRowArray();

        return $result ? $result['libelle'] . ' ' . $result['nom'] : '';
    }

    public function getSemaine()
    {
        $lundi = date('d/m', strtotime('monday this week'));
        $vendredi = date('d/m', strtotime('friday this week'));
        return "Semaine du {$lundi} au {$vendredi}";
    }
}