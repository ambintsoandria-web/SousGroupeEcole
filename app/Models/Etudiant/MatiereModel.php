<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class MatiereModel extends Model
{
    protected $table = 'matieres';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'etablissement_id',
        'nom',
        'code'
    ];
    protected $useTimestamps = true;
}