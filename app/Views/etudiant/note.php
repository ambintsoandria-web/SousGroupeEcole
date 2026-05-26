<?php
$pageTitle = 'Mes Notes';
$activePage = 'etu-notes';
$activeRole = 'etudiant';
?>

<?= view('inc/header', ['pageTitle' => $pageTitle, 'activePage' => $activePage]) ?>

<section class="page-section active" id="etu-notes">
  <div class="page-header">
    <div>
      <h2>Mes Notes</h2>
    </div>
    <div style="display: flex; gap: 10px;">
      <!-- Sélecteur Année Scolaire -->
      <select class="form-control" id="annee_select" style="width:auto;padding:8px 12px;">
        <?php foreach ($liste_annees as $annee): ?>
          <option value="<?= $annee['id'] ?>" <?= ($annee_selectionnee == $annee['id']) ? 'selected' : '' ?>>
            Année <?= esc($annee['libelle']) ?>
          </option>
        <?php endforeach; ?>
      </select>

      <!-- Sélecteur Période -->
      <select class="form-control" id="periode_select" style="width:auto;padding:8px 12px;">
        <?php foreach ($liste_periode as $periode): ?>
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
      <div class="">
        <h1> <?= ($moyenne) ? number_format($moyenne, 2) : '—' ?></h1>
      </div>
      <div class="stat-label">Moyenne générale</div>
    </div>
    <div class="stat-card teal">
      <div class="stat-icon teal"><i class="fas fa-trophy"></i></div>
      <div class="">
        <h1><?= number_format($moyenne, 2) ?></h1>
      </div>
      <div class="stat-label">Rang dans la classe</div>
    </div>
    <div class="stat-card violet">
      <div class="stat-icon violet"><i class="fas fa-chart-line"></i></div>
      <div class="stat-value">+1.3</div>
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
              <td colspan="5" style="text-align: center; padding: 40px;">
                📭 Aucune note disponible pour cette période
              </td>
            </tr>
          <?php else: ?>
            <?php foreach ($liste_notes as $notes):
              $grade_class = 'grade-default';
              $valeur = (float) $notes['valeur'];

              if ($valeur <= 8) {
                $grade_class = 'grade-red';
              } elseif ($valeur <= 10) {
                $grade_class = 'grade-orange-red';
              } elseif ($valeur <= 12) {
                $grade_class = 'grade-orange';
              } elseif ($valeur <= 14) {
                $grade_class = 'grade-yellow';
              } elseif ($valeur <= 16) {
                $grade_class = 'grade-green';
              } else {
                $grade_class = 'grade-dark-green';
              }
              ?>
              <tr>
                <td><?= esc($notes['intitule']) ?></td>
                <td><?= esc($notes['nom_prof'] ?? 'Prof. inconnu') ?></td>
                <td class="<?= $grade_class ?>"><?= number_format($notes['valeur'], 2) ?></td>
                <td><?= number_format($notes['coefficient']) ?></td>
                <td style="color:var(--clr-teal); font-size:13px;"><?= esc($notes['apreciation']) ?></td>
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
    const annee_id = this.value;
    const periode_id = document.getElementById('periode_select').value;
    window.location.href = '?annee_id=' + annee_id + '&periode_id=' + periode_id;
  });

  document.getElementById('periode_select').addEventListener('change', function () {
    const periode_id = this.value;
    const annee_id = document.getElementById('annee_select').value;
    window.location.href = '?annee_id=' + annee_id + '&periode_id=' + periode_id;
  });
</script>
<?= view('inc/footer') ?>