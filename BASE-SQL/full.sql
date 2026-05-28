-- ============================================================
--  SCHÉMA COMPLET — GESTION D'ÉCOLE
--  Base de données : PostgreSQL
--  Avec intégration de la table horaire_edt et ses liens
-- ============================================================

BEGIN;

-- ============================================================
-- SECTION 1 — AUTHENTIFICATION & RÔLES
-- ============================================================

CREATE TABLE IF NOT EXISTS users (
    id            SERIAL PRIMARY KEY,
    email         VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_active     BOOLEAN   DEFAULT TRUE,
    last_login    TIMESTAMP,
    created_at    TIMESTAMP DEFAULT NOW(),
    updated_at    TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS roles (
    id          SERIAL PRIMARY KEY,
    nom         VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at  TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS user_roles (
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    role_id INT REFERENCES roles(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);

CREATE TABLE IF NOT EXISTS permissions (
    id          SERIAL PRIMARY KEY,
    code        VARCHAR(150) UNIQUE NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS role_permissions (
    role_id       INT REFERENCES roles(id)       ON DELETE CASCADE,
    permission_id INT REFERENCES permissions(id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id)
);

-- ============================================================
-- SECTION 2 — STRUCTURE DE L'ÉTABLISSEMENT
-- ============================================================

CREATE TABLE IF NOT EXISTS etablissements (
    id           SERIAL PRIMARY KEY,
    nom          VARCHAR(255) NOT NULL,
    adresse      TEXT,
    telephone    VARCHAR(50),
    email        VARCHAR(255),
    logo_url     VARCHAR(500),
    created_at   TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS annees_scolaires (
    id               SERIAL PRIMARY KEY,
    etablissement_id INT REFERENCES etablissements(id),
    libelle          VARCHAR(50) NOT NULL,
    date_debut       DATE NOT NULL,
    date_fin         DATE NOT NULL,
    est_active       BOOLEAN DEFAULT FALSE,
    created_at       TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS niveaux (
    id               SERIAL PRIMARY KEY,
    etablissement_id INT REFERENCES etablissements(id),
    libelle          VARCHAR(100) NOT NULL,
    ordre            INT NOT NULL,
    created_at       TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS classes (
    id                SERIAL PRIMARY KEY,
    niveau_id         INT REFERENCES niveaux(id),
    annee_scolaire_id INT REFERENCES annees_scolaires(id),
    nom               VARCHAR(100) NOT NULL,
    capacite_max      INT DEFAULT 40,
    created_at        TIMESTAMP DEFAULT NOW()
);

-- Table horaire_edt (plages horaires standards)
CREATE TABLE IF NOT EXISTS horaire_edt (
    id           SERIAL PRIMARY KEY,
    libelle      VARCHAR(100) NOT NULL,
    heure_debut  TIME NOT NULL,
    heure_fin    TIME NOT NULL,
    ordre        INT NOT NULL,
    is_active    BOOLEAN DEFAULT TRUE,
    created_at   TIMESTAMP DEFAULT NOW(),
    UNIQUE (heure_debut, heure_fin)
);

CREATE TABLE IF NOT EXISTS salles (
    id               SERIAL PRIMARY KEY,
    etablissement_id INT REFERENCES etablissements(id),
    nom              VARCHAR(100) NOT NULL,
    capacite         INT,
    type             VARCHAR(50) DEFAULT 'cours',
    is_active        BOOLEAN     DEFAULT TRUE,
    created_at       TIMESTAMP   DEFAULT NOW()
);

-- Ajout de la colonne salle_id dans classes
ALTER TABLE classes ADD COLUMN IF NOT EXISTS salle_id INT;
ALTER TABLE classes ADD CONSTRAINT IF NOT EXISTS fk_classes_salle 
    FOREIGN KEY (salle_id) REFERENCES salles(id) ON DELETE SET NULL;

CREATE TABLE IF NOT EXISTS matieres (
    id               SERIAL PRIMARY KEY,
    etablissement_id INT REFERENCES etablissements(id),
    nom              VARCHAR(150) NOT NULL,
    code             VARCHAR(20),
    created_at       TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS coefficients (
    id         SERIAL PRIMARY KEY,
    matiere_id INT REFERENCES matieres(id) ON DELETE CASCADE,
    niveau_id  INT REFERENCES niveaux(id)  ON DELETE CASCADE,
    valeur     NUMERIC(4,2) NOT NULL,
    UNIQUE (matiere_id, niveau_id)
);

CREATE TABLE IF NOT EXISTS periodes (
    id                     SERIAL PRIMARY KEY,
    annee_scolaire_id      INT REFERENCES annees_scolaires(id),
    libelle                VARCHAR(100) NOT NULL,
    type                   VARCHAR(20) DEFAULT 'trimestre',
    ordre                  INT NOT NULL,
    date_debut             DATE,
    date_fin               DATE,
    date_publication_notes DATE,
    est_cloturee           BOOLEAN DEFAULT FALSE
);

-- ============================================================
-- SECTION 3 — PROFILS DES ACTEURS
-- ============================================================

CREATE TABLE IF NOT EXISTS profils_etudiants (
    id             SERIAL PRIMARY KEY,
    user_id        INT UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    matricule      VARCHAR(100) UNIQUE NOT NULL,
    nom            VARCHAR(150) NOT NULL,
    prenom         VARCHAR(150) NOT NULL,
    date_naissance DATE,
    lieu_naissance VARCHAR(200),
    sexe           CHAR(1) CHECK (sexe IN ('M', 'F')),
    photo_url      VARCHAR(500),
    adresse        TEXT,
    commune        VARCHAR(150),
    region         VARCHAR(150),
    nationalite    VARCHAR(100) DEFAULT 'Malgache',
    cin            VARCHAR(50),
    telephone      VARCHAR(50),
    is_archived    BOOLEAN DEFAULT FALSE,
    created_at     TIMESTAMP DEFAULT NOW(),
    updated_at     TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS profils_professeurs (
    id                 SERIAL PRIMARY KEY,
    user_id            INT UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    matricule          VARCHAR(100) UNIQUE NOT NULL,
    nom                VARCHAR(150) NOT NULL,
    prenom             VARCHAR(150) NOT NULL,
    date_naissance     DATE,
    sexe               CHAR(1) CHECK (sexe IN ('M', 'F')),
    photo_url          VARCHAR(500),
    telephone          VARCHAR(50),
    adresse            TEXT,
    specialite         VARCHAR(200),
    type_contrat       VARCHAR(50),
    date_debut_contrat DATE,
    date_fin_contrat   DATE,
    is_archived        BOOLEAN DEFAULT FALSE,
    created_at         TIMESTAMP DEFAULT NOW(),
    updated_at         TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS profils_directeurs (
    id         SERIAL PRIMARY KEY,
    user_id    INT UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    nom        VARCHAR(150) NOT NULL,
    prenom     VARCHAR(150) NOT NULL,
    telephone  VARCHAR(50),
    photo_url  VARCHAR(500),
    created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE etablissements ADD COLUMN IF NOT EXISTS directeur_id INT;
ALTER TABLE etablissements ADD CONSTRAINT IF NOT EXISTS fk_etablissements_directeur 
    FOREIGN KEY (directeur_id) REFERENCES profils_directeurs(id) ON DELETE SET NULL;

CREATE TABLE IF NOT EXISTS profils_secretariat (
    id         SERIAL PRIMARY KEY,
    user_id    INT UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    nom        VARCHAR(150) NOT NULL,
    prenom     VARCHAR(150) NOT NULL,
    telephone  VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS profils_comptables (
    id         SERIAL PRIMARY KEY,
    user_id    INT UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    nom        VARCHAR(150) NOT NULL,
    prenom     VARCHAR(150) NOT NULL,
    telephone  VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS profils_parents (
    id           SERIAL PRIMARY KEY,
    user_id      INT REFERENCES users(id) ON DELETE SET NULL,
    nom          VARCHAR(150) NOT NULL,
    prenom       VARCHAR(150) NOT NULL,
    telephone    VARCHAR(50),
    email        VARCHAR(255),
    profession   VARCHAR(200),
    lien_parente VARCHAR(100),
    created_at   TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS etudiants_parents (
    etudiant_id           INT REFERENCES profils_etudiants(id) ON DELETE CASCADE,
    parent_id             INT REFERENCES profils_parents(id)   ON DELETE CASCADE,
    est_contact_principal BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (etudiant_id, parent_id)
);

-- ============================================================
-- SECTION 4 — INSCRIPTIONS & SCOLARITÉ
-- ============================================================

CREATE TABLE IF NOT EXISTS inscriptions (
    id                SERIAL PRIMARY KEY,
    etudiant_id       INT REFERENCES profils_etudiants(id),
    classe_id         INT REFERENCES classes(id),
    annee_scolaire_id INT REFERENCES annees_scolaires(id),
    type_inscription  VARCHAR(50) DEFAULT 'reinscription',
    date_inscription  DATE        DEFAULT CURRENT_DATE,
    statut            VARCHAR(50) DEFAULT 'active',
    rang_final        INT,
    est_admis         BOOLEAN,
    created_at        TIMESTAMP DEFAULT NOW(),
    updated_at        TIMESTAMP DEFAULT NOW(),
    UNIQUE (etudiant_id, annee_scolaire_id)
);

-- ============================================================
-- SECTION 5 — AFFECTATIONS D'ENSEIGNEMENT
-- ============================================================

CREATE TABLE IF NOT EXISTS affectations_enseignement (
    id                SERIAL PRIMARY KEY,
    professeur_id     INT REFERENCES profils_professeurs(id),
    matiere_id        INT REFERENCES matieres(id),
    classe_id         INT REFERENCES classes(id),
    annee_scolaire_id INT REFERENCES annees_scolaires(id),
    heures_hebdo      NUMERIC(4,1),
    created_at        TIMESTAMP DEFAULT NOW(),
    UNIQUE (matiere_id, classe_id, annee_scolaire_id)
);

-- ============================================================
-- SECTION 6 — EMPLOI DU TEMPS (avec horaire_edt)
-- ============================================================

CREATE TABLE IF NOT EXISTS emploi_du_temps (
    id                  SERIAL PRIMARY KEY,
    affectation_id      INT REFERENCES affectations_enseignement(id),
    salle_id            INT REFERENCES salles(id),
    jour_semaine        INT NOT NULL CHECK (jour_semaine BETWEEN 1 AND 6),
    heure_debut         TIME NOT NULL,
    heure_fin           TIME NOT NULL,
    date_debut_validite DATE,
    date_fin_validite   DATE,
    created_at          TIMESTAMP DEFAULT NOW()
);

-- Ajout de la colonne horaire_edt_id
ALTER TABLE emploi_du_temps ADD COLUMN IF NOT EXISTS horaire_edt_id INT;
ALTER TABLE emploi_du_temps ADD CONSTRAINT IF NOT EXISTS fk_emploi_du_temps_horaire_edt 
    FOREIGN KEY (horaire_edt_id) REFERENCES horaire_edt(id) ON DELETE SET NULL;

CREATE TABLE IF NOT EXISTS modifications_edt (
    id                   SERIAL PRIMARY KEY,
    emploi_du_temps_id   INT REFERENCES emploi_du_temps(id),
    date_concernee       DATE NOT NULL,
    portee               VARCHAR(20) DEFAULT 'ponctuel',
    type_modification    VARCHAR(50) NOT NULL,
    motif                VARCHAR(500),
    nouvelle_salle_id    INT REFERENCES salles(id),
    nouvelle_heure_debut TIME,
    nouvelle_heure_fin   TIME,
    remplacant_id        INT REFERENCES profils_professeurs(id),
    cree_par             INT REFERENCES users(id),
    created_at           TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- SECTION 7 — SÉANCES & ABSENCES
-- ============================================================

CREATE TABLE IF NOT EXISTS seances (
    id                 SERIAL PRIMARY KEY,
    emploi_du_temps_id INT REFERENCES emploi_du_temps(id),
    date_seance        DATE NOT NULL,
    heure_debut        TIME,
    heure_fin          TIME,
    a_eu_lieu          BOOLEAN DEFAULT TRUE,
    created_at         TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS absences (
    id               SERIAL PRIMARY KEY,
    seance_id        INT REFERENCES seances(id),
    etudiant_id      INT REFERENCES profils_etudiants(id),
    type             VARCHAR(50) DEFAULT 'non_justifiee',
    motif            TEXT,
    justificatif_url VARCHAR(500),
    saisi_par        INT REFERENCES users(id),
    valide_par       INT REFERENCES users(id),
    date_validation  TIMESTAMP,
    created_at       TIMESTAMP DEFAULT NOW(),
    updated_at       TIMESTAMP DEFAULT NOW(),
    UNIQUE (seance_id, etudiant_id)
);

-- ============================================================
-- SECTION 8 — NOTES & MOYENNES
-- ============================================================

CREATE TABLE IF NOT EXISTS notes (
    id              SERIAL PRIMARY KEY,
    etudiant_id     INT REFERENCES profils_etudiants(id),
    affectation_id  INT REFERENCES affectations_enseignement(id),
    periode_id      INT REFERENCES periodes(id),
    type_evaluation VARCHAR(100),
    valeur          NUMERIC(5,2) NOT NULL CHECK (valeur >= 0),
    sur             NUMERIC(5,2) DEFAULT 20.00,
    commentaire     TEXT,
    saisi_par       INT REFERENCES users(id),
    date_saisie     TIMESTAMP DEFAULT NOW(),
    est_valide      BOOLEAN DEFAULT TRUE,
    ancienne_valeur NUMERIC(5,2),
    corrige_par     INT REFERENCES users(id),
    date_correction TIMESTAMP,
    motif_correction TEXT,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS moyennes (
    id              SERIAL PRIMARY KEY,
    etudiant_id     INT REFERENCES profils_etudiants(id),
    inscription_id  INT REFERENCES inscriptions(id),
    periode_id      INT REFERENCES periodes(id),
    matiere_id      INT REFERENCES matieres(id),
    valeur          NUMERIC(5,2),
    rang            INT,
    effectif_classe INT,
    calculated_at   TIMESTAMP DEFAULT NOW(),
    UNIQUE (etudiant_id, inscription_id, periode_id, matiere_id)
);

-- ============================================================
-- SECTION 9 — FINANCE : RECETTES
-- ============================================================

CREATE TABLE IF NOT EXISTS grilles_tarifaires (
    id                SERIAL PRIMARY KEY,
    etablissement_id  INT REFERENCES etablissements(id),
    niveau_id         INT REFERENCES niveaux(id),
    annee_scolaire_id INT REFERENCES annees_scolaires(id),
    montant_total     NUMERIC(12,2) NOT NULL,
    description       TEXT,
    created_at        TIMESTAMP DEFAULT NOW(),
    UNIQUE (niveau_id, annee_scolaire_id)
);

CREATE TABLE IF NOT EXISTS echeanciers (
    id             SERIAL PRIMARY KEY,
    inscription_id INT REFERENCES inscriptions(id),
    grille_id      INT REFERENCES grilles_tarifaires(id),
    type           VARCHAR(50),
    montant_total  NUMERIC(12,2),
    created_at     TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS echeances (
    id               SERIAL PRIMARY KEY,
    echeancier_id    INT REFERENCES echeanciers(id) ON DELETE CASCADE,
    numero_tranche   INT NOT NULL,
    montant_attendu  NUMERIC(12,2) NOT NULL,
    date_limite      DATE NOT NULL,
    est_soldee       BOOLEAN DEFAULT FALSE,
    created_at       TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS paiements (
    id                    SERIAL PRIMARY KEY,
    echeance_id           INT REFERENCES echeances(id),
    inscription_id        INT REFERENCES inscriptions(id),
    montant               NUMERIC(12,2) NOT NULL,
    date_paiement         DATE NOT NULL,
    mode_paiement         VARCHAR(100),
    reference_transaction VARCHAR(200),
    saisi_par             INT REFERENCES users(id),
    notes                 TEXT,
    created_at            TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- SECTION 10 — FINANCE : DÉPENSES
-- ============================================================

CREATE TABLE IF NOT EXISTS categories_depenses (
    id          SERIAL PRIMARY KEY,
    parent_id   INT REFERENCES categories_depenses(id) ON DELETE SET NULL,
    nom         VARCHAR(150) NOT NULL,
    type_charge VARCHAR(20) DEFAULT 'variable',
    created_at  TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS fournisseurs (
    id               SERIAL PRIMARY KEY,
    etablissement_id INT REFERENCES etablissements(id),
    nom              VARCHAR(255) NOT NULL,
    type             VARCHAR(100),
    contact_nom      VARCHAR(200),
    telephone        VARCHAR(50),
    email            VARCHAR(255),
    adresse          TEXT,
    created_at       TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS contrats_charges (
    id               SERIAL PRIMARY KEY,
    etablissement_id INT REFERENCES etablissements(id),
    fournisseur_id   INT REFERENCES fournisseurs(id) ON DELETE SET NULL,
    categorie_id     INT REFERENCES categories_depenses(id),
    intitule         VARCHAR(255) NOT NULL,
    description      TEXT,
    type_recurrence  VARCHAR(50) NOT NULL,
    montant_prevu    NUMERIC(12,2) NOT NULL,
    jour_echeance    INT,
    date_debut       DATE NOT NULL,
    date_fin         DATE,
    statut           VARCHAR(50) DEFAULT 'actif',
    numero_contrat   VARCHAR(150),
    document_url     VARCHAR(500),
    cree_par         INT REFERENCES users(id),
    created_at       TIMESTAMP DEFAULT NOW(),
    updated_at       TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS echeances_contrats (
    id                SERIAL PRIMARY KEY,
    contrat_id        INT REFERENCES contrats_charges(id) ON DELETE CASCADE,
    periode_concernee VARCHAR(50) NOT NULL,
    date_echeance     DATE NOT NULL,
    montant_prevu     NUMERIC(12,2) NOT NULL,
    statut            VARCHAR(50) DEFAULT 'en_attente',
    created_at        TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS previsions_depenses (
    id                SERIAL PRIMARY KEY,
    etablissement_id  INT REFERENCES etablissements(id),
    annee_scolaire_id INT REFERENCES annees_scolaires(id),
    categorie_id      INT REFERENCES categories_depenses(id),
    fournisseur_id    INT REFERENCES fournisseurs(id) ON DELETE SET NULL,
    intitule          VARCHAR(255) NOT NULL,
    description       TEXT,
    montant_estime    NUMERIC(12,2) NOT NULL,
    date_prevue       DATE NOT NULL,
    type_charge       VARCHAR(20) NOT NULL,
    statut            VARCHAR(50) DEFAULT 'planifiee',
    approuve_par      INT REFERENCES users(id),
    date_approbation  TIMESTAMP,
    depense_id        INT,
    cree_par          INT REFERENCES users(id),
    created_at        TIMESTAMP DEFAULT NOW(),
    updated_at        TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS depenses (
    id                    SERIAL PRIMARY KEY,
    etablissement_id      INT REFERENCES etablissements(id),
    annee_scolaire_id     INT REFERENCES annees_scolaires(id),
    categorie_id          INT REFERENCES categories_depenses(id),
    fournisseur_id        INT REFERENCES fournisseurs(id) ON DELETE SET NULL,
    contrat_id            INT REFERENCES contrats_charges(id),
    echeance_contrat_id   INT REFERENCES echeances_contrats(id),
    prevision_id          INT REFERENCES previsions_depenses(id),
    intitule              VARCHAR(255) NOT NULL,
    type_charge           VARCHAR(20) NOT NULL,
    motif                 TEXT,
    montant               NUMERIC(12,2) NOT NULL,
    date_depense          DATE NOT NULL,
    mode_paiement         VARCHAR(100),
    reference             VARCHAR(200),
    justificatif_url      VARCHAR(500),
    necessite_approbation BOOLEAN DEFAULT FALSE,
    statut_approbation    VARCHAR(50) DEFAULT 'approuvee',
    approuve_par          INT REFERENCES users(id),
    date_approbation      TIMESTAMP,
    saisi_par             INT REFERENCES users(id),
    created_at            TIMESTAMP DEFAULT NOW(),
    updated_at            TIMESTAMP DEFAULT NOW()
);

ALTER TABLE previsions_depenses ADD CONSTRAINT IF NOT EXISTS fk_prevision_depense 
    FOREIGN KEY (depense_id) REFERENCES depenses(id) ON DELETE SET NULL;

CREATE TABLE IF NOT EXISTS budgets (
    id                SERIAL PRIMARY KEY,
    etablissement_id  INT REFERENCES etablissements(id),
    annee_scolaire_id INT REFERENCES annees_scolaires(id),
    categorie_id      INT REFERENCES categories_depenses(id),
    montant_prevu     NUMERIC(12,2) NOT NULL,
    created_by        INT REFERENCES users(id),
    created_at        TIMESTAMP DEFAULT NOW(),
    updated_at        TIMESTAMP DEFAULT NOW(),
    UNIQUE (annee_scolaire_id, categorie_id)
);

-- ============================================================
-- SECTION 11 — ÉVÉNEMENTS
-- ============================================================

CREATE TABLE IF NOT EXISTS evenements (
    id                    SERIAL PRIMARY KEY,
    etablissement_id      INT REFERENCES etablissements(id),
    titre                 VARCHAR(255) NOT NULL,
    description           TEXT,
    type                  VARCHAR(100),
    est_recurrente        BOOLEAN DEFAULT FALSE,
    type_recurrence       VARCHAR(20),
    jour_recurrence       INT CHECK (jour_recurrence BETWEEN 1 AND 31),
    mois_recurrence       INT CHECK (mois_recurrence BETWEEN 1 AND 12),
    duree_jours           INT DEFAULT 1,
    heure_debut_defaut    TIME,
    heure_fin_defaut      TIME,
    annule_cours          BOOLEAN DEFAULT FALSE,
    concerne_toute_ecole  BOOLEAN DEFAULT TRUE,
    concerne_matiere_id   INT REFERENCES matieres(id),
    cree_par              INT REFERENCES users(id),
    created_at            TIMESTAMP DEFAULT NOW(),
    updated_at            TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS evenements_instances (
    id                SERIAL PRIMARY KEY,
    evenement_id      INT REFERENCES evenements(id) ON DELETE CASCADE,
    annee_scolaire_id INT REFERENCES annees_scolaires(id),
    classe_id         INT REFERENCES classes(id),
    date_debut        DATE NOT NULL,
    date_fin          DATE,
    heure_debut       TIME,
    heure_fin         TIME,
    salle_id          INT REFERENCES salles(id),
    lieu_externe      VARCHAR(255),
    statut            VARCHAR(50) DEFAULT 'planifie',
    notes             TEXT,
    cree_par          INT REFERENCES users(id),
    created_at        TIMESTAMP DEFAULT NOW(),
    updated_at        TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- SECTION 12 — NOTIFICATIONS
-- ============================================================

CREATE TABLE IF NOT EXISTS notification_types (
    id               SERIAL PRIMARY KEY,
    code             VARCHAR(100) UNIQUE NOT NULL,
    libelle          VARCHAR(255),
    template_message TEXT
);

CREATE TABLE IF NOT EXISTS notifications (
    id           SERIAL PRIMARY KEY,
    user_id      INT REFERENCES users(id) ON DELETE CASCADE,
    type_id      INT REFERENCES notification_types(id),
    titre        VARCHAR(255) NOT NULL,
    message      TEXT NOT NULL,
    lien_action  VARCHAR(500),
    est_lu       BOOLEAN   DEFAULT FALSE,
    date_lecture TIMESTAMP,
    entite_type  VARCHAR(100),
    entite_id    INT,
    created_at   TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- SECTION 13 — DOCUMENTS GÉNÉRÉS
-- ============================================================

CREATE TABLE IF NOT EXISTS documents (
    id                SERIAL PRIMARY KEY,
    etudiant_id       INT REFERENCES profils_etudiants(id),
    type_document     VARCHAR(100) NOT NULL,
    titre             VARCHAR(255),
    fichier_url       VARCHAR(500),
    annee_scolaire_id INT REFERENCES annees_scolaires(id),
    periode_id        INT REFERENCES periodes(id),
    genere_par        INT REFERENCES users(id),
    genere_le         TIMESTAMP DEFAULT NOW(),
    est_valide        BOOLEAN DEFAULT TRUE
);

-- ============================================================
-- SECTION 14 — WORKFLOW MODIFICATIONS
-- ============================================================

CREATE TABLE IF NOT EXISTS demandes_modification_dossier (
    id              SERIAL PRIMARY KEY,
    etudiant_id     INT REFERENCES profils_etudiants(id),
    champ_modifie   VARCHAR(150) NOT NULL,
    ancienne_valeur TEXT,
    nouvelle_valeur TEXT,
    motif           TEXT,
    statut          VARCHAR(50) DEFAULT 'en_attente',
    soumis_par      INT REFERENCES users(id),
    traite_par      INT REFERENCES users(id),
    date_traitement TIMESTAMP,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- SECTION 15 — JOURNAL D'AUDIT
-- ============================================================

CREATE TABLE IF NOT EXISTS audit_log (
    id                SERIAL PRIMARY KEY,
    user_id           INT REFERENCES users(id) ON DELETE SET NULL,
    action            VARCHAR(200) NOT NULL,
    table_concernee   VARCHAR(100),
    entite_id         INT,
    anciennes_valeurs JSONB,
    nouvelles_valeurs JSONB,
    ip_address        VARCHAR(45),
    user_agent        VARCHAR(500),
    created_at        TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- SECTION 16 — INDEX DE PERFORMANCE
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_user_roles_user ON user_roles(user_id);
CREATE INDEX IF NOT EXISTS idx_etudiants_matricule ON profils_etudiants(matricule);
CREATE INDEX IF NOT EXISTS idx_professeurs_matricule ON profils_professeurs(matricule);
CREATE INDEX IF NOT EXISTS idx_classes_niveau_annee ON classes(niveau_id, annee_scolaire_id);
CREATE INDEX IF NOT EXISTS idx_affectation_prof ON affectations_enseignement(professeur_id);
CREATE INDEX IF NOT EXISTS idx_affectation_classe_annee ON affectations_enseignement(classe_id, annee_scolaire_id);
CREATE INDEX IF NOT EXISTS idx_inscriptions_etudiant ON inscriptions(etudiant_id);
CREATE INDEX IF NOT EXISTS idx_inscriptions_classe ON inscriptions(classe_id);
CREATE INDEX IF NOT EXISTS idx_inscriptions_annee ON inscriptions(annee_scolaire_id);
CREATE INDEX IF NOT EXISTS idx_edt_affectation ON emploi_du_temps(affectation_id);
CREATE INDEX IF NOT EXISTS idx_edt_validite ON emploi_du_temps(date_debut_validite, date_fin_validite);
CREATE INDEX IF NOT EXISTS idx_horaire_edt_ordre ON horaire_edt(ordre);
CREATE INDEX IF NOT EXISTS idx_edt_horaire ON emploi_du_temps(horaire_edt_id);
CREATE INDEX IF NOT EXISTS idx_classes_salle ON classes(salle_id);
CREATE INDEX IF NOT EXISTS idx_modif_edt_date ON modifications_edt(emploi_du_temps_id, date_concernee);
CREATE INDEX IF NOT EXISTS idx_seances_date ON seances(date_seance);
CREATE INDEX IF NOT EXISTS idx_notes_etudiant ON notes(etudiant_id);
CREATE INDEX IF NOT EXISTS idx_notes_affectation ON notes(affectation_id);
CREATE INDEX IF NOT EXISTS idx_notes_periode ON notes(periode_id);
CREATE INDEX IF NOT EXISTS idx_moyennes_etudiant ON moyennes(etudiant_id, inscription_id);
CREATE INDEX IF NOT EXISTS idx_absences_etudiant ON absences(etudiant_id);
CREATE INDEX IF NOT EXISTS idx_absences_seance ON absences(seance_id);
CREATE INDEX IF NOT EXISTS idx_paiements_inscription ON paiements(inscription_id);
CREATE INDEX IF NOT EXISTS idx_echeances_echeancier ON echeances(echeancier_id);
CREATE INDEX IF NOT EXISTS idx_echeances_date_limite ON echeances(date_limite);
CREATE INDEX IF NOT EXISTS idx_depenses_annee ON depenses(annee_scolaire_id);
CREATE INDEX IF NOT EXISTS idx_depenses_categorie ON depenses(categorie_id);
CREATE INDEX IF NOT EXISTS idx_depenses_date ON depenses(date_depense);
CREATE INDEX IF NOT EXISTS idx_depenses_statut ON depenses(statut_approbation);
CREATE INDEX IF NOT EXISTS idx_echeances_contrats_contrat ON echeances_contrats(contrat_id);
CREATE INDEX IF NOT EXISTS idx_echeances_contrats_statut ON echeances_contrats(statut, date_echeance);
CREATE INDEX IF NOT EXISTS idx_previsions_annee ON previsions_depenses(annee_scolaire_id, statut);
CREATE INDEX IF NOT EXISTS idx_budgets_annee ON budgets(annee_scolaire_id);
CREATE INDEX IF NOT EXISTS idx_evenements_recurrence ON evenements(est_recurrente, type_recurrence);
CREATE INDEX IF NOT EXISTS idx_evt_instances_annee ON evenements_instances(annee_scolaire_id);
CREATE INDEX IF NOT EXISTS idx_evt_instances_date ON evenements_instances(date_debut);
CREATE INDEX IF NOT EXISTS idx_evt_instances_statut ON evenements_instances(statut);
CREATE INDEX IF NOT EXISTS idx_notif_user_lu ON notifications(user_id, est_lu);
CREATE INDEX IF NOT EXISTS idx_notif_created ON notifications(created_at);
CREATE INDEX IF NOT EXISTS idx_audit_user ON audit_log(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_table_entite ON audit_log(table_concernee, entite_id);
CREATE INDEX IF NOT EXISTS idx_audit_date ON audit_log(created_at);

-- ============================================================
-- SECTION 17 — DONNÉES INITIALES (SEED)
-- ============================================================

INSERT INTO roles (nom, description) VALUES
    ('super_admin',  'Accès total, gestion technique du système'),
    ('directeur',    'Pilotage pédagogique et financier, validation'),
    ('secretariat',  'Inscriptions, dossiers, finance opérationnelle'),
    ('comptable',    'Finances, paiements, rapports financiers'),
    ('professeur',   'Saisie notes, absences, emploi du temps'),
    ('etudiant',     'Consultation notes, dossier, emploi du temps'),
    ('parent',       'Consultation dossier enfant, notifications')
ON CONFLICT (nom) DO NOTHING;

INSERT INTO notification_types (code, libelle, template_message) VALUES
    ('notes_publiees',        'Notes disponibles',              'Vos notes du {periode} sont maintenant disponibles.'),
    ('baisse_notes_alerte',   'Alerte baisse de notes',         'Votre moyenne en {matiere} a baissé significativement.'),
    ('absence_frequente',     'Absences fréquentes',            'Votre taux d''absence dépasse {seuil}%. Veuillez régulariser.'),
    ('echeance_approchante',  'Échéance de paiement proche',    'Un paiement de {montant} Ar est attendu avant le {date}.'),
    ('edt_modifie',           'Emploi du temps modifié',        'Le cours de {matiere} du {date} a été modifié : {motif}.'),
    ('evenement_confirme',    'Nouvel événement au calendrier', 'L''événement "{titre}" est prévu le {date}.'),
    ('document_disponible',   'Document prêt',                  'Votre {type_document} est disponible au téléchargement.'),
    ('depense_a_approuver',   'Dépense en attente d''approbation', 'Une dépense urgente de {montant} Ar attend votre validation.'),
    ('budget_depasse',        'Dépassement budgétaire',         'Le budget "{categorie}" est dépassé de {ecart} Ar.')
ON CONFLICT (code) DO NOTHING;

INSERT INTO categories_depenses (parent_id, nom, type_charge) VALUES
    (NULL, 'Ressources Humaines', 'fixe'),
    (NULL, 'Infrastructure',      'fixe'),
    (NULL, 'Pédagogie',           'variable'),
    (NULL, 'Administratif',       'variable'),
    (NULL, 'Événements',          'variable')
ON CONFLICT DO NOTHING;

-- Insertion des plages horaires standards
INSERT INTO horaire_edt (libelle, heure_debut, heure_fin, ordre) VALUES
    ('07h00 - 08h00', '07:00', '08:00', 1),
    ('08h00 - 09h00', '08:00', '09:00', 2),
    ('09h00 - 10h00', '09:00', '10:00', 3),
    ('10h00 - 11h00', '10:00', '11:00', 4),
    ('11h00 - 12h00', '11:00', '12:00', 5),
    ('13h00 - 14h00', '13:00', '14:00', 6),
    ('14h00 - 15h00', '14:00', '15:00', 7),
    ('15h00 - 16h00', '15:00', '16:00', 8),
    ('16h00 - 17h00', '16:00', '17:00', 9)
ON CONFLICT (heure_debut, heure_fin) DO NOTHING;

-- Mise à jour des horaires existants dans emploi_du_temps
UPDATE emploi_du_temps e
SET horaire_edt_id = h.id
FROM horaire_edt h
WHERE e.horaire_edt_id IS NULL
  AND e.heure_debut = h.heure_debut
  AND e.heure_fin = h.heure_fin;

COMMIT;

-- ============================================================
-- FIN DU SCHÉMA COMPLET
-- ============================================================





SELECT * FROM  