<?php
$pageTitle = 'Mes Notes';
$activePage = 'etu-notes';
$activeRole = 'etudiant';
$userName = session()->get('nom') . ' ' . session()->get('prenom');
$userRole = 'Étudiant';
$userInitials = session()->get('initiales');
?>

<?= view('inc/header', ['pageTitle' => $pageTitle, 'activePage' => $activePage]) ?>

<section class="page-section active" id="etu-notes">
  <div class="page-header">
    <div>
      <h2>Mes Notes</h2>
    </div>
    <div style="display: flex; gap: 10px;">
      <select class="form-control" id="annee_select" style="width:auto;padding:8px 12px;">
        <?php foreach ($liste_annees as $annee): ?>
          <option value="<?= $annee['id'] ?>" <?= ($annee_selectionnee == $annee['id']) ? 'selected' : '' ?>>
            Année <?= esc($annee['libelle']) ?>
          </option>
        <?php endforeach; ?>
      </select>

      <select class="form-control" id="periode_select" style="width:auto;padding:8px 12px;">
        <?php foreach ($liste_periodes as $periode): ?>
          <option value="<?= $periode['id'] ?>" <?= ($periode_selectionnee == $periode['id']) ? 'selected' : '' ?>>
            <?= esc($periode['libelle']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </div>
  </div>

  <div class="stats-grid" style="margin-bottom:var(--sp-xl);">
    <div class="stat-card amber">
      <div class="stat-icon amber"><i class="fas fa-star"></i></div>
      <div class="stat-value"><?= $moyenne_generale ?? '--' ?></div>
      <div class="stat-label">Moyenne générale</div>
    </div>
    <div class="stat-card teal">
      <div class="stat-icon teal"><i class="fas fa-trophy"></i></div>
      <div class="stat-value"><?= $rang ?? '--' ?></div>
      <div class="stat-label">Rang dans la classe</div>
    </div>
    <div class="stat-card violet">
      <div class="stat-icon violet"><i class="fas fa-chart-line"></i></div>
      <div class="stat-value"><?= $progression ?? '--' ?></div>
      <div class="stat-label">Progression vs T1</div>
    </div>
  </div>

  <div class="card">
    <div class="card-header">
      <h3>Détail par matière</h3>
    </div>
    <div class="table-wrapper">
      <table class="data-table">
        <thead>
          <tr>
            <th>Matière</th>
            <th>Professeur</th>
            <th>Note /20</th>
            <th>Coeff.</th>
            <th>Appréciation</th>
          </tr>
        </thead>
        <tbody>
          <?php if (empty($liste_notes)): ?>
            <tr>
              <td colspan="5" style="text-align:center;">Aucune note pour cette période</td>
            </tr>
          <?php else: ?>
            <?php foreach ($liste_notes as $note): ?>
              <tr>
                <td><?= esc($note['matiere_nom']) ?></td>
                <td>Prof. <?= esc($note['prof_prenom']) ?>     <?= esc($note['prof_nom']) ?></td>
                <td class="<?= $note['grade'] ?>"><?= number_format($note['valeur'], 2) ?></td>
                <td><?= $note['coefficient'] ?? '--' ?></td>
                <td style="color:var(--clr-teal);font-size:13px;"><?= esc($note['apreciation']) ?></td>
              </tr>
            <?php endforeach; ?>
          <?php endif; ?>
        </tbody>
      </table>
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
  .grade-excellent {
    color: #28a745;
    font-weight: bold;
  }

  .grade-very-good {
    color: #17a2b8;
    font-weight: bold;
  }

  .grade-good {
    color: #28a745;
  }

  .grade-average {
    color: #ffc107;
  }

  .grade-bad {
    color: #fd7e14;
  }

  .grade-verybad {
    color: #dc3545;
    font-weight: bold;
  }
</style>

<?= view('inc/footer') ?>