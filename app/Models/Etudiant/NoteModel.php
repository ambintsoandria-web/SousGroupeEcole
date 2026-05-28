<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class NoteModel extends Model
{
    protected $table = 'notes';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'etudiant_id',
        'affectation_id',
        'periode_id',
        'type_evaluation',
        'valeur',
        'sur',
        'commentaire',
        'saisi_par',
        'date_saisie',
        'est_valide',
        'ancienne_valeur',
        'corrige_par',
        'date_correction',
        'motif_correction'
    ];
    protected $useTimestamps = true;
    public function getAffectationsWithCoeffs($classe_id, $annee_id)
    {
        $db = \Config\Database::connect();
        return $db->table('affectations_enseignement ae')
            ->select('ae.id, ae.matiere_id, m.nom as matiere_nom, c.valeur as coefficient, p.nom as prof_nom, p.prenom as prof_prenom')
            ->join('matieres m', 'm.id = ae.matiere_id')
            ->join('coefficients c', 'c.matiere_id = m.id AND c.niveau_id = (SELECT niveau_id FROM classes WHERE id = ae.classe_id)', 'left')
            ->join('profils_professeurs p', 'p.id = ae.professeur_id', 'left')
            ->where('ae.classe_id', $classe_id)
            ->where('ae.annee_scolaire_id', $annee_id)
            ->get()
            ->getResultArray();
    }

    public function getNotesByEtudiantPeriode($etudiant_id, $periode_id)
    {
        return $this->where('etudiant_id', $etudiant_id)
            ->where('periode_id', $periode_id)
            ->findAll();
    }

    public function isPeriodeTerminee($periode_id)
    {
        $periode = new PeriodeModel();
        $periode_data = $periode->find($periode_id);

        if (!$periode_data)
            return true;

        return $periode_data['date_fin'] < date('Y-m-d');
    }

    public function getMessagePeriodeTerminee($periode_id)
    {
        $periode = new PeriodeModel();
        $periode_data = $periode->find($periode_id);

        if (!$periode_data)
            return '';

        return "⚠️ La période « {$periode_data['libelle']} » est terminée depuis le " . date('d/m/Y', strtotime($periode_data['date_fin'])) . ". Aucun bulletin n'est disponible.";
    }
    public function getListNotesEleveFiltered($id_eleve, $id_annee, $id_periode)
    {
        return $this->select('notes.*, matieres.nom as matiere_nom, matieres.id as matiere_id, profils_professeurs.nom as prof_nom, profils_professeurs.prenom as prof_prenom, coefficients.valeur as coefficient')
            ->join('affectations_enseignement', 'affectations_enseignement.id = notes.affectation_id')
            ->join('matieres', 'matieres.id = affectations_enseignement.matiere_id')
            ->join('profils_professeurs', 'profils_professeurs.id = affectations_enseignement.professeur_id')
            ->join('coefficients', 'coefficients.matiere_id = matieres.id AND coefficients.niveau_id = (SELECT niveau_id FROM classes WHERE id = affectations_enseignement.classe_id)', 'left')
            ->where('notes.etudiant_id', $id_eleve)
            ->where('affectations_enseignement.annee_scolaire_id', $id_annee)
            ->where('notes.periode_id', $id_periode)
            ->findAll();
    }

    public function getNotesEtudiant($id_etudiant, $annee_scolaire_id, $periode_id)
    {
        return $this->select('notes.*, matieres.nom as intitule, coefficients.valeur as coefficient')
            ->join('affectations_enseignement', 'affectations_enseignement.id = notes.affectation_id')
            ->join('matieres', 'matieres.id = affectations_enseignement.matiere_id')
            ->join('coefficients', 'coefficients.matiere_id = matieres.id AND coefficients.niveau_id = (SELECT niveau_id FROM classes WHERE id = affectations_enseignement.classe_id)', 'left')
            ->where('notes.etudiant_id', $id_etudiant)
            ->where('affectations_enseignement.annee_scolaire_id', $annee_scolaire_id)
            ->where('notes.periode_id', $periode_id)
            ->findAll();
    }

    public function getMoyennes($annee_scolaire_id, $periode_id)
    {
        $etudiant = new \App\Models\Etudiant\EtudiantModel();
        $liste_etudiants = $etudiant->findAll();
        $liste_moyenne = [];
        foreach ($liste_etudiants as $key => $etud) {
            $liste_moyenne[$key] = $this->calculerMoyenne($etud['id'], $annee_scolaire_id, $periode_id);
        }
        return $liste_moyenne;
    }

    public function getClassementEleve($moyenne, $annee_scolaire_id, $periode_id)
    {
        if ($moyenne === null)
            return '--';

        $liste_moyennes = $this->getMoyennes($annee_scolaire_id, $periode_id);
        $liste_moyennes = array_filter($liste_moyennes); // enlever les null
        rsort($liste_moyennes); // tri décroissant

        $classement = array_search($moyenne, $liste_moyennes);
        return $classement !== false ? $classement + 1 : '--';
    }

    public function calculerMoyenne($id_etudiant, $annee_scolaire_id, $periode_id)
    {
        $liste_notes = $this->getNotesEtudiant($id_etudiant, $annee_scolaire_id, $periode_id);

        if (empty($liste_notes)) {
            return null;
        }

        $somme = 0;
        $somme_coeff = 0;

        foreach ($liste_notes as $note) {
            $somme += $note['valeur'] * $note['coefficient'];
            $somme_coeff += $note['coefficient'];
        }

        return $somme_coeff > 0 ? $somme / $somme_coeff : null;
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
    public function getAppreciationGenerale($moyenne)
    {
        if ($moyenne === '--' || $moyenne === null) {
            return 'Aucune note disponible';
        }
        if ($moyenne >= 16) {
            return 'Excellent élève, félicitations !';
        }
        if ($moyenne >= 14) {
            return 'Très bon travail, continuez ainsi !';
        }
        if ($moyenne >= 12) {
            return 'Bon travail, quelques efforts restent à faire.';
        }
        if ($moyenne >= 10) {
            return 'Travail satisfaisant, peut mieux faire.';
        }
        return 'Des efforts sont nécessaires pour progresser.';
    }
}