-- ============================================================
-- CRÉATION DE LA BASE
-- ============================================================
DROP DATABASE IF EXISTS lycee_management;
CREATE DATABASE lycee_management;
\c lycee_management;

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
-- SECTION 3 — PROFILS
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
    updated_at        TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- SECTION 5 — MATIERES & PERIODES
-- ============================================================

CREATE TABLE matieres (
    id          SERIAL PRIMARY KEY,
    code_matiere VARCHAR(20) NOT NULL UNIQUE,
    intitule    VARCHAR(150) NOT NULL,
    coefficient NUMERIC(4,2) NOT NULL DEFAULT 1 CHECK (coefficient > 0),
    unite       VARCHAR(50),
    niveau      VARCHAR(30),
    serie       VARCHAR(30),
    id_prof INT REFERENCES profils_professeurs(id),
    created_at  TIMESTAMP DEFAULT NOW()
);
ALTER TABLE matieres
ADD COLUMN id_prof INT REFERENCES profils_professeurs(id);
UPDATE matiere set id_prof = 1 WHERE ;
CREATE TABLE periodes (
    id                 SERIAL PRIMARY KEY,
    libelle            VARCHAR(60) NOT NULL,
    type_periode       VARCHAR(20) NOT NULL CHECK (type_periode IN ('trimestre','semestre','annuel')),
    date_debut         DATE NOT NULL,
    date_fin           DATE NOT NULL,
    annee_scolaire_id  INT NOT NULL REFERENCES annees_scolaires(id),
    created_at         TIMESTAMP DEFAULT NOW(),
    CHECK (date_fin > date_debut)
);

-- ============================================================
-- SECTION 6 — EMPLOI DU TEMPS & SEANCES
-- ============================================================

CREATE TABLE emploi_du_temps (
    id                SERIAL PRIMARY KEY,
    classe_id         INT NOT NULL REFERENCES classes(id),
    periode_id        INT NOT NULL REFERENCES periodes(id),
    created_at        TIMESTAMP DEFAULT NOW()
);

CREATE TABLE seances (
    id                SERIAL PRIMARY KEY,
    emploi_du_temps_id INT NOT NULL REFERENCES emploi_du_temps(id) ON DELETE CASCADE,
    jour_semaine       VARCHAR(10) NOT NULL,
    heure_debut        TIME NOT NULL,
    heure_fin          TIME NOT NULL,
    matiere_id         INT NOT NULL REFERENCES matieres(id),
    professeur_id      INT NOT NULL REFERENCES profils_professeurs(id),
    salle_id           INT REFERENCES salles(id),
    est_annule         BOOLEAN DEFAULT FALSE,
    created_at         TIMESTAMP DEFAULT NOW(),
    CHECK (heure_fin > heure_debut)
);

-- ============================================================
-- SECTION 7 — ABSENCES
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
-- SECTION 8 — NOTES & MOYENNES
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
-- SECTION 9 — DEVOIRS & LEÇONS
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
-- SECTION 10 — DOCUMENTS GÉNÉRÉS
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
-- SECTION 11 — DEMANDES MODIFICATION DOSSIER
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
-- SECTION 12 — NOTIFICATIONS
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

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_etudiants_matricule ON profils_etudiants(matricule);
CREATE INDEX idx_professeurs_matricule ON profils_professeurs(matricule);
CREATE INDEX idx_classes_niveau_annee ON classes(niveau_id, annee_scolaire_id);
CREATE INDEX idx_inscriptions_etudiant ON inscriptions(etudiant_id);
CREATE INDEX idx_inscriptions_classe ON inscriptions(classe_id);
CREATE INDEX idx_inscriptions_annee ON inscriptions(annee_scolaire_id);
CREATE INDEX idx_notes_etudiant ON notes(etudiant_id);
CREATE INDEX idx_notes_periode ON notes(periode_id);
CREATE INDEX idx_moyennes_etudiant ON moyennes(etudiant_id, inscription_id);
CREATE INDEX idx_absences_etudiant ON absences(etudiant_id);
CREATE INDEX idx_absences_seance ON absences(seance_id);
CREATE INDEX idx_devoirs_classe ON devoirs_lecons(classe_id);
CREATE INDEX idx_notif_user_lu ON notifications(user_id, est_lu);

