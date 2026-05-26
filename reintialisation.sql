-- ============================================================
-- RÉINITIALISATION COMPLÈTE DE LA BASE
-- ============================================================

-- 1. Supprimer les données dans l'ordre des dépendances
DELETE FROM notifications;
DELETE FROM notification_types;
DELETE FROM demandes_modification_dossier;
DELETE FROM documents;
DELETE FROM devoirs_lecons;
DELETE FROM moyennes;
DELETE FROM notes;
DELETE FROM absences;
DELETE FROM seances;
DELETE FROM emploi_du_temps;
DELETE FROM periodes;
DELETE FROM inscriptions;
DELETE FROM etudiants_parents;
DELETE FROM profils_parents;
DELETE FROM profils_professeurs;
DELETE FROM profils_etudiants;
DELETE FROM user_roles;
DELETE FROM users;
DELETE FROM classes;
DELETE FROM niveaux;
DELETE FROM salles;
DELETE FROM annees_scolaires;
DELETE FROM etablissements;
DELETE FROM matieres;
DELETE FROM roles;

-- 2. Réinitialiser les séquences (index à 1)
ALTER SEQUENCE etablissements_id_seq RESTART WITH 1;
ALTER SEQUENCE annees_scolaires_id_seq RESTART WITH 1;
ALTER SEQUENCE niveaux_id_seq RESTART WITH 1;
ALTER SEQUENCE classes_id_seq RESTART WITH 1;
ALTER SEQUENCE salles_id_seq RESTART WITH 1;
ALTER SEQUENCE matieres_id_seq RESTART WITH 1;
ALTER SEQUENCE users_id_seq RESTART WITH 1;
ALTER SEQUENCE profils_etudiants_id_seq RESTART WITH 1;
ALTER SEQUENCE profils_professeurs_id_seq RESTART WITH 1;
ALTER SEQUENCE profils_parents_id_seq RESTART WITH 1;
ALTER SEQUENCE inscriptions_id_seq RESTART WITH 1;
ALTER SEQUENCE periodes_id_seq RESTART WITH 1;
ALTER SEQUENCE emploi_du_temps_id_seq RESTART WITH 1;
ALTER SEQUENCE seances_id_seq RESTART WITH 1;
ALTER SEQUENCE notes_id_note_seq RESTART WITH 1;
ALTER SEQUENCE moyennes_id_seq RESTART WITH 1;
ALTER SEQUENCE absences_id_seq RESTART WITH 1;
ALTER SEQUENCE devoirs_lecons_id_devoir_seq RESTART WITH 1;
ALTER SEQUENCE documents_id_seq RESTART WITH 1;
ALTER SEQUENCE demandes_modification_dossier_id_seq RESTART WITH 1;
ALTER SEQUENCE notification_types_id_seq RESTART WITH 1;
ALTER SEQUENCE notifications_id_seq RESTART WITH 1;
ALTER SEQUENCE roles_id_seq RESTART WITH 1;

-- 3. Remplir les rôles
INSERT INTO roles (id, nom, description) VALUES
(1, 'professeur', 'Saisie notes, absences, emploi du temps'),
(2, 'etudiant', 'Consultation notes, dossier, emploi du temps'),
(3, 'parent', 'Consultation dossier enfant, notifications');

-- 4. Réinitialiser les séquences des rôles
ALTER SEQUENCE roles_id_seq RESTART WITH 4;

-- ============================================================
-- FIN DE LA RÉINITIALISATION
-- ============================================================
\echo 'Base réinitialisée avec succès !'
\echo 'Toutes les tables sont vides et les index repartent de 1'