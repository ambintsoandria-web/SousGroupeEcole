<?php
  $pageTitle = 'Devoirs & Leçons';
  $activePage = 'etu-devoirs';
  $activeRole = 'etudiant';
  
  // Données dynamiques depuis le contrôleur avec valeurs par défaut
  $devoirs = $devoirs ?? [];
  $classe = $classe ?? null;
  $periode = $periode ?? null;
  $annee = $annee ?? null;
  
  // Fonction pour le badge de date
  $getDueBadgeClass = function($date_remise) {
    if (!$date_remise) return 'badge-gray';
    $jours = (strtotime($date_remise) - time()) / (60 * 60 * 24);
    if ($jours < 0) return 'badge-red';
    if ($jours <= 1) return 'badge-red';
    if ($jours <= 3) return 'badge-amber';
    return 'badge-green';
  };
  
  // Fonction pour le texte de date
  $getDueTexte = function($date_remise) {
    if (!$date_remise) return 'Date non définie';
    $jours = (strtotime($date_remise) - time()) / (60 * 60 * 24);
    if ($jours < 0) return 'En retard';
    if ($jours == 0) return 'Aujourd\'hui';
    if ($jours == 1) return 'Dans 1 jour';
    return 'Dans ' . floor($jours) . ' jours';
  };
  
  // Fonction pour le badge de type
  $getBadgeClass = function($type) {
    $badges = [
      'devoir' => 'badge-amber',
      'leçon' => 'badge-teal',
      'exercice' => 'badge-violet',
      'projet' => 'badge-navy',
      'révision' => 'badge-green'
    ];
    return $badges[$type] ?? 'badge-gray';
  };
  
  // Fonction pour le libellé du type
  $getTypeLibelle = function($type) {
    $types = [
      'devoir' => 'Devoir',
      'leçon' => 'Leçon',
      'exercice' => 'Exercices',
      'projet' => 'Projet',
      'révision' => 'Révision'
    ];
    return $types[$type] ?? ucfirst($type);
  };
?>

<?= view('inc/header',['pageTitle' => $pageTitle, 'activePage' => $activePage]) ?>

    <section class="page-section active" id="etu-devoirs">
      <div class="page-header">
        <div>
          <h2>Devoirs & Leçons</h2>
          <p>
            <?php if ($periode): ?>
              Période : <?= esc($periode['libelle'] ?? '') ?>
            <?php else: ?>
              Travaux publiés par vos professeurs
            <?php endif; ?>
          </p>
        </div>
      </div>
      
      <div style="display:flex;flex-direction:column;gap:var(--sp-md);">
        <?php if (!empty($devoirs)): ?>
          <?php foreach ($devoirs as $devoir): 
           
            $borderColors = [
              'devoir' => 'var(--clr-amber)',
              'leçon' => 'var(--clr-teal)',
              'exercice' => 'var(--clr-violet)',
              'projet' => 'var(--clr-navy)',
              'révision' => 'var(--clr-green)'
            ];
            $borderColor = $borderColors[$devoir['type']] ?? 'var(--clr-gray)';
          ?>
            <div class="devoir-card" style="border-left-color:<?= $borderColor ?>;">
              <h4><?= esc($getTypeLibelle($devoir['type'])) ?> — <?= esc($devoir['titre']) ?></h4>
              <div class="due">📅 À rendre: <?= $devoir['date_remise'] ? date('j F Y', strtotime($devoir['date_remise'])) : 'Date non définie' ?></div>
              <p><?= esc($devoir['description'] ?? '') ?></p>
              <div style="margin-top:var(--sp-md);display:flex;gap:var(--sp-sm);">
                <span class="badge <?= $getBadgeClass($devoir['type']) ?>"><?= esc($devoir['matiere_nom'] ?? 'Matière') ?></span>
                <span class="badge <?= $getDueBadgeClass($devoir['date_remise']) ?>"><?= $getDueTexte($devoir['date_remise']) ?></span>
              </div>
              <?php if (!empty($devoir['fichier_url'])): ?>
                <div style="margin-top:var(--sp-sm);">
                  <a href="<?= esc($devoir['fichier_url']) ?>" class="btn btn-secondary" style="font-size:12px;padding:4px 12px;">
                    <i class="fas fa-download"></i> Télécharger
                  </a>
                </div>
              <?php endif; ?>
            </div>
          <?php endforeach; ?>
        <?php else: ?>
          <div class="devoir-card" style="text-align:center;padding:40px;">
            <p style="color:var(--clr-text-muted);font-style:italic;">
              📭 Aucun devoir disponible pour cette période
            </p>
          </div>
        <?php endif; ?>
      </div>
    </section>

<?= view('inc/modals') ?>

<?= view('inc/footer') ?>