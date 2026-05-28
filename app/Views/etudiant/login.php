<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Lycée</title>
    <link rel="stylesheet" href="/assets/css/login.css">
</head>

<body>
    <div class="login-container">
        <div class="login-header">
            <div class="login-logo">
                <i class="fas fa-graduation-cap"></i>
                📚
            </div>
            <h1>Bienvenue</h1>
            <p>Connectez-vous à votre espace</p>
        </div>

        <?php if (session()->getFlashdata('error')): ?>
            <div class="alert-error">
                ⚠️
                <?= esc(session()->getFlashdata('error')) ?>
            </div>
        <?php endif; ?>

        <form action="/etudiant/login" method="POST">
            <div class="form-group">
                <label>📧 Email</label>
                <input type="email" name="email" placeholder="exemple@lycee.mg" required autofocus>
            </div>

            <div class="form-group">
                <label>🔒 Mot de passe</label>
                <input type="password" name="mdp" placeholder="••••••••" required>
            </div>

            <button type="submit" class="btn-login">Se connecter</button>
        </form>

        <div class="login-footer">
            Lycée Moderne - Espace Élèves
        </div>
    </div>
</body>

</html>