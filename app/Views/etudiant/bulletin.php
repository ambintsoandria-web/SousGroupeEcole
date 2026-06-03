<?php
  $pageTitle = 'Mon Bulletin';
  $activePage = 'etu-bulletin';
  $activeRole = 'etudiant';
  
  
  $matieres = $matieres ?? [];
  $moyenneGenerale = $moyenneGenerale ?? 0;
  $rang = $rang ?? null;
  $totalEleves = $totalEleves ?? 0;
  $classe = $classe ?? null;
  $periode = $periode ?? null;
  $annee = $annee ?? null;

  $getRangTexte = function($rang) {
    if (!$rang) return '-';
    $rangs = [1 => '1er', 2 => '2ème', 3 => '3ème'];
    return $rangs[$rang] ?? $rang . 'ème';
  };
  
  // Fonction pour l'appréciation générale
  $getAppreciationGenerale = function($moyenne) {
    if ($moyenne >= 16) return 'Excellent travail, félicitations !';
    if ($moyenne >= 14) return 'Très bon élève, continuez ainsi !';
    if ($moyenne >= 12) return 'Bon élève, peut mieux faire.';
    if ($moyenne >= 10) return 'Élève moyen, travail recommandé.';
    return 'Élève en difficulté, accompagnement nécessaire.';
  };
  
  // Fonction pour le grade d'une note
  $getGradeClass = function($note) {
    if ($note >= 16) return 'grade-excellent';
    if ($note >= 14) return 'grade-very-good';
    if ($note >= 12) return 'grade-good';
    if ($note >= 10) return 'grade-average';
    if ($note >= 6) return 'grade-bad';
    return 'grade-verybad';
  };
?>

<?= view('inc/header',['pageTitle' => $pageTitle, 'activePage' => $activePage]) ?>

    <section class="page-section active" id="etu-bulletin">
      <div class="page-header">
        <div>
          <h2>Mon Bulletin</h2>
          <p>
            <?php if ($periode): ?>
              <?= esc($periode['libelle'] ?? 'Trimestre') ?> — <?= esc($annee['libelle'] ?? '') ?>
            <?php else: ?>
              Trimestre — Année scolaire
            <?php endif; ?>
          </p>
        </div>
        <button class="btn btn-secondary"><i class="fas fa-download"></i> Télécharger PDF</button>
      </div>
      <div class="bulletin">
        <div class="bulletin-head">
          <div>
            <h3>BULLETIN DE NOTES</h3>
            <p>
              Lycée Privé — 
              <?php if ($annee): ?>
                Année <?= esc($annee['libelle']) ?> · 
              <?php endif; ?>
              <?php if ($periode): ?>
                <?= esc($periode['libelle']) ?> · 
              <?php endif; ?>
              <?= esc($classe['nom'] ?? 'Classe') ?>
            </p>
            <p style="margin-top:8px;font-size:14px;opacity:.8;">
              Élève : <strong><?= esc((session()->get('prenom') ?? '') . ' ' . (session()->get('nom') ?? '')) ?></strong>
            </p>
          </div>
          <div class="bulletin-rank">
            <span>Rang</span><strong><?= $getRangTexte($rang) ?></strong><span>/ <?= esc($totalEleves) ?></span>
          </div>
        </div>
        <div class="bulletin-body">
          <div class="bulletin-row header">
            <div>Matière</div><div>Note /20</div><div>Coef.</div><div>Appréciation</div>
          </div>
          <?php if (!empty($matieres)): ?>
            <?php foreach ($matieres as $matiere): ?>
              <div class="bulletin-row">
                <div><?= esc($matiere['nom']) ?></div>
                <div class="<?= esc($matiere['grade']) ?>"><?= esc($matiere['note']) ?></div>
                <div><?= esc($matiere['coefficient']) ?></div>
                <div style="font-size:12px;color:var(--clr-teal);"><?= esc($matiere['appreciation']) ?></div>
              </div>
            <?php endforeach; ?>
          <?php else: ?>
            <div class="bulletin-row">
              <div colspan="4" style="text-align:center;padding:20px;color:var(--clr-text-muted);">
                Aucune note disponible pour cette période
              </div>
            </div>
          <?php endif; ?>
        </div>
        <div class="bulletin-footer">
          <div>
            <div style="font-size:11px;text-transform:uppercase;letter-spacing:.8px;color:var(--clr-text-muted);">Moyenne Générale</div>
            <div class="moy <?= $getGradeClass($moyenneGenerale) ?>">
              <?= esc($moyenneGenerale) ?> / 20
            </div>
          </div>
          <div style="text-align:right;">
            <div style="font-size:11px;text-transform:uppercase;letter-spacing:.8px;color:var(--clr-text-muted);">Appréciation</div>
            <div style="font-size:13px;font-style:italic;margin-top:4px;"><?= esc($getAppreciationGenerale($moyenneGenerale)) ?></div>
          </div>
        </div>
      </div>
    </section>

<?= view('inc/modals') ?>

<?= view('inc/footer') ?>