<?php

namespace App\Controllers\Etudiant;

error_reporting(E_ALL);
ini_set('display_errors', 1);

use App\Controllers\BaseController;
use App\Models\Etudiant\NoteModel;
use App\Models\Etudiant\PeriodeModel;
use App\Models\Etudiant\AnneeScolaireModel;
use App\Models\Etudiant\InscriptionModel;


class NotesController extends BaseController
{
    public function go_to_notes()
    {
        $etudiant_id = session()->get('id');
        if (!$etudiant_id) {
            return redirect()->to('/etudiant/login');
        }

        $annee_id = $this->request->getGet('annee_id');
        $periode_id = $this->request->getGet('periode_id');

        $noteModel = new NoteModel();
        $periodeModel = new PeriodeModel();
        $anneeModel = new AnneeScolaireModel();

        $liste_annees = $anneeModel->orderBy('id', 'DESC')->findAll();

        if (!$annee_id && !empty($liste_annees)) {
            $annee_id = $liste_annees[0]['id'];
        }

        $liste_periodes = $periodeModel->where('annee_scolaire_id', $annee_id)->orderBy('ordre')->findAll();

        if (!$periode_id && !empty($liste_periodes)) {
            $periode_id = $liste_periodes[0]['id'];
        }

        $notes = $noteModel->getListNotesEleveFiltered($etudiant_id, $annee_id, $periode_id);

        $moyenne_eleve = $noteModel->calculerMoyenne($etudiant_id, $annee_id, $periode_id);

        $classement = $noteModel->getClassementEleve($moyenne_eleve, $annee_id, $periode_id);

        foreach ($notes as &$n) {
            $n['grade'] = $noteModel->getGrade($n['valeur']);
            $n['apreciation'] = $noteModel->getApreciation($n['valeur']);
        }

        $data = [
            'liste_notes' => $notes,
            'liste_annees' => $liste_annees,
            'liste_periodes' => $liste_periodes,
            'annee_selectionnee' => $annee_id,
            'periode_selectionnee' => $periode_id,
            'moyenne_generale' => $moyenne_eleve ? number_format($moyenne_eleve, 2) : '--',
            'rang' => $classement,
            'progression' => '--'
        ];

        return view('etudiant/note', $data);
    }
    public function go_to_bulletin()
    {
        $etudiant_id = session()->get('id');
        if (!$etudiant_id) {
            return redirect()->to('/etudiant/login');
        }

        $annee_id = $this->request->getGet('annee_id');
        $periode_id = $this->request->getGet('periode_id');

        $noteModel = new NoteModel();
        $periodeModel = new PeriodeModel();
        $anneeModel = new AnneeScolaireModel();
        $inscriptionModel = new InscriptionModel();

        $classe_id = $inscriptionModel->getClasseId($etudiant_id);
        $classe_nom = $inscriptionModel->getNomClasse($classe_id);

        $db = \Config\Database::connect();
        $etudiant = $db->table('profils_etudiants')->select('nom, prenom')->where('user_id', $etudiant_id)->get()->getRowArray();

        $liste_annees = $anneeModel->orderBy('id', 'DESC')->findAll();

        if (!$annee_id && !empty($liste_annees)) {
            $annee_id = $liste_annees[0]['id'];
        }

        $liste_periodes = $periodeModel->where('annee_scolaire_id', $annee_id)->orderBy('ordre')->findAll();

        if (!$periode_id && !empty($liste_periodes)) {
            $periode_id = $liste_periodes[0]['id'];
        }

        $periode = $periodeModel->find($periode_id);
        $annee = $anneeModel->find($annee_id);

        // DIFFÉRENCE 1: Récupérer TOUTES les matières (même sans notes)
        $matieres = $noteModel->getAffectationsWithCoeffs($classe_id, $annee_id);
        $notes_etudiant = $noteModel->getNotesByEtudiantPeriode($etudiant_id, $periode_id);

        $notes_map = [];
        foreach ($notes_etudiant as $note) {
            $notes_map[$note['affectation_id']] = $note['valeur'];
        }

        $liste_notes = [];
        $total_notes = 0;
        $total_coeff = 0;

        foreach ($matieres as $m) {
            $valeur = $notes_map[$m['id']] ?? 0;  // DIFFÉRENCE 2: 0 si pas de note
            $coeff = $m['coefficient'] ?? 1;

            $liste_notes[] = [
                'matiere_nom' => $m['matiere_nom'],
                'valeur' => $valeur,
                'coefficient' => $coeff,
                'grade_class' => $noteModel->getGrade($valeur),
                'apreciation' => $noteModel->getApreciation($valeur)
            ];

            $total_notes += $valeur * $coeff;
            $total_coeff += $coeff;
        }

        $moyenne_eleve = $total_coeff > 0 ? $total_notes / $total_coeff : null;
        $classement = $noteModel->getClassementEleve($moyenne_eleve, $annee_id, $periode_id);

        foreach ($liste_notes as &$n) {
            $n['grade'] = $noteModel->getGrade($n['valeur']);
            $n['apreciation'] = $noteModel->getApreciation($n['valeur']);
        }

        $data = [
            'liste_notes' => $liste_notes,
            'liste_annees' => $liste_annees,
            'liste_periodes' => $liste_periodes,
            'annee_selectionnee' => $annee_id,
            'periode_selectionnee' => $periode_id,
            'periode_libelle' => $periode['libelle'] ?? '',
            'annee_libelle' => $annee['libelle'] ?? '',
            'classe_nom' => $classe_nom,
            'etudiant_nom' => $etudiant['prenom'] . ' ' . $etudiant['nom'],
            'moyenne_generale' => $moyenne_eleve ? number_format($moyenne_eleve, 2) : '--',
            'rang' => $classement,
            'progression' => '--',
            'periode_terminee' => $noteModel->isPeriodeTerminee($periode_id),
            'message_periode' => $noteModel->getMessagePeriodeTerminee($periode_id),
            'appreciation' => $noteModel->getAppreciationGenerale($moyenne_eleve)
        ];

        return view('etudiant/bulletin', $data);
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