<?php

namespace App\Models\Etudiant;

use CodeIgniter\Model;

class UsersModel extends Model
{
    protected $table = 'users';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = ['email', 'password_hash', 'is_active', 'last_login'];
    protected $useTimestamps = true;

    public function logged_in($email, $mdp)
    {
        $user = $this->where('email', $email)->first();

        if ($user && password_verify($mdp, $user['password_hash'])) {
            return $user;
        }
        return false;
    }

    public function getProfilUser($role, $id_user)
    {
        if ($role == "etudiant") {
            $etudiantModel = new EtablissementModel();
            return $etudiantModel->where('user_id', $id_user)->first();
        }
        return null;
    }
}
