CREATE DATABASE lycee_management;
\c lycee_management;

-- ============================================================
-- PARTIE ÉTUDIANT (extraite du schéma complet)
-- PostgreSQL
-- ============================================================

-- ============================================================
-- SECTION 1 — AUTHENTIFICATION
-- ============================================================

CREATE TABLE users (
    id            SERIAL PRIMARY KEY,
    email         VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_active     BOOLEAN DEFAULT TRUE,
    last_login    TIMESTAMP,
    created_at    TIMESTAMP DEFAULT NOW(),
    updated_at    TIMESTAMP DEFAULT NOW()
);

CREATE TABLE roles (
    id          SERIAL PRIMARY KEY,
    nom         VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at  TIMESTAMP DEFAULT NOW()
);

CREATE TABLE user_roles (
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    role_id INT REFERENCES roles(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);

-- ============================================================
-- SECTION 2 — STRUCTURE DE L'ÉTABLISSEMENT
-- ============================================================

CREATE TABLE etablissements (
    id           SERIAL PRIMARY KEY,
    nom          VARCHAR(255) NOT NULL,
    adresse      TEXT,
    telephone    VARCHAR(50),
    email        VARCHAR(255),
    logo_url     VARCHAR(500),
    created_at   TIMESTAMP DEFAULT NOW()
);

CREATE TABLE annees_scolaires (
    id               SERIAL PRIMARY KEY,
    etablissement_id INT REFERENCES etablissements(id),
    libelle          VARCHAR(50) NOT NULL,
    date_debut       DATE NOT NULL,
    date_fin         DATE NOT NULL,
    est_active       BOOLEAN DEFAULT FALSE,
    created_at       TIMESTAMP DEFAULT NOW()
);

CREATE TABLE niveaux (
    id               SERIAL PRIMARY KEY,
    etablissement_id INT REFERENCES etablissements(id),
    libelle          VARCHAR(100) NOT NULL,
    ordre            INT NOT NULL,
    created_at       TIMESTAMP DEFAULT NOW()
);

CREATE TABLE classes (
    id                SERIAL PRIMARY KEY,
    niveau_id         INT REFERENCES niveaux(id),
    annee_scolaire_id INT REFERENCES annees_scolaires(id),
    nom               VARCHAR(100) NOT NULL,
    capacite_max      INT DEFAULT 40,
    created_at        TIMESTAMP DEFAULT NOW()
);

CREATE TABLE salles (
    id               SERIAL PRIMARY KEY,
    etablissement_id INT REFERENCES etablissements(id),
    nom              VARCHAR(100) NOT NULL,
    capacite         INT,
    type             VARCHAR(50) DEFAULT 'cours',
    is_active        BOOLEAN DEFAULT TRUE,
    created_at       TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- SECTION 3 — PROFILS (étudiant, parent, professeur)
-- ============================================================

CREATE TABLE profils_etudiants (
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

CREATE TABLE profils_professeurs (
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

CREATE TABLE profils_parents (
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

CREATE TABLE etudiants_parents (
    etudiant_id           INT REFERENCES profils_etudiants(id) ON DELETE CASCADE,
    parent_id             INT REFERENCES profils_parents(id) ON DELETE CASCADE,
    est_contact_principal BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (etudiant_id, parent_id)
);

-- ============================================================
-- SECTION 4 — INSCRIPTIONS
-- ============================================================

CREATE TABLE inscriptions (
    id                SERIAL PRIMARY KEY,
    etudiant_id       INT REFERENCES profils_etudiants(id),
    classe_id         INT REFERENCES classes(id),
    annee_scolaire_id INT REFERENCES annees_scolaires(id),
    type_inscription  VARCHAR(50) DEFAULT 'reinscription',
    date_inscription  DATE DEFAULT CURRENT_DATE,
    statut            VARCHAR(50) DEFAULT 'active',
    rang_final        INT,
    est_admis         BOOLEAN,
    created_at        TIMESTAMP DEFAULT NOW(),
    updated_at        TIMESTAMP DEFAULT NOW(),
    UNIQUE (etudiant_id, annee_scolaire_id)
);

-- ============================================================
-- SECTION 5 — MATIERES & PERIODES (CORRIGÉ : SERIAL au lieu de UUID)
-- ============================================================

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

-- ============================================================
-- SECTION 6 — EMPLOI DU TEMPS (CORRIGÉ : INT au lieu de UUID)
-- ============================================================

CREATE TABLE emploi_du_temps (
    id                SERIAL PRIMARY KEY,
    jour_semaine      VARCHAR(10) NOT NULL CHECK (jour_semaine IN ('Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi')),
    heure_debut       TIME NOT NULL,
    heure_fin         TIME NOT NULL,
    date DATE NOT NULL,
    annee_scolaire    SMALLINT NOT NULL,
    classe_id         INT REFERENCES classes(id) ON DELETE CASCADE,
    matiere_id        INT REFERENCES matieres(id) ON DELETE RESTRICT,
    professeur_id     INT REFERENCES profils_professeurs(id) ON DELETE RESTRICT,
    salle_id          INT REFERENCES salles(id) ON DELETE SET NULL,
    created_at        TIMESTAMP DEFAULT NOW(),
    CHECK (heure_fin > heure_debut)
);

-- ============================================================
-- SECTION 7 — ABSENCES (CORRIGÉ : INT au lieu de UUID)
-- ============================================================

CREATE TABLE absences (
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
-- SECTION 8 — NOTES & MOYENNES (CORRIGÉ : INT au lieu de UUID)
-- ============================================================

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

CREATE TABLE moyennes (
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
-- SECTION 9 — DEVOIRS & LEÇONS (CORRIGÉ : INT au lieu de UUID)
-- ============================================================

CREATE TABLE devoirs_lecons (
    id_devoir        SERIAL PRIMARY KEY,
    titre            VARCHAR(200) NOT NULL,
    type             VARCHAR(20) NOT NULL CHECK (type IN ('devoir','leçon','exercice','projet','révision')),
    description      TEXT,
    date_publication DATE NOT NULL DEFAULT CURRENT_DATE,
    date_remise      DATE,
    fichier_url      TEXT,
    matiere_id       INT REFERENCES matieres(id) ON DELETE RESTRICT,
    classe_id        INT REFERENCES classes(id) ON DELETE CASCADE,
    professeur_id    INT REFERENCES profils_professeurs(id) ON DELETE RESTRICT,
    created_at       TIMESTAMP DEFAULT NOW(),
    updated_at       TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- SECTION 10 — MODIFICATIONS EDT
-- ============================================================

CREATE TABLE modifications_edt (
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
-- SECTION 11 — DOCUMENTS GÉNÉRÉS
-- ============================================================

CREATE TABLE documents (
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
-- SECTION 12 — DEMANDES MODIFICATION DOSSIER
-- ============================================================

CREATE TABLE demandes_modification_dossier (
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
-- SECTION 13 — NOTIFICATIONS (optionnel mais utile pour étudiant)
-- ============================================================

CREATE TABLE notification_types (
    id               SERIAL PRIMARY KEY,
    code             VARCHAR(100) UNIQUE NOT NULL,
    libelle          VARCHAR(255),
    template_message TEXT
);

CREATE TABLE notifications (
    id           SERIAL PRIMARY KEY,
    user_id      INT REFERENCES users(id) ON DELETE CASCADE,
    type_id      INT REFERENCES notification_types(id),
    titre        VARCHAR(255) NOT NULL,
    message      TEXT NOT NULL,
    lien_action  VARCHAR(500),
    est_lu       BOOLEAN DEFAULT FALSE,
    date_lecture TIMESTAMP,
    entite_type  VARCHAR(100),
    entite_id    INT,
    created_at   TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- INDEX
-- ============================================================

CREATE INDEX idx_users_email                ON users(email);
CREATE INDEX idx_etudiants_matricule        ON profils_etudiants(matricule);
CREATE INDEX idx_professeurs_matricule      ON profils_professeurs(matricule);
CREATE INDEX idx_classes_niveau_annee       ON classes(niveau_id, annee_scolaire_id);
CREATE INDEX idx_inscriptions_etudiant      ON inscriptions(etudiant_id);
CREATE INDEX idx_inscriptions_classe        ON inscriptions(classe_id);
CREATE INDEX idx_inscriptions_annee         ON inscriptions(annee_scolaire_id);
CREATE INDEX idx_notes_etudiant             ON notes(etudiant_id);
CREATE INDEX idx_notes_periode              ON notes(periode_id);
CREATE INDEX idx_moyennes_etudiant          ON moyennes(etudiant_id, inscription_id);
CREATE INDEX idx_absences_etudiant          ON absences(etudiant_id);
CREATE INDEX idx_absences_seance            ON absences(seance_id);
CREATE INDEX idx_seances_date               ON seances(date_seance);
CREATE INDEX idx_devoirs_classe             ON devoirs_lecons(classe_id);
CREATE INDEX idx_notif_user_lu              ON notifications(user_id, est_lu);

-- ============================================================
-- DONNÉES INITIALES
-- ============================================================

INSERT INTO roles (nom, description) VALUES
    ('professeur',   'Saisie notes, absences, emploi du temps'),
    ('etudiant',     'Consultation notes, dossier, emploi du temps'),
    ('parent',       'Consultation dossier enfant, notifications');

-- ============================================================
-- FIN
-- ============================================================