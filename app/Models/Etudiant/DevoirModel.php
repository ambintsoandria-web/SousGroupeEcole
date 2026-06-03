<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class DevoirModel extends Model
{
    protected $table = 'devoir_lecon';
    protected $primaryKey = 'id_devoir';
    protected $returnType = 'array';
    protected $allowedFields = [
        'titre',
        'type',
        'description',
        'date_publication',
        'date_remise',
        'fichier_url',
        'id_matiere',
        'id_classe',
        'id_professeur'
    ];
    protected $useTimestamps = true;
    protected $createdField = 'created_at';
    protected $updatedField = 'updated_at';

    /**
     * Récupère les devoirs d'une classe
     */
    public function getDevoirsClasse($classe_id)
    {
        return $this->db->table('devoir_lecon')
            ->select('devoir_lecon.*, matieres.intitule as matiere_nom, profils_professeurs.nom as prof_nom, profils_professeurs.prenom as prof_prenom')
            ->join('matieres', 'matieres.id = devoir_lecon.id_matiere', 'left')
            ->join('profils_professeurs', 'profils_professeurs.id = devoir_lecon.id_professeur', 'left')
            ->where('devoir_lecon.id_classe', $classe_id)
            ->orderBy('devoir_lecon.date_remise', 'ASC')
            ->get()
            ->getResultArray();
    }

    /**
     * Récupère les devoirs d'un élève via sa classe
     */
    public function getDevoirsEtudiant($etudiant_id)
    {
        $inscriptionModel = new \App\Models\Etudiant\InscriptionModel();
        $classe = $inscriptionModel->getClasseEtudiant($etudiant_id);

        if (!$classe) {
            return [];
        }

        return $this->getDevoirsClasse($classe['id']);
    }

    /**
     * Récupère le type de devoir formaté
     */
    public function getTypeLibelle($type)
    {
        $types = [
            'devoir' => 'Devoir',
            'leçon' => 'Leçon',
            'exercice' => 'Exercices',
            'projet' => 'Projet',
            'révision' => 'Révision'
        ];
        return $types[$type] ?? ucfirst($type);
    }

    /**
     * Récupère la couleur du badge selon le type
     */
    public function getBadgeClass($type)
    {
        $badges = [
            'devoir' => 'badge-amber',
            'leçon' => 'badge-teal',
            'exercice' => 'badge-violet',
            'projet' => 'badge-navy',
            'révision' => 'badge-green'
        ];
        return $badges[$type] ?? 'badge-gray';
    }

    /**
     * Récupère la couleur du badge selon les jours restants
     */
    public function getDueBadgeClass($date_remise)
    {
        if (!$date_remise) {
            return 'badge-gray';
        }

        $jours = (strtotime($date_remise) - time()) / (60 * 60 * 24);
        
        if ($jours < 0) {
            return 'badge-red';
        } elseif ($jours <= 1) {
            return 'badge-red';
        } elseif ($jours <= 3) {
            return 'badge-amber';
        } else {
            return 'badge-green';
        }
    }

    /**
     * Récupère le texte pour les jours restants
     */
    public function getDueTexte($date_remise)
    {
        if (!$date_remise) {
            return 'Date non définie';
        }

        $jours = (strtotime($date_remise) - time()) / (60 * 60 * 24);
        
        if ($jours < 0) {
            return 'En retard';
        } elseif ($jours == 0) {
            return 'Aujourd\'hui';
        } elseif ($jours == 1) {
            return 'Dans 1 jour';
        } else {
            return 'Dans ' . floor($jours) . ' jours';
        }
    }
}