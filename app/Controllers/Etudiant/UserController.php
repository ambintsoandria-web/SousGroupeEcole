<?php

namespace App\Controllers\Etudiant;

error_reporting(E_ALL);
ini_set('display_errors', 1);

use App\Controllers\BaseController;
use App\Models\Etudiant\EtudiantModel;
use App\Models\Etudiant\RoleModel;
use App\Models\Etudiant\UserModel;

class UserController extends BaseController
{
    protected $userModel;
    protected $roleModel;
    protected $etudiantModel;

    public function __construct()
    {
        $this->userModel = new UserModel();
        $this->roleModel = new RoleModel();
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

        if (!$user) {
            return redirect()->back()->with('error', 'Email ou mot de passe incorrect');
        }

        $role = $this->roleModel->getUserRole($user['id']);

        if ($role !== 'etudiant') {
            return redirect()->back()->with('error', 'Accès réservé aux étudiants. Connectez-vous avec un compte étudiant.');
        }

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

        return redirect()->to('/etudiant/calendar');
    }
    public function logout()
    {
        session()->destroy();
        return redirect()->to('/etudiant/login');
    }
}