<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class UserRoleModel extends Model
{
    protected $table = 'user_roles';
    protected $primaryKey = ['user_id', 'role_id'];
    protected $returnType = 'array';
    protected $allowedFields = [
        'user_id',
        'role_id'
    ];
    protected $useTimestamps = false;
}