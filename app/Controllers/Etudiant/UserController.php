<?php

namespace App\Controllers\Etudiant;

use App\Controllers\BaseController;
use App\Models\Etudiant\EtudiantModel;
use App\Models\Etudiant\RolesModel;
use App\Models\Etudiant\UsersModel;

class UserController extends BaseController
{
    public $userModel;
    public $roleModel;
    public $etudiantModel;

    public function __construct()
    {
        $this->userModel = new UsersModel();
        $this->roleModel = new RolesModel();
        $this->etudiantModel = new EtudiantModel();
    }

    public function go_to_login()
    {
        return view('etudiant/login');
    }

    public function login()
    {
        $email = $this->request->getPost("email");
        $mdp = $this->request->getPost("mdp");

        if (!$email || !$mdp) {
            return redirect()->back()->with('error', 'Email et mot de passe requis');
        }

        $user = $this->userModel->logged_in($email, $mdp);

        if ($user) {
            $role = $this->roleModel->getUserRole($user['id']);
            $profil = $this->userModel->getProfilUser($role, $user['id']);

            $nom = $profil['nom'] ?? 'Utilisateur';
            $prenom = $profil['prenom'] ?? '';
            $initiales = strtoupper(substr($prenom, 0, 1) . substr($nom, 0, 1));

            session()->set([
                'id' => $user['id'],
                'email' => $user['email'],
                'logged_in' => true,
                'role' => $role,
                'nom' => $nom,
                'prenom' => $prenom,
                'initiales' => $initiales,
            ]);

            if ($role == "etudiant") {
                return redirect()->to('/etudiant/calendar');
            } else {
                return redirect()->to('/directeur/dashboard');
            }
        } else {
            return redirect()->to('/?error=1&msg=Email+ou+mot+de+passe+incorrect#modal-profil')->with('error', 'Email ou mot de passe incorrect');
        }
    }

    public function logout()
    {
        session()->destroy();
        return redirect()->to('/etudiant/login');
    }
}
