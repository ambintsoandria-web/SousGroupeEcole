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

  <!-- ALERTE SI ANNÉE FINIE -->
  <?php if ($infoAnnee && $infoAnnee->statut == 'terminee'): ?>
    <div class="alert alert-warning"
      style="background: #fff3cd; border: 1px solid #ffecb5; border-radius: 8px; padding: 12px 20px; margin-bottom: 20px;">
      ⚠️ <strong>Année scolaire terminée !</strong> L'année <?= esc($infoAnnee->annee) ?> est finie. Voici l'emploi du
      temps de la période <?= esc($infoAnnee->periode) ?> à titre de consultation.
    </div>
  <?php endif; ?>

  <!-- SÉLECTEUR DE PÉRIODE -->
  <div class="periode-selector" style="margin-bottom: 20px;">
    <form method="GET" action="<?= current_url() ?>"
      style="display: flex; gap: 10px; align-items: center; flex-wrap: wrap;">
      <label for="periode_id" style="font-weight: 500;">📆 Choisir la période :</label>
      <select name="periode_id" id="periode_id" onchange="this.form.submit()"
        style="padding: 8px 12px; border-radius: 6px; border: 1px solid #ddd;">
        <?php foreach ($periodes as $periode): ?>
          <option value="<?= $periode['id'] ?>" <?= ($periode_selectionnee == $periode['id']) ? 'selected' : '' ?>>
            <?= esc($periode['libelle']) ?>
            (<?= date('d/m', strtotime($periode['date_debut'])) ?> - <?= date('d/m', strtotime($periode['date_fin'])) ?>)
          </option>
        <?php endforeach; ?>
      </select>

      <?php if ($infoAnnee && $infoAnnee->statut == 'active'): ?>
        <span style="background: #28a745; color: white; padding: 4px 12px; border-radius: 20px; font-size: 12px;">
          ✅ Période en cours
        </span>
      <?php endif; ?>
    </form>
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
  .periode-selector select {
    background: white;
    cursor: pointer;
  }

  .periode-selector select:hover {
    border-color: #007bff;
  }

  .alert-warning {
    margin-bottom: 20px;
  }
</style>

<?= view('inc/footer') ?>