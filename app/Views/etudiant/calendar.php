<?php
$pageTitle = $pageTitle ?? 'Mon Emploi du Temps';
$activePage = $activePage ?? 'etu-emploi';
?>

<?= view('inc/header', ['pageTitle' => $pageTitle, 'activePage' => $activePage]) ?>

<section class="page-section active" id="etu-emploi">
  <link rel="stylesheet" href="/assets/css/calendar.css">
  <div class="page-header">
    <div>
      <h2>📅 Mon Emploi du Temps</h2>
      <p class=""><?= esc($nom_classe ?? 'Ma Classe') ?></p>
    </div>
  </div>

  <div class="edt-container">
    <div class="edt-grid">
      <!-- En-tête -->
      <div class="edt-cell edt-header">Horaire</div>
      <?php foreach ($jours as $jour): ?>
        <div class="edt-cell edt-header">
          <div class="day-name"><?= esc(substr($jour, 0, 3)) ?></div>
          <div class="day-full"><?= esc($jour) ?></div>
        </div>
      <?php endforeach; ?>

      <!-- Lignes de cours -->
      <?php foreach ($creneaux as $heure => $label): ?>
        <div class="edt-cell edt-time"><?= esc($label) ?></div>
        <?php foreach ($jours as $jour): ?>
          <div class="edt-cell edt-course">
            <?php if (isset($planning[$jour][$heure])):
              $cours = $planning[$jour][$heure];
              ?>
              <div class="course-card">
                <div class="course-matiere"><?= esc($cours['matiere']) ?></div>
                <div class="course-prof">👨‍🏫 <?= esc($cours['professeur']) ?></div>
                <?php if (!empty($cours['salle'])): ?>
                  <div class="course-salle">📍 <?= esc($cours['salle']) ?></div>
                <?php endif; ?>
              </div>
            <?php endif; ?>
          </div>
        <?php endforeach; ?>
      <?php endforeach; ?>
    </div>
  </div>
</section>

<style>
</style>

<?= view('inc/footer') ?>