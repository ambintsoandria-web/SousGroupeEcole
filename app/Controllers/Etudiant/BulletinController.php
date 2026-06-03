<?php

namespace App\Controllers\Etudiant;

use App\Controllers\BaseController;
use App\Models\Etudiant\NotesModel;
use App\Models\Etudiant\PeriodesModel;
use App\Models\Etudiant\EtudiantModel;

class BulletinController extends BaseController
{
    public $notesModel;
    public $periodeModel;
    public $etudiantModel;

    public function __construct()
    {
        $this->notesModel = new NotesModel();
        $this->periodeModel = new PeriodesModel();
        $this->etudiantModel = new EtudiantModel();
    }

    public function index()
    {
        $id_etudiant = session()->get('id');

        if (!$id_etudiant) {
            return redirect()->to('/etudiant/login')->with('error', 'Veuillez vous connecter');
        }

        $annee_scolaire_id = $this->request->getGet('annee_id');
        $periode_id = $this->request->getGet('periode_id');

        // Récupérer l'année scolaire active si non spécifiée
        if (empty($annee_scolaire_id)) {
            $anneeActive = $this->periodeModel->getAnneeActive();
            $annee_scolaire_id = $anneeActive ? $anneeActive['id'] : null;
        }

        // Récupérer la période (actuelle, puis dernière disponible)
        if (empty($periode_id) && !empty($annee_scolaire_id)) {
            $periodeActuelle = $this->periodeModel->getPeriodeActuelle($annee_scolaire_id);
            $periode_id = $periodeActuelle ? $periodeActuelle['id'] : null;
        }

        if (empty($periode_id) && !empty($annee_scolaire_id)) {
            $dernierePeriode = $this->periodeModel->getDernierePeriode($annee_scolaire_id);
            $periode_id = $dernierePeriode ? $dernierePeriode['id'] : null;
        }

        // Récupérer les notes de l'élève
        $liste_notes = $this->notesModel->getNotesEtudiant($id_etudiant, $annee_scolaire_id, $periode_id);

        // Calculer la moyenne
        $moyenne = $this->notesModel->calculerMoyenne($id_etudiant, $annee_scolaire_id, $periode_id);

        // Récupérer le classement
        $rang = $moyenne ? $this->notesModel->getClassementEleve($moyenne, $annee_scolaire_id, $periode_id) : null;

        // Récupérer la classe de l'élève
        $classe = $this->notesModel->getClasseEtudiant($id_etudiant);

        // Compter le nombre total d'élèves dans la classe
        $totalEleves = 0;
        if (!empty($classe)) {
            $db = \Config\Database::connect();
            $totalEleves = (int) $db->table('inscriptions')
                ->where('classe_id', $classe['id'])
                ->where('statut', 'active')
                ->countAllResults();
        }

        // Préparer les données pour la vue
        $data = [
            'matieres' => [],
            'moyenneGenerale' => $moyenne ? round($moyenne, 2) : 0,
            'rang' => $rang,
            'totalEleves' => $totalEleves,
            'classe' => $classe,
            'periode' => $this->periodeModel->find($periode_id),
            'annee' => $this->periodeModel->getAnneeActive(),
            'liste_periodes' => $this->periodeModel->getPeriodesAnnee($annee_scolaire_id),
            'liste_annees' => $this->periodeModel->getAnneesScolaires(),
            'periode_selectionnee' => $periode_id,
            'annee_selectionnee' => $annee_scolaire_id,
        ];

        // Formater les notes pour l'affichage
        foreach ($liste_notes as $note) {
            $data['matieres'][] = [
                'nom' => $note['intitule'] ?? $note['libelle'] ?? 'Matière',
                'note' => $note['valeur'],
                'coefficient' => $note['coefficient'] ?? 1,
                'appreciation' => $this->notesModel->getApreciation($note['valeur']),
                'grade' => $this->notesModel->getGrade($note['valeur'])
            ];
        }

        return view('etudiant/bulletin', $data);
    }
}