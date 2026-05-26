<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class NotesModel extends Model
{
    protected $table = 'notes';
    protected $primaryKey = 'id_note';
    protected $returnType = 'array';
    protected $allowedFields = [
        'valeur',
        'type_evaluation',
        'date_evaluation',
        'observation',
        'etudiant_id',
        'matiere_id',
        'professeur_id',
        'periode_id',
        'created_at',
    ];
    protected $useTimestamps = true;

    public function getMoyennes($annee_scolaire_id, $periode_id)
    {
        $etudiant = new EtudiantModel();
        $liste_etudiants = $etudiant->findAll();
        $liste_moyenne = [];
        for ($i = 0; $i < count($liste_etudiants); $i++) {
            $liste_moyenne[$i] = $this->calculerMoyenne($liste_etudiants[$i]['id'], $annee_scolaire_id, $periode_id);
        }
        return $liste_moyenne;
    }
    public function calculerMoyenne($id_etudiant, $annee_scolaire_id, $periode_id)
    {
        $liste_notes = $this->getNotesEtudiant($id_etudiant, $annee_scolaire_id, $periode_id);

        if (empty($liste_notes)) {
            return null;
        }

        $somme = 0;
        $somme_coeff = 0;

        foreach ($liste_notes as $notes) {
            $somme += $notes['valeur'] * $notes['coefficient'];
            $somme_coeff += $notes['coefficient'];
        }

        return $somme / $somme_coeff;
    }
    public function getClasseEtudiant($id_etudiant)
    {
        return $this->db->table('inscriptions')
            ->select('classes.id, classes.nom, niveaux.libelle as niveau_libelle, inscriptions.annee_scolaire_id')
            ->join('classes', 'classes.id = inscriptions.classe_id')
            ->join('niveaux', 'niveaux.id = classes.niveau_id')
            ->where('inscriptions.etudiant_id', $id_etudiant)
            ->where('inscriptions.statut', 'active')
            ->orderBy('inscriptions.created_at', 'DESC')
            ->get()
            ->getRowArray();
    }
    public function getNotesEtudiant($id_etudiant, $annee_scolaire_id, $periode_id)
    {
        return $this->select('*')
            ->join('periodes', 'notes.periode_id = periodes.id')
            ->join('annees_scolaires', 'periodes.annee_scolaire_id = annees_scolaires.id')
            ->join('matieres', 'notes.matiere_id = matieres.id')
            ->where('notes.etudiant_id', $id_etudiant)
            ->where('annees_scolaires.id', $annee_scolaire_id)
            ->where('periodes.id', $periode_id)
            ->findAll();
    }
    public function getGrade($note)
    {
        if ($note >= 16)
            return 'grade-excellent';
        if ($note >= 14)
            return 'grade-very-good';
        if ($note >= 12)
            return 'grade-good';
        if ($note >= 10)
            return 'grade-average';
        if ($note >= 6)
            return 'grade-bad';
        return 'grade-verybad';
    }

    public function getApreciation($note)
    {
        if ($note >= 16)
            return 'Très bien ⭐';
        if ($note >= 14)
            return 'Bien';
        if ($note >= 12)
            return 'Assez bien ';
        if ($note >= 10)
            return 'Passable';
        if ($note >= 6)
            return 'Insuffisant ⚠️';
        return 'Très insuffisant ❌';
    }
}