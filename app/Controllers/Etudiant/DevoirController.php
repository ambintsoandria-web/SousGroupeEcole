<?php

namespace App\Controllers\Etudiant;

use App\Controllers\BaseController;
use App\Models\Etudiant\DevoirModel;
use App\Models\Etudiant\InscriptionModel;
use App\Models\Etudiant\PeriodesModel;

class DevoirController extends BaseController
{
    public $devoirModel;
    public $inscriptionModel;
    public $periodeModel;

    public function __construct()
    {
        $this->devoirModel = new DevoirModel();
        $this->inscriptionModel = new InscriptionModel();
        $this->periodeModel = new PeriodesModel();
    }

    public function index()
    {
        $id_etudiant = session()->get('id');

        if (!$id_etudiant) {
            return redirect()->to('/etudiant/login')->with('error', 'Veuillez vous connecter');
        }

        $periode_id = $this->request->getGet('periode_id');
        $annee_scolaire_id = $this->request->getGet('annee_id');

        // Récupérer l'année scolaire active si non spécifiée
        if (empty($annee_scolaire_id)) {
            $anneeActive = $this->periodeModel->getAnneeActive();
            $annee_scolaire_id = $anneeActive ? $anneeActive['id'] : null;
        }

        // Récupérer la période
        if (empty($periode_id) && !empty($annee_scolaire_id)) {
            $periodeActuelle = $this->periodeModel->getPeriodeActuelle($annee_scolaire_id);
            $periode_id = $periodeActuelle ? $periodeActuelle['id'] : null;
        }

        if (empty($periode_id) && !empty($annee_scolaire_id)) {
            $dernierePeriode = $this->periodeModel->getDernierePeriode($annee_scolaire_id);
            $periode_id = $dernierePeriode ? $dernierePeriode['id'] : null;
        }

        // Récupérer les devoirs
        $devoirs = $this->devoirModel->getDevoirsEtudiant($id_etudiant);

        // Récupérer la classe de l'élève
        $classe = $this->inscriptionModel->getClasseEtudiant($id_etudiant);

        $data = [
            'devoirs' => $devoirs,
            'classe' => $classe,
            'periode' => $this->periodeModel->find($periode_id),
            'annee' => $this->periodeModel->getAnneeActive(),
            'liste_periodes' => $this->periodeModel->getPeriodesAnnee($annee_scolaire_id),
            'liste_annees' => $this->periodeModel->getAnneesScolaires(),
            'periode_selectionnee' => $periode_id,
            'annee_selectionnee' => $annee_scolaire_id,
        ];

        return view('etudiant/devoir', $data);
    }
}