<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class RoleModel extends Model
{
    protected $table = 'roles';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = [
        'nom',
        'description'
    ];
    protected $useTimestamps = true;

    public function getUserRole($user_id)
    {
        $db = \Config\Database::connect();
        $query = $db->query("
            SELECT r.nom 
            FROM user_roles ur
            JOIN roles r ON r.id = ur.role_id
            WHERE ur.user_id = ?
        ", [$user_id]);

        $result = $query->getRow();
        return $result ? $result->nom : null;
    }
}