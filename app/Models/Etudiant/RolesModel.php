<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class RolesModel extends Model
{
    protected $table = 'roles';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'nom',
        'description',
        'created_at',
    ];
    protected $useTimestamps = true;
    
    public function getUserRole($id_user)
    {
        $db = \Config\Database::connect();

        $query = $db->table('user_roles')
            ->select('roles.nom')
            ->join('roles', 'roles.id = user_roles.role_id')
            ->where('user_roles.user_id', $id_user)
            ->get();

        $result = $query->getRow();

        if ($result) {
            return $result->nom;
        }

        return null;
    }
}
