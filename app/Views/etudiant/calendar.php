<?php
$pageTitle = 'Mon Emploi du Temps';
$activePage = 'etu-emploi';
$activeRole = 'etudiant';
$userName = session()->get('nom') . ' ' . session()->get('prenom');
$userRole = 'Étudiant';
$userInitials = session()->get('initiales');
?>

<?= view('inc/header', ['pageTitle' => $pageTitle, 'activePage' => $activePage]) ?>

<section class="page-section active" id="etu-emploi">
  <div class="page-header">
    <div>
      <h2>Mon Emploi du Temps</h2>
      <p><?= $semaine ?> — <?= $nom_classe ?></p>
    </div>
    <div style="display: flex; gap: 10px;">
      <select class="form-control" id="annee_select" style="width:auto;padding:8px 12px;">
        <?php foreach ($annees as $annee): ?>
          <option value="<?= $annee['id'] ?>" <?= ($annee_selectionnee == $annee['id']) ? 'selected' : '' ?>>
            Année <?= esc($annee['libelle']) ?>
          </option>
        <?php endforeach; ?>
      </select>

      <select class="form-control" id="periode_select" style="width:auto;padding:8px 12px;">
        <?php foreach ($periodes as $periode): ?>
          <option value="<?= $periode['id'] ?>" <?= ($periode_selectionnee == $periode['id']) ? 'selected' : '' ?>>
            <?= esc($periode['libelle']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </div>
  </div>

  <div class="card">
    <div class="card-body" style="padding:var(--sp-md);">
      <div class="schedule-grid">
        <div class="schedule-header">Heure</div>
        <?php foreach ($jours as $jour): ?>
          <div class="schedule-header"><?= $jour ?></div>
        <?php endforeach; ?>

        <?php foreach ($creneaux as $heure => $libelle): ?>
          <div class="schedule-cell schedule-time"><?= $libelle ?></div>
          <?php foreach ($jours as $jour): ?>
            <div class="schedule-cell">
              <?php if (isset($planning[$jour][$heure])):
                $cours = $planning[$jour][$heure];
                ?>
                <div class="schedule-class">
                  <span><?= esc($cours['matiere']) ?></span>
                  <small><?= esc($cours['professeur']) ?></small>
                </div>
              <?php endif; ?>
            </div>
          <?php endforeach; ?>
        <?php endforeach; ?>
      </div>
    </div>
  </div>
</section>

<script>
  document.getElementById('annee_select').addEventListener('change', function () {
    let annee_id = this.value;
    let periode_id = document.getElementById('periode_select').value;
    window.location.href = '?annee_id=' + annee_id + '&periode_id=' + periode_id;
  });

  document.getElementById('periode_select').addEventListener('change', function () {
    let periode_id = this.value;
    let annee_id = document.getElementById('annee_select').value;
    window.location.href = '?annee_id=' + annee_id + '&periode_id=' + periode_id;
  });
</script>

<style>
  .schedule-grid {
    display: grid;
    grid-template-columns: 100px repeat(5, 1fr);
    gap: 1px;
    background: #ddd;
    border-radius: 12px;
    overflow: hidden;
  }

  .schedule-header,
  .schedule-cell {
    background: white;
    padding: 12px 8px;
    text-align: center;
    font-size: 13px;
  }

  .schedule-header {
    background: #1e3a5f;
    color: white;
    font-weight: 600;
  }

  .schedule-time {
    background: #f5f5f5;
    font-weight: 500;
  }

  .schedule-class {
    background: #f9f9f9;
    border-radius: 8px;
    padding: 6px;
    text-align: center;
  }

  .schedule-class span {
    font-weight: 600;
    font-size: 13px;
    display: block;
  }

  .schedule-class small {
    font-size: 10px;
    color: #666;
    display: block;
  }
</style>

<?= view('inc/footer') ?>