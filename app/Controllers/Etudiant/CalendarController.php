<?php

namespace App\Controllers\Etudiant;

use App\Controllers\BaseController;
use App\Models\Etudiant\SeanceModel;
use App\Models\Etudiant\InscriptionModel;

class CalendarController extends BaseController
{
    public function index()
    {
        $seanceModel = new SeanceModel();
        $inscriptionModel = new InscriptionModel();

        $etudiant_id = session()->get('id');

        if (!$etudiant_id) {
            return redirect()->to('/etudiant/login')->with('error', 'Veuillez vous connecter');
        }

        $classeInfo = $inscriptionModel->getClasseEtudiant($etudiant_id);

        if (!$classeInfo) {
            return redirect()->to('/')->with('error', 'Aucune inscription active trouvée');
        }

        $classe_id = $classeInfo['id'];
        $nom_classe = $classeInfo['nom'] . ' - ' . $classeInfo['niveau_libelle'];

        $jours = $seanceModel->getJours();
        $creneaux = $seanceModel->getCreneauxHoraires();
        $planning = $seanceModel->getPlanningOrganise($classe_id);

        $data = [
            'pageTitle' => 'Mon Emploi du Temps',
            'activePage' => 'etu-emploi',
            'jours' => $jours,
            'creneaux' => $creneaux,
            'planning' => $planning,
            'nom_classe' => $nom_classe
        ];

        return view('etudiant/calendar', $data);
    }
}