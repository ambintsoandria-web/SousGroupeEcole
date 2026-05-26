<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class SeanceModel extends Model
{
    protected $table = 'seances';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'emploi_du_temps_id',
        'date_seance',
        'jour_semaine',
        'heure_debut',
        'heure_fin',
        'matiere_id',
        'professeur_id',
        'salle_id',
        'annee_scolaire_id',
        'est_annule',
    ];
    protected $useTimestamps = true;

    public function getSeancesByClasse($classe_id, $periode_id = null)
    {
        $builder = $this->select('seances.*, matieres.intitule as matiere_nom, profils_professeurs.nom as prof_nom, profils_professeurs.prenom as prof_prenom, salles.nom as salle_nom')
            ->join('matieres', 'matieres.id = seances.matiere_id')
            ->join('profils_professeurs', 'profils_professeurs.id = seances.professeur_id', 'left')
            ->join('salles', 'salles.id = seances.salle_id', 'left')
            ->join('emploi_du_temps', 'emploi_du_temps.id = seances.emploi_du_temps_id')
            ->where('emploi_du_temps.classe_id', $classe_id)
            ->where('seances.est_annule', FALSE);

        if ($periode_id !== null) {
            $builder->where('emploi_du_temps.periode_id', $periode_id);
        }

        return $builder->orderBy("CASE seances.jour_semaine 
        WHEN 'Lundi' THEN 1 
        WHEN 'Mardi' THEN 2 
        WHEN 'Mercredi' THEN 3 
        WHEN 'Jeudi' THEN 4 
        WHEN 'Vendredi' THEN 5 
        ELSE 6 END")
            ->orderBy('seances.heure_debut')
            ->findAll();
    }

    public function getPlanningOrganise($classe_id, $periode_id = null)
    {
        $seances = $this->getSeancesByClasse($classe_id, $periode_id);
        $planning = [];

        foreach ($seances as $seance) {
            $jour = $seance['jour_semaine'];
            $heure = substr($seance['heure_debut'], 0, 5);

            $planning[$jour][$heure] = [
                'matiere' => $seance['matiere_nom'],
                'professeur' => trim($seance['prof_nom'] . ' ' . $seance['prof_prenom']),
                'salle' => $seance['salle_nom']
            ];
        }

        return $planning;
    }
    public function getCreneauxHoraires()
    {
        $result = $this->select('heure_debut, heure_fin')
            ->groupBy('heure_debut, heure_fin')
            ->orderBy('heure_debut')
            ->findAll();

        $creneaux = [];
        foreach ($result as $row) {
            $debut = substr($row['heure_debut'], 0, 5);
            $fin = substr($row['heure_fin'], 0, 5);
            $creneaux[$debut] = $debut . '–' . $fin;
        }
        return $creneaux;
    }
    public function getJours()
    {
        return ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi'];
    }
}