-- =============================================================
--  LycéePro — Système de Gestion Scolaire


-- =============================================================
-- 1. UTILISATEUR
-- =============================================================
CREATE TABLE utilisateur (
    id_utilisateur  UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    login           VARCHAR(100)  NOT NULL UNIQUE,
    mot_de_passe    VARCHAR(255)  NOT NULL,  -- hash bcrypt
    role            VARCHAR(30)   NOT NULL
                    CHECK (role IN ('admin','directeur','professeur','etudiant','parent')),
    actif           BOOLEAN       NOT NULL DEFAULT TRUE,
    derniere_connexion TIMESTAMPTZ,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- =============================================================
-- 2. TUTEUR (parent / responsable légal)
-- =============================================================
CREATE TABLE tuteur (
    id_tuteur       UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    nom             VARCHAR(100)  NOT NULL,
    prenoms         VARCHAR(150)  NOT NULL,
    lien_parente    VARCHAR(50)   NOT NULL
                    CHECK (lien_parente IN ('père','mère','tuteur_légal','autre')),
    telephone       VARCHAR(20),
    email           VARCHAR(150)  UNIQUE,
    profession      VARCHAR(100),
    adresse         TEXT,
    id_utilisateur  UUID          REFERENCES utilisateur(id_utilisateur) ON DELETE SET NULL,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- =============================================================
-- 3. SALLE
-- =============================================================
CREATE TABLE salle (
    id_salle        UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    code_salle      VARCHAR(20)   NOT NULL UNIQUE,
    libelle         VARCHAR(100)  NOT NULL,
    capacite        SMALLINT      NOT NULL CHECK (capacite > 0),
    batiment        VARCHAR(50),
    equipements     TEXT,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- =============================================================
-- 4. PROFESSEUR
-- =============================================================
CREATE TABLE professeur (
    id_professeur   UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    matricule       VARCHAR(30)   NOT NULL UNIQUE,
    nom             VARCHAR(100)  NOT NULL,
    prenoms         VARCHAR(150)  NOT NULL,
    date_naissance  DATE,
    genre           CHAR(1)       CHECK (genre IN ('M','F')),
    nationalite     VARCHAR(60),
    telephone       VARCHAR(20),
    email           VARCHAR(150)  NOT NULL UNIQUE,
    specialite      VARCHAR(100),
    grade           VARCHAR(50),
    date_embauche   DATE,
    statut          VARCHAR(20)   NOT NULL DEFAULT 'actif'
                    CHECK (statut IN ('actif','congé','retraite','démission')),
    id_utilisateur  UUID          REFERENCES utilisateur(id_utilisateur) ON DELETE SET NULL,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- =============================================================
-- 5. MATIERE
-- =============================================================
CREATE TABLE matiere (
    id_matiere      UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    code_matiere    VARCHAR(20)   NOT NULL UNIQUE,
    intitule        VARCHAR(150)  NOT NULL,
    coefficient     NUMERIC(4,2)  NOT NULL DEFAULT 1 CHECK (coefficient > 0),
    unite           VARCHAR(50),
    niveau          VARCHAR(30),  -- ex: Terminale, Première, Seconde
    serie           VARCHAR(30),  -- ex: C, D, A2
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- =============================================================
-- 6. CLASSE
-- =============================================================
CREATE TABLE classe (
    id_classe       UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    code_classe     VARCHAR(20)   NOT NULL UNIQUE,
    nom_classe      VARCHAR(100)  NOT NULL,
    niveau          VARCHAR(30)   NOT NULL,
    serie           VARCHAR(30),
    annee_scolaire  SMALLINT      NOT NULL,  -- ex: 2026
    effectif_max    SMALLINT      NOT NULL DEFAULT 40 CHECK (effectif_max > 0),
    id_salle        UUID          REFERENCES salle(id_salle) ON DELETE SET NULL,
    id_professeur_principal UUID  REFERENCES professeur(id_professeur) ON DELETE SET NULL,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- =============================================================
-- 7. ETUDIANT  (table centrale)
-- =============================================================
CREATE TABLE etudiant (
    id_etudiant     UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    matricule       VARCHAR(30)   NOT NULL UNIQUE,
    nom             VARCHAR(100)  NOT NULL,
    prenoms         VARCHAR(150)  NOT NULL,
    date_naissance  DATE          NOT NULL,
    lieu_naissance  VARCHAR(150),
    genre           CHAR(1)       NOT NULL CHECK (genre IN ('M','F')),
    nationalite     VARCHAR(60)   NOT NULL DEFAULT 'Malgache',
    adresse         TEXT,
    telephone       VARCHAR(20),
    email           VARCHAR(150)  UNIQUE,
    photo_url       TEXT,
    statut          VARCHAR(20)   NOT NULL DEFAULT 'actif'
                    CHECK (statut IN ('actif','suspendu','diplômé','transféré','abandonné')),
    date_inscription DATE         NOT NULL DEFAULT CURRENT_DATE,
    -- Clés étrangères
    id_classe       UUID          NOT NULL REFERENCES classe(id_classe) ON DELETE RESTRICT,
    id_tuteur       UUID          REFERENCES tuteur(id_tuteur) ON DELETE SET NULL,
    id_utilisateur  UUID          UNIQUE REFERENCES utilisateur(id_utilisateur) ON DELETE SET NULL,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- =============================================================
-- 8. PERIODE (trimestre, semestre, année)
-- =============================================================
CREATE TABLE periode (
    id_periode      UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    libelle         VARCHAR(60)   NOT NULL,   -- ex: "1er Trimestre 2026"
    type_periode    VARCHAR(20)   NOT NULL
                    CHECK (type_periode IN ('trimestre','semestre','annuel')),
    date_debut      DATE          NOT NULL,
    date_fin        DATE          NOT NULL,
    annee_scolaire  SMALLINT      NOT NULL,
    CONSTRAINT chk_dates CHECK (date_fin > date_debut),
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- =============================================================
-- 9. NOTE
-- =============================================================
CREATE TABLE note (
    id_note         UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    valeur          NUMERIC(5,2)  NOT NULL CHECK (valeur BETWEEN 0 AND 20),
    type_evaluation VARCHAR(30)   NOT NULL
                    CHECK (type_evaluation IN ('devoir','interrogation','examen','composition','TP','oral')),
    date_evaluation DATE          NOT NULL,
    observation     TEXT,
    id_etudiant     UUID          NOT NULL REFERENCES etudiant(id_etudiant) ON DELETE CASCADE,
    id_matiere      UUID          NOT NULL REFERENCES matiere(id_matiere) ON DELETE RESTRICT,
    id_professeur   UUID          NOT NULL REFERENCES professeur(id_professeur) ON DELETE RESTRICT,
    id_periode      UUID          NOT NULL REFERENCES periode(id_periode) ON DELETE RESTRICT,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- =============================================================
-- 10. BULLETIN
-- =============================================================
CREATE TABLE bulletin (
    id_bulletin         UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    moyenne_generale    NUMERIC(5,2)  CHECK (moyenne_generale BETWEEN 0 AND 20),
    rang                SMALLINT      CHECK (rang > 0),
    mention             VARCHAR(30),  -- Très bien, Bien, Assez bien, Passable, Insuffisant
    appreciation        TEXT,
    decision_conseil    VARCHAR(50)   -- Admis, Redouble, Passage conditionnel
                        CHECK (decision_conseil IN ('admis','redoublant','passage_conditionnel','exclu','en_attente')),
    valide              BOOLEAN       NOT NULL DEFAULT FALSE,
    id_etudiant         UUID          NOT NULL REFERENCES etudiant(id_etudiant) ON DELETE CASCADE,
    id_periode          UUID          NOT NULL REFERENCES periode(id_periode) ON DELETE RESTRICT,
    UNIQUE (id_etudiant, id_periode),
    created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- =============================================================
-- 11. ABSENCE
-- =============================================================
CREATE TABLE absence (
    id_absence      UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    date_absence    DATE          NOT NULL,
    heure_debut     TIME,
    heure_fin       TIME,
    nb_heures       NUMERIC(4,2)  NOT NULL DEFAULT 1 CHECK (nb_heures > 0),
    justifiee       BOOLEAN       NOT NULL DEFAULT FALSE,
    motif           TEXT,
    piece_jointe    TEXT,          -- URL justificatif
    id_etudiant     UUID          NOT NULL REFERENCES etudiant(id_etudiant) ON DELETE CASCADE,
    id_matiere      UUID          REFERENCES matiere(id_matiere) ON DELETE SET NULL,
    id_periode      UUID          REFERENCES periode(id_periode) ON DELETE SET NULL,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- =============================================================
-- 12. EMPLOI DU TEMPS
-- =============================================================
CREATE TABLE emploi_temps (
    id_creneau      UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    jour_semaine    VARCHAR(10)   NOT NULL
                    CHECK (jour_semaine IN ('Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi')),
    heure_debut     TIME          NOT NULL,
    heure_fin       TIME          NOT NULL,
    annee_scolaire  SMALLINT      NOT NULL,
    CONSTRAINT chk_heures CHECK (heure_fin > heure_debut),
    id_classe       UUID          NOT NULL REFERENCES classe(id_classe) ON DELETE CASCADE,
    id_matiere      UUID          NOT NULL REFERENCES matiere(id_matiere) ON DELETE RESTRICT,
    id_professeur   UUID          NOT NULL REFERENCES professeur(id_professeur) ON DELETE RESTRICT,
    id_salle        UUID          REFERENCES salle(id_salle) ON DELETE SET NULL,
    -- Éviter les doublons : même classe, même créneau
    UNIQUE (id_classe, jour_semaine, heure_debut, annee_scolaire),
    -- Éviter conflits prof : même prof, même créneau
    UNIQUE (id_professeur, jour_semaine, heure_debut, annee_scolaire),
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- =============================================================
-- 13. DEVOIR & LEÇON
-- =============================================================
CREATE TABLE devoir_lecon (
    id_devoir       UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    titre           VARCHAR(200)  NOT NULL,
    type            VARCHAR(20)   NOT NULL
                    CHECK (type IN ('devoir','leçon','exercice','projet','révision')),
    description     TEXT,
    date_publication DATE         NOT NULL DEFAULT CURRENT_DATE,
    date_remise     DATE,
    fichier_url     TEXT,
    id_matiere      UUID          NOT NULL REFERENCES matiere(id_matiere) ON DELETE RESTRICT,
    id_classe       UUID          NOT NULL REFERENCES classe(id_classe) ON DELETE CASCADE,
    id_professeur   UUID          NOT NULL REFERENCES professeur(id_professeur) ON DELETE RESTRICT,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- =============================================================
-- 14. PAIEMENT (frais de scolarité)
-- =============================================================
CREATE TABLE paiement (
    id_paiement     UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    montant         NUMERIC(12,2) NOT NULL CHECK (montant > 0),
    date_paiement   DATE          NOT NULL DEFAULT CURRENT_DATE,
    type_frais      VARCHAR(50)   NOT NULL
                    CHECK (type_frais IN ('inscription','scolarité','cantine','transport','uniforme','autre')),
    mode_paiement   VARCHAR(30)   NOT NULL
                    CHECK (mode_paiement IN ('espèces','virement','mobile_money','chèque','carte')),
    statut          VARCHAR(20)   NOT NULL DEFAULT 'payé'
                    CHECK (statut IN ('payé','en_attente','annulé','remboursé')),
    reference       VARCHAR(100),
    observation     TEXT,
    id_etudiant     UUID          NOT NULL REFERENCES etudiant(id_etudiant) ON DELETE RESTRICT,
    annee_scolaire  SMALLINT      NOT NULL,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- =============================================================
-- 15. ENSEIGNER (professeur ↔ matière ↔ classe)
-- =============================================================
CREATE TABLE enseigner (
    id_enseigner    UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    id_professeur   UUID          NOT NULL REFERENCES professeur(id_professeur) ON DELETE CASCADE,
    id_matiere      UUID          NOT NULL REFERENCES matiere(id_matiere) ON DELETE CASCADE,
    id_classe       UUID          NOT NULL REFERENCES classe(id_classe) ON DELETE CASCADE,
    annee_scolaire  SMALLINT      NOT NULL,
    UNIQUE (id_professeur, id_matiere, id_classe, annee_scolaire),
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- =============================================================
-- 16. ACTUALITE / NOTIFICATION
-- =============================================================
CREATE TABLE actualite (
    id_actualite    UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    titre           VARCHAR(200)  NOT NULL,
    contenu         TEXT          NOT NULL,
    type            VARCHAR(30)   NOT NULL
                    CHECK (type IN ('annonce','événement','alerte','résultat','autre')),
    cible           VARCHAR(20)   NOT NULL DEFAULT 'tous'
                    CHECK (cible IN ('tous','étudiants','professeurs','parents','admin')),
    publie          BOOLEAN       NOT NULL DEFAULT FALSE,
    date_publication TIMESTAMPTZ,
    date_expiration  TIMESTAMPTZ,
    id_auteur       UUID          REFERENCES utilisateur(id_utilisateur) ON DELETE SET NULL,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- =============================================================
-- INDEX (performances)
-- =============================================================
CREATE INDEX idx_etudiant_classe     ON etudiant(id_classe);
CREATE INDEX idx_etudiant_tuteur     ON etudiant(id_tuteur);
CREATE INDEX idx_etudiant_statut     ON etudiant(statut);
CREATE INDEX idx_note_etudiant       ON note(id_etudiant);
CREATE INDEX idx_note_matiere        ON note(id_matiere);
CREATE INDEX idx_note_periode        ON note(id_periode);
CREATE INDEX idx_absence_etudiant    ON absence(id_etudiant);
CREATE INDEX idx_bulletin_etudiant   ON bulletin(id_etudiant);
CREATE INDEX idx_paiement_etudiant   ON paiement(id_etudiant);
CREATE INDEX idx_emploi_classe       ON emploi_temps(id_classe, jour_semaine);
CREATE INDEX idx_devoir_classe       ON devoir_lecon(id_classe);

-- =============================================================
-- TRIGGERS : mise à jour automatique de updated_at
-- =============================================================
CREATE OR REPLACE FUNCTION maj_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_etudiant_updated
  BEFORE UPDATE ON etudiant
  FOR EACH ROW EXECUTE FUNCTION maj_updated_at();

CREATE TRIGGER trg_professeur_updated
  BEFORE UPDATE ON professeur
  FOR EACH ROW EXECUTE FUNCTION maj_updated_at();

CREATE TRIGGER trg_classe_updated
  BEFORE UPDATE ON classe
  FOR EACH ROW EXECUTE FUNCTION maj_updated_at();

CREATE TRIGGER trg_bulletin_updated
  BEFORE UPDATE ON bulletin
  FOR EACH ROW EXECUTE FUNCTION maj_updated_at();

-- =============================================================
-- VUES UTILES
-- =============================================================

-- Vue : résumé étudiant avec classe et tuteur
CREATE VIEW v_etudiant_complet AS
SELECT
    e.matricule,
    e.nom || ' ' || e.prenoms          AS etudiant,
    e.date_naissance,
    e.genre,
    e.statut,
    c.nom_classe                        AS classe,
    c.niveau,
    c.annee_scolaire,
    t.nom || ' ' || t.prenoms          AS tuteur,
    t.telephone                         AS tel_tuteur,
    e.email,
    e.telephone
FROM etudiant e
JOIN classe   c ON c.id_classe  = e.id_classe
LEFT JOIN tuteur t ON t.id_tuteur = e.id_tuteur;

-- Vue : moyennes par étudiant et par période
CREATE VIEW v_moyennes AS
SELECT
    e.matricule,
    e.nom || ' ' || e.prenoms   AS etudiant,
    c.nom_classe                 AS classe,
    p.libelle                    AS periode,
    m.intitule                   AS matiere,
    m.coefficient,
    ROUND(AVG(n.valeur), 2)      AS moyenne,
    COUNT(n.id_note)             AS nb_notes
FROM note n
JOIN etudiant e  ON e.id_etudiant = n.id_etudiant
JOIN classe   c  ON c.id_classe   = e.id_classe
JOIN matiere  m  ON m.id_matiere  = n.id_matiere
JOIN periode  p  ON p.id_periode  = n.id_periode
GROUP BY e.matricule, e.nom, e.prenoms, c.nom_classe,
         p.libelle, m.intitule, m.coefficient;

-- Vue : total absences par étudiant
CREATE VIEW v_absences_etudiant AS
SELECT
    e.matricule,
    e.nom || ' ' || e.prenoms       AS etudiant,
    c.nom_classe                     AS classe,
    COUNT(a.id_absence)              AS nb_absences,
    SUM(a.nb_heures)                 AS total_heures,
    SUM(CASE WHEN a.justifiee THEN a.nb_heures ELSE 0 END)  AS heures_justifiees,
    SUM(CASE WHEN NOT a.justifiee THEN a.nb_heures ELSE 0 END) AS heures_injustifiees
FROM absence a
JOIN etudiant e ON e.id_etudiant = a.id_etudiant
JOIN classe   c ON c.id_classe   = e.id_classe
GROUP BY e.matricule, e.nom, e.prenoms, c.nom_classe;

-- =============================================================
-- FIN DU SCRIPT
-- =============================================================
