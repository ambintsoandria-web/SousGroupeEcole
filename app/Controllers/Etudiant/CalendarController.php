<?php

namespace App\Controllers\Etudiant;

use App\Controllers\BaseController;
use App\Models\Etudiant\SeanceModel;
use App\Models\Etudiant\InscriptionModel;
use App\Models\Etudiant\PeriodesModel;

class CalendarController extends BaseController
{
    public function index()
    {
        $seanceModel = new SeanceModel();
        $inscriptionModel = new InscriptionModel();
        $periodeModel = new PeriodesModel();

        $etudiant_id = session()->get('id');

        if (!$etudiant_id) {
            return redirect()->to('/etudiant/login')->with('error', 'Veuillez vous connecter');
        }

        // Récupérer la classe et l'année scolaire
        $classeInfo = $inscriptionModel->getClasseEtudiant($etudiant_id);

        if (!$classeInfo) {
            return redirect()->to('/')->with('error', 'Aucune inscription active trouvée');
        }

        $classe_id = $classeInfo['id'];
        $annee_scolaire_id = $classeInfo['annee_scolaire_id'];
        $nom_classe = $classeInfo['nom'] . ' - ' . $classeInfo['niveau_libelle'];

        // Récupérer toutes les périodes
        $periodes = $periodeModel->where('annee_scolaire_id', $annee_scolaire_id)->findAll();

        // LIRE LE PARAMETRE periope_id depuis l'URL (GET)
        $periode_id = $this->request->getGet('periode_id');

        // Si aucun paramètre, prendre la période actuelle (basée sur NOW())
        if (empty($periode_id)) {
            $periodeActuelle = $periodeModel
                ->where('annee_scolaire_id', $annee_scolaire_id)
                ->where('date_debut <=', date('Y-m-d'))
                ->where('date_fin >=', date('Y-m-d'))
                ->first();

            if ($periodeActuelle) {
                $periode_id = $periodeActuelle['id'];
            } else {
                // Si pas de période actuelle, prendre la dernière
                $lastPeriode = $periodeModel->where('annee_scolaire_id', $annee_scolaire_id)->orderBy('id', 'DESC')->first();
                $periode_id = $lastPeriode ? $lastPeriode['id'] : null;
            }
        }

        // Récupérer l'emploi du temps pour la période sélectionnée
        $jours = $seanceModel->getJours();
        $creneaux = $seanceModel->getCreneauxHoraires();
        $planning = $seanceModel->getPlanningOrganise($classe_id, $periode_id);

        // Info sur la période sélectionnée
        $periodeChoisie = $periodeModel->find($periode_id);
        $infoAnnee = null;

        if ($periodeChoisie) {
            $db = \Config\Database::connect();
            $query = $db->query("
                SELECT 
                    a.libelle as annee, 
                    p.libelle as periode, 
                    p.date_debut, 
                    p.date_fin,
                    CASE 
                        WHEN CURRENT_DATE BETWEEN p.date_debut AND p.date_fin THEN 'active' 
                        ELSE 'terminee' 
                    END as statut
                FROM annees_scolaires a
                JOIN periodes p ON p.annee_scolaire_id = a.id
                WHERE a.id = ? AND p.id = ?
            ", [$annee_scolaire_id, $periode_id]);
            $infoAnnee = $query->getRow();
        }

        $data = [
            'pageTitle' => 'Mon Emploi du Temps',
            'activePage' => 'etu-emploi',
            'jours' => $jours,
            'creneaux' => $creneaux,
            'planning' => $planning,
            'nom_classe' => $nom_classe,
            'periodes' => $periodes,
            'periode_selectionnee' => $periode_id,
            'infoAnnee' => $infoAnnee
        ];

        return view('etudiant/calendar', $data);
    }
}