-- ============================================================
-- DONNÉES INITIALES (ROLES)
-- ============================================================

INSERT INTO roles (nom, description) VALUES
    ('professeur', 'Saisie notes, absences, emploi du temps'),
    ('etudiant', 'Consultation notes, dossier, emploi du temps'),
    ('parent', 'Consultation dossier enfant, notifications');

-- ============================================================
-- INSERTION DES DONNÉES DE TEST
-- ============================================================

-- Établissement
INSERT INTO etablissements (nom, adresse, telephone, email) VALUES
('Lycée Moderne', 'Antananarivo', '034 00 000 00', 'contact@lycee.mg');

-- Année scolaire
INSERT INTO annees_scolaires (etablissement_id, libelle, date_debut, date_fin, est_active) VALUES
(1, '2024-2025', '2024-09-01', '2025-06-30', TRUE);

-- Niveaux
INSERT INTO niveaux (etablissement_id, libelle, ordre) VALUES
(1, 'Seconde', 1),
(1, 'Première', 2),
(1, 'Terminale', 3);

-- Classes
INSERT INTO classes (niveau_id, annee_scolaire_id, nom, capacite_max) VALUES
(1, 1, 'Seconde A', 35),
(2, 1, 'Première C', 30),
(3, 1, 'Terminale D', 30);

-- Salles
INSERT INTO salles (etablissement_id, nom, capacite, type) VALUES
(1, 'Salle 101', 40, 'cours'),
(1, 'Salle 102', 35, 'cours'),
(1, 'Labo SVT', 25, 'laboratoire');

-- Matières
INSERT INTO matieres (code_matiere, intitule, coefficient) VALUES
('MATH', 'Mathématiques', 4),
('PC', 'Physique-Chimie', 3),
('FR', 'Français', 3),
('ANG', 'Anglais', 2);

-- Utilisateurs (mot de passe = '123456')
INSERT INTO users (email, password_hash, is_active) VALUES
('rakoto.john@student.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
('rasoa.mary@student.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
('rabe.prof@school.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
('rasamuel.prof@school.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE);

-- Rôles utilisateurs
INSERT INTO user_roles (user_id, role_id) VALUES
(1, (SELECT id FROM roles WHERE nom = 'etudiant')),
(2, (SELECT id FROM roles WHERE nom = 'etudiant')),
(3, (SELECT id FROM roles WHERE nom = 'professeur')),
(4, (SELECT id FROM roles WHERE nom = 'professeur'));

-- Profils étudiants
INSERT INTO profils_etudiants (user_id, matricule, nom, prenom) VALUES
(1, '2024001', 'RAKOTO', 'John'),
(2, '2024002', 'RASOA', 'Mary');

-- Profils professeurs
INSERT INTO profils_professeurs (user_id, matricule, nom, prenom, specialite) VALUES
(3, 'PROF001', 'RABE', 'Paul', 'Mathématiques'),
(4, 'PROF002', 'RASAMUEL', 'Claire', 'Physique-Chimie');

-- Inscriptions
INSERT INTO inscriptions (etudiant_id, classe_id, annee_scolaire_id, statut) VALUES
(1, 3, 1, 'active'),
(2, 2, 1, 'active');

-- Périodes
INSERT INTO periodes (libelle, type_periode, date_debut, date_fin, annee_scolaire_id) VALUES
('1er Trimestre 2024-2025', 'trimestre', '2024-09-01', '2024-11-30', 1),
('2ème Trimestre 2024-2025', 'trimestre', '2024-12-01', '2025-02-28', 1),
('3ème Trimestre 2024-2025', 'trimestre', '2025-03-01', '2025-05-31', 1);

-- Emplois du temps
INSERT INTO emploi_du_temps (classe_id, periode_id) VALUES
(3, 1),  -- Terminale D - Période 1
(3, 2),  -- Terminale D - Période 2
(3, 3),  -- Terminale D - Période 3
(2, 1),  -- Première C - Période 1
(2, 2),  -- Première C - Période 2
(2, 3);  -- Première C - Période 3

-- Séances pour Terminale D - Période 1 (emploi_du_temps_id = 1)
INSERT INTO seances (emploi_du_temps_id, jour_semaine, heure_debut, heure_fin, matiere_id, professeur_id, salle_id) VALUES
(1, 'Lundi',    '08:00:00', '10:00:00', 1, 3, 1),
(1, 'Mardi',    '08:00:00', '10:00:00', 2, 4, 2),
(1, 'Mercredi', '10:00:00', '12:00:00', 3, 3, 1),
(1, 'Jeudi',    '08:00:00', '10:00:00', 1, 3, 1),
(1, 'Vendredi', '08:00:00', '10:00:00', 4, 3, 1);

-- Séances pour Première C - Période 1 (emploi_du_temps_id = 4)
INSERT INTO seances (emploi_du_temps_id, jour_semaine, heure_debut, heure_fin, matiere_id, professeur_id, salle_id) VALUES
(4, 'Lundi',    '08:00:00', '10:00:00', 1, 3, 1),
(4, 'Mercredi', '08:00:00', '10:00:00', 1, 3, 1),
(4, 'Jeudi',    '10:00:00', '12:00:00', 3, 3, 1),
(4, 'Vendredi', '08:00:00', '10:00:00', 4, 3, 1);

-- Notes
INSERT INTO notes (valeur, type_evaluation, date_evaluation, etudiant_id, matiere_id, professeur_id, periode_id) VALUES
(15, 'devoir', '2024-09-20', 1, 1, 3, 1),
(14, 'devoir', '2024-09-22', 1, 2, 4, 1),
(16, 'interrogation', '2024-09-25', 1, 3, 3, 1),
(13, 'devoir', '2024-09-20', 2, 1, 3, 1),
(15, 'devoir', '2024-09-23', 2, 4, 3, 1);

-- Documents
INSERT INTO documents (etudiant_id, type_document, titre, annee_scolaire_id, periode_id) VALUES
(1, 'releve_notes', 'Relevé T1 2024-2025', 1, 1),
(2, 'releve_notes', 'Relevé T1 2024-2025', 1, 1);

-- Notifications
INSERT INTO notification_types (code, libelle, template_message) VALUES
('notes_publiees', 'Notes disponibles', 'Vos notes sont disponibles');

INSERT INTO notifications (user_id, type_id, titre, message) VALUES
(1, 1, 'Notes disponibles', 'Vos notes du trimestre sont consultables'),
(2, 1, 'Notes disponibles', 'Vos notes du trimestre sont consultables');

-- ============================================================
-- FIN
-- ============================================================
\echo '============================================================'
\echo 'Base de données créée avec succès !'
\echo '============================================================'
\echo 'Comptes de test :'
\echo '  Étudiant: rakoto.john@student.mg / 123456'
\echo '  Étudiant: rasoa.mary@student.mg / 123456'
\echo '  Professeur: rabe.prof@school.mg / 123456'
\echo '  Professeur: rasamuel.prof@school.mg / 123456'
\echo '============================================================'

SELECT * FROM notes 
JOIN periodes ON notes.periode_id = periodes.id 
JOIN annees_scolaires ON periodes.annee_scolaire_id = annees_scolaires.id 
JOIN matieres ON notes.matiere_id = matieres.id
WHERE etudiant_id = 1 AND annees_scolaires.id = 1 AND periodes.id = 1;

SELECT * FROM periodes WHERE annee_scolaire_id = 1 GROUP BY id;