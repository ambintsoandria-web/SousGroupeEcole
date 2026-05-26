<?php

namespace App\Controllers\Etudiant;

error_reporting(E_ALL);
ini_set('display_errors', 1);

use App\Controllers\BaseController;
use App\Models\Etudiant\EtudiantModel;
use App\Models\Etudiant\RolesModel;
use App\Models\Etudiant\UsersModel;
use App\Models\Etudiant\NotesModel;
use App\Models\Etudiant\MatiereModel;
use App\Models\Etudiant\PeriodesModel;

class NotesController extends BaseController
{
    public $userModel;
    public $roleModel;
    public $etudiantModel;
    public $notesModel;
    public $matiereModel;
    public $periodeModel;

    public function __construct()
    {
        $this->userModel = new UsersModel();
        $this->roleModel = new RolesModel();
        $this->etudiantModel = new EtudiantModel();
        $this->notesModel = new NotesModel();
        $this->matiereModel = new MatiereModel();
        $this->periodeModel = new PeriodesModel();
    }

    public function go_to_notes()
    {
        $id_etudiant = session()->get('id');

        $annee_scolaire_id = $this->request->getGet('annee_id');
        $periode_id = $this->request->getGet('periode_id');

        if (empty($annee_scolaire_id)) {
            $anneeActive = $this->periodeModel->getAnneeActive();
            $annee_scolaire_id = $anneeActive ? $anneeActive['id'] : null;
        }

        if (empty($periode_id) && !empty($annee_scolaire_id)) {
            $periodeActuelle = $this->periodeModel->getPeriodeActuelle($annee_scolaire_id);
            $periode_id = $periodeActuelle ? $periodeActuelle['id'] : null;
        }

        if (empty($periode_id) && !empty($annee_scolaire_id)) {
            $dernierePeriode = $this->periodeModel->getDernierePeriode($annee_scolaire_id);
            $periode_id = $dernierePeriode ? $dernierePeriode['id'] : null;
        }

        $liste_notes = $this->notesModel->getNotesEtudiant($id_etudiant, $annee_scolaire_id, $periode_id);

        $data['liste_notes'] = $liste_notes;
        $data['liste_periode'] = $this->periodeModel->getPeriodesAnnee($annee_scolaire_id);
        $data['liste_annees'] = $this->periodeModel->getAnneesScolaires();
        $data['annee_selectionnee'] = $annee_scolaire_id;
        $data['periode_selectionnee'] = $periode_id;
        $data['moyenne'] = $this->notesModel->calculerMoyenne($id_etudiant, $annee_scolaire_id, $periode_id);
        $data['classe'] = $this->notesModel->getClasseEtudiant($id_etudiant);

        for ($i = 0; $i < count($data['liste_notes']); $i++) {
            $data['liste_notes'][$i]['nom_prof'] = $this->matiereModel->getInfoProf($data['liste_notes'][$i]['professeur_id']);
            $data['liste_notes'][$i]['grade'] = $this->notesModel->getGrade($data['liste_notes'][$i]['valeur']);
            $data['liste_notes'][$i]['apreciation'] = $this->notesModel->getApreciation($data['liste_notes'][$i]['valeur']);
        }

        return view('etudiant/note', $data);
    }
}