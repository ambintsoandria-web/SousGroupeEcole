<?php
$pageTitle = 'Mon Bulletin';
$activePage = 'etu-bulletin';
$activeRole = 'etudiant';
$userName = session()->get('nom') . ' ' . session()->get('prenom');
$userRole = 'Étudiant';
$userInitials = session()->get('initiales');
?>

<?= view('inc/header', ['pageTitle' => $pageTitle, 'activePage' => $activePage]) ?>

<section class="page-section active" id="etu-bulletin">
  <div class="page-header">
    <div>
      <h2>Mon Bulletin</h2>
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

      <button class="btn btn-secondary" id="btn-pdf"><i class="fas fa-download"></i> Télécharger PDF</button>
    </div>
  </div>

  <?php if ($periode_terminee): ?>
    <div class="alert alert-warning"
      style="background: #fff3cd; border: 1px solid #ffecb5; border-radius: 8px; padding: 12px 20px; margin-bottom: 20px;">
      <?= $message_periode ?>
    </div>
  <?php endif; ?>

  <div class="bulletin" id="bulletin-content">
    <div class="bulletin-head">
      <div>
        <h3>BULLETIN DE NOTES</h3>
        <p>Lycée Moderne — Année <?= esc($annee_libelle) ?> · <?= esc($periode_libelle) ?> · <?= esc($classe_nom) ?></p>
        <p style="margin-top:8px;font-size:14px;opacity:.8;">Élève : <strong><?= esc($etudiant_nom) ?></strong></p>
      </div>
      <div class="bulletin-rank">
        <span>Rang</span><strong><?= $rang ?></strong><span>/ <?= count($liste_notes) ?></span>
      </div>
    </div>

    <div class="bulletin-body">
      <div class="bulletin-row header">
        <div>Matière</div>
        <div>Note /20</div>
        <div>Coeff.</div>
        <div>Appréciation</div>
      </div>

      <?php foreach ($liste_notes as $note): ?>
        <div class="bulletin-row">
          <div><?= esc($note['matiere_nom']) ?></div>
          <div class="<?= $note['grade_class'] ?>"><?= number_format($note['valeur'], 2) ?></div>
          <div><?= $note['coefficient'] ?></div>
          <div><?= esc($note['apreciation']) ?></div>
        </div>
      <?php endforeach; ?>
    </div>

    <div class="bulletin-footer">
      <div>
        <div style="font-size:11px;text-transform:uppercase;letter-spacing:.8px;color:#666;">Moyenne Générale</div>
        <div
          class="moy <?= $moyenne_generale >= 16 ? 'grade-excellent' : ($moyenne_generale >= 14 ? 'grade-very-good' : ($moyenne_generale >= 12 ? 'grade-good' : 'grade-average')) ?>">
          <?= $moyenne_generale ?> / 20
        </div>
      </div>
      <div style="text-align:right;">
        <div style="font-size:11px;text-transform:uppercase;letter-spacing:.8px;color:#666;">Appréciation</div>
        <div style="font-size:13px;font-style:italic;margin-top:4px;">"<?= esc($appreciation) ?>"</div>
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

  document.getElementById('btn-pdf').addEventListener('click', function () {
    const element = document.getElementById('bulletin-content');
    html2pdf().set({
      margin: 0.5,
      filename: 'bulletin_<?= $etudiant_nom ?>_<?= $periode_libelle ?>.pdf',
      image: { type: 'jpeg', quality: 0.98 },
      html2canvas: { scale: 2 },
      jsPDF: { unit: 'in', format: 'a4', orientation: 'portrait' }
    }).from(element).save();
  });
</script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>

<style>
  .bulletin {
    background: white;
    border-radius: 16px;
    padding: 24px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  }

  .bulletin-head {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    border-bottom: 2px solid #1e3a5f;
    padding-bottom: 16px;
    margin-bottom: 20px;
  }

  .bulletin-head h3 {
    font-family: 'Playfair Display', serif;
    color: #1e3a5f;
    font-size: 20px;
    margin-bottom: 8px;
  }

  .bulletin-head p {
    font-size: 13px;
    color: #666;
    margin: 0;
  }

  .bulletin-rank {
    text-align: center;
    background: #f5f5f5;
    padding: 8px 16px;
    border-radius: 12px;
  }

  .bulletin-rank span {
    font-size: 12px;
    color: #666;
  }

  .bulletin-rank strong {
    font-size: 24px;
    font-weight: 700;
    margin: 0 8px;
    color: #ffc107;
  }

  .bulletin-body {
    margin-bottom: 20px;
  }

  .bulletin-row {
    display: grid;
    grid-template-columns: 2fr 1fr 0.8fr 2fr;
    padding: 12px 0;
    border-bottom: 1px solid #eee;
    font-size: 13px;
  }

  .bulletin-row.header {
    background: #f8f9fa;
    font-weight: 600;
    border-bottom: 2px solid #ddd;
  }

  .bulletin-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: #f8f9fa;
    padding: 16px;
    border-radius: 12px;
    margin-top: 20px;
  }

  .moy {
    font-size: 24px;
    font-weight: 700;
  }

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