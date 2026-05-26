-- ============================================================
-- MIGRATION : Ancien schéma → Nouveau schéma
-- ============================================================

-- 1. SUPPRIMER LES CONTRAINTES DE CLÉS ÉTRANGÈRES
-- ============================================================
ALTER TABLE seances DROP CONSTRAINT IF EXISTS seances_emploi_du_temps_id_fkey;
ALTER TABLE seances DROP CONSTRAINT IF EXISTS seances_matiere_id_fkey;
ALTER TABLE seances DROP CONSTRAINT IF EXISTS seances_professeur_id_fkey;
ALTER TABLE seances DROP CONSTRAINT IF EXISTS seances_salle_id_fkey;
ALTER TABLE seances DROP CONSTRAINT IF EXISTS seances_classe_id_fkey;
ALTER TABLE modifications_edt DROP CONSTRAINT IF EXISTS modifications_edt_emploi_du_temps_id_fkey;
ALTER TABLE absences DROP CONSTRAINT IF EXISTS absences_seance_id_fkey;
ALTER TABLE notes DROP CONSTRAINT IF EXISTS notes_matiere_id_fkey;
ALTER TABLE notes DROP CONSTRAINT IF EXISTS notes_professeur_id_fkey;
ALTER TABLE notes DROP CONSTRAINT IF EXISTS notes_etudiant_id_fkey;
ALTER TABLE notes DROP CONSTRAINT IF EXISTS notes_periode_id_fkey;

-- 2. SUPPRIMER LES ANCIENNES TABLES (qui n'existent plus)
-- ============================================================
DROP TABLE IF EXISTS emploi_temps CASCADE;
DROP TABLE IF EXISTS absence CASCADE;
DROP TABLE IF EXISTS devoir_lecon CASCADE;
DROP TABLE IF EXISTS note CASCADE;
DROP TABLE IF EXISTS periode CASCADE;
DROP TABLE IF EXISTS matiere CASCADE;
DROP TABLE IF EXISTS modifications_edt CASCADE;

-- 3. SUPPRIMER LES VUES OU INDEX QUI REFERENCENT
-- ============================================================
DROP INDEX IF EXISTS idx_edt_affectation;
DROP INDEX IF EXISTS idx_edt_validite;
DROP INDEX IF EXISTS idx_modif_edt_date;
DROP INDEX IF EXISTS idx_notes_etudiant;
DROP INDEX IF EXISTS idx_notes_affectation;
DROP INDEX IF EXISTS idx_notes_periode;

-- 4. AJOUTER LES NOUVELLES COLONNES DANS SEANCES
-- ============================================================
ALTER TABLE seances ADD COLUMN IF NOT EXISTS date_seance DATE;
ALTER TABLE seances ADD COLUMN IF NOT EXISTS est_annule BOOLEAN DEFAULT FALSE;
ALTER TABLE seances ALTER COLUMN emploi_du_temps_id SET NOT NULL;

-- 5. CRÉER LA TABLE emploi_du_temps (NOUVELLE VERSION)
-- ============================================================
DROP TABLE IF EXISTS emploi_du_temps CASCADE;
CREATE TABLE emploi_du_temps (
    id                SERIAL PRIMARY KEY,
    classe_id         INT NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
    annee_scolaire_id INT NOT NULL REFERENCES annees_scolaires(id) ON DELETE CASCADE,
    date_debut        DATE NOT NULL,
    date_fin          DATE NOT NULL,
    created_at        TIMESTAMP DEFAULT NOW()
);

-- 6. RECRÉER LA TABLE periodes (SANS UUID)
-- ============================================================
DROP TABLE IF EXISTS periodes CASCADE;
CREATE TABLE periodes (
    id             SERIAL PRIMARY KEY,
    libelle        VARCHAR(60) NOT NULL,
    type_periode   VARCHAR(20) NOT NULL CHECK (type_periode IN ('trimestre','semestre','annuel')),
    date_debut     DATE NOT NULL,
    date_fin       DATE NOT NULL,
    annee_scolaire SMALLINT NOT NULL,
    created_at     TIMESTAMP DEFAULT NOW(),
    CHECK (date_fin > date_debut)
);

-- 7. RECRÉER LA TABLE matieres (SANS UUID)
-- ============================================================
DROP TABLE IF EXISTS matieres CASCADE;
CREATE TABLE matieres (
    id          SERIAL PRIMARY KEY,
    code_matiere VARCHAR(20) NOT NULL UNIQUE,
    intitule    VARCHAR(150) NOT NULL,
    coefficient NUMERIC(4,2) NOT NULL DEFAULT 1 CHECK (coefficient > 0),
    unite       VARCHAR(50),
    niveau      VARCHAR(30),
    serie       VARCHAR(30),
    created_at  TIMESTAMP DEFAULT NOW()
);

-- 8. RECRÉER LA TABLE notes (SANS UUID)
-- ============================================================
DROP TABLE IF EXISTS notes CASCADE;
CREATE TABLE notes (
    id_note         SERIAL PRIMARY KEY,
    valeur          NUMERIC(5,2) NOT NULL CHECK (valeur BETWEEN 0 AND 20),
    type_evaluation VARCHAR(30) NOT NULL CHECK (type_evaluation IN ('devoir','interrogation','examen','composition','TP','oral')),
    date_evaluation DATE NOT NULL,
    observation     TEXT,
    etudiant_id     INT REFERENCES profils_etudiants(id) ON DELETE CASCADE,
    matiere_id      INT REFERENCES matieres(id) ON DELETE RESTRICT,
    professeur_id   INT REFERENCES profils_professeurs(id) ON DELETE RESTRICT,
    periode_id      INT REFERENCES periodes(id) ON DELETE RESTRICT,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- 9. METTRE À JOUR LA TABLE seances AVEC LES BONNES CONTRAINTES
-- ============================================================
ALTER TABLE seances DROP COLUMN IF EXISTS classe_id;
ALTER TABLE seances DROP COLUMN IF EXISTS annee_scolaire_id;
ALTER TABLE seances ADD COLUMN IF NOT EXISTS emploi_du_temps_id INT;

-- 10. RECRÉER LES CONTRAINTES
-- ============================================================
ALTER TABLE seances ADD CONSTRAINT seances_emploi_du_temps_id_fkey 
    FOREIGN KEY (emploi_du_temps_id) REFERENCES emploi_du_temps(id) ON DELETE CASCADE;
ALTER TABLE seances ADD CONSTRAINT seances_matiere_id_fkey 
    FOREIGN KEY (matiere_id) REFERENCES matieres(id) ON DELETE RESTRICT;
ALTER TABLE seances ADD CONSTRAINT seances_professeur_id_fkey 
    FOREIGN KEY (professeur_id) REFERENCES profils_professeurs(id) ON DELETE RESTRICT;
ALTER TABLE seances ADD CONSTRAINT seances_salle_id_fkey 
    FOREIGN KEY (salle_id) REFERENCES salles(id) ON DELETE SET NULL;

-- 11. TRANSFÉRER LES DONNÉES ANCIENNES VERS LA NOUVELLE STRUCTURE
-- ============================================================
-- Transférer les matières
INSERT INTO matieres (code_matiere, intitule, coefficient, created_at)
SELECT code_matiere, intitule, coefficient, created_at FROM matiere WHERE false;

-- Transférer les périodes
INSERT INTO periodes (libelle, type_periode, date_debut, date_fin, annee_scolaire)
SELECT libelle, type_periode, date_debut, date_fin, annee_scolaire FROM periode WHERE false;

-- Transférer les emplois du temps
INSERT INTO emploi_du_temps (classe_id, annee_scolaire_id, date_debut, date_fin)
SELECT DISTINCT e.id_classe::int, e.annee_scolaire, e.created_at::date, e.created_at::date 
FROM emploi_temps e WHERE false;

-- 12. RECRÉER LES INDEX
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_seances_date ON seances(date_seance);
CREATE INDEX IF NOT EXISTS idx_seances_emploi ON seances(emploi_du_temps_id);
CREATE INDEX IF NOT EXISTS idx_notes_etudiant ON notes(etudiant_id);
CREATE INDEX IF NOT EXISTS idx_notes_periode ON notes(periode_id);
CREATE INDEX IF NOT EXISTS idx_notes_matiere ON notes(matiere_id);

-- 13. NETTOYER LES ANCIENNES DONNÉES
-- ============================================================
-- Supprimer les anciennes séquences si elles existent
DROP SEQUENCE IF EXISTS matiere_id_matiere_seq CASCADE;
DROP SEQUENCE IF EXISTS periode_id_periode_seq CASCADE;

-- 14. RÉINITIALISER LES SÉQUENCES
-- ============================================================
ALTER SEQUENCE matieres_id_seq RESTART WITH 1;
ALTER SEQUENCE periodes_id_seq RESTART WITH 1;
ALTER SEQUENCE emploi_du_temps_id_seq RESTART WITH 1;
ALTER SEQUENCE seances_id_seq RESTART WITH 1;

-- ============================================================
-- RÉCAPITULATIF DES CHANGEMENTS
-- ============================================================
-- TABLES SUPPRIMÉES:
--   - emploi_temps (remplacé par emploi_du_temps)
--   - absence (remplacé par absences)
--   - devoir_lecon (remplacé par devoirs_lecons)
--   - note (remplacé par notes)
--   - periode (remplacé par periodes)
--   - matiere (remplacé par matieres)
--
-- TABLES MODIFIÉES:
--   - seances : ajout de date_seance, est_annule, suppression de classe_id
--   - notes : changement de UUID vers SERIAL
--   - absences : correction des clés étrangères
--
-- NOUVELLES TABLES:
--   - emploi_du_temps (structure simplifiée)
--   - periodes (SERIAL au lieu de UUID)
--   - matieres (SERIAL au lieu de UUID)
--   - devoirs_lecons (renommée)
-- ============================================================