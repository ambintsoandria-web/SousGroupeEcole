<?php

namespace App\Controllers\Etudiant;

error_reporting(E_ALL);
ini_set('display_errors', 1);


use App\Controllers\BaseController;
use App\Models\Etudiant\EmploiDuTempsModel;
use App\Models\Etudiant\PeriodeModel;
use App\Models\Etudiant\AnneeScolaireModel;

class CalendarController extends BaseController
{
    public function index()
    {
        $etudiant_id = session()->get('id');
        if (!$etudiant_id) {
            return redirect()->to('/etudiant/login');
        }

        $annee_id = $this->request->getGet('annee_id');
        $periode_id = $this->request->getGet('periode_id');

        $edt = new EmploiDuTempsModel();
        $periodeModel = new PeriodeModel();
        $anneeModel = new AnneeScolaireModel();

        $annees = $anneeModel->getAllDesc();

        if (!$annee_id) {
            $active = $anneeModel->getActive();
            $annee_id = $active ? $active['id'] : null;
        }

        $periodes = $periodeModel->getByAnnee($annee_id);

        if (!$periode_id) {
            $actuelle = $periodeModel->getPeriodeActuelle($annee_id);
            $periode_id = $actuelle ? $actuelle['id'] : null;
        }

        $data = [
            'pageTitle' => 'Mon Emploi du Temps',
            'activePage' => 'etu-emploi',
            'activeRole' => 'etudiant',
            'planning' => $edt->getPlanning($etudiant_id, $annee_id, $periode_id),
            'creneaux' => $edt->getCreneaux(),
            'jours' => $edt->getJours(),
            'nom_classe' => $edt->getNomClasse($etudiant_id),
            'annees' => $annees,
            'periodes' => $periodes,
            'annee_selectionnee' => $annee_id,
            'periode_selectionnee' => $periode_id,
            'semaine' => $edt->getSemaine()
        ];

        return view('etudiant/calendar', $data);
    }
}