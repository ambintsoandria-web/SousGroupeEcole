-- ============================================================
-- INSERTION DES DONNÉES DE TEST
-- ============================================================

-- 1. Établissement
INSERT INTO etablissements (nom, adresse, telephone, email) VALUES
('Lycée Moderne Andohalo', 'BP 123, Andohalo, Antananarivo', '034 12 345 67', 'contact@lycee-andohalo.mg');

-- 2. Année scolaire (active)
INSERT INTO annees_scolaires (etablissement_id, libelle, date_debut, date_fin, est_active) VALUES
(1, '2024-2025', '2024-09-01', '2025-06-30', TRUE);

-- 3. Niveaux
INSERT INTO niveaux (etablissement_id, libelle, ordre) VALUES
(1, 'Seconde', 1),
(1, 'Première', 2),
(1, 'Terminale', 3);

-- 4. Classes
INSERT INTO classes (niveau_id, annee_scolaire_id, nom, capacite_max) VALUES
(1, 1, 'Seconde A', 35),
(1, 1, 'Seconde B', 35),
(2, 1, 'Première C', 30),
(3, 1, 'Terminale D', 30);

-- 5. Salles
INSERT INTO salles (etablissement_id, nom, capacite, type) VALUES
(1, 'Salle 101', 40, 'cours'),
(1, 'Salle 102', 35, 'cours'),
(1, 'Laboratoire SVT', 25, 'laboratoire'),
(1, 'Salle Multimédia', 20, 'informatique');

-- 6. Matières
INSERT INTO matieres (code_matiere, intitule, coefficient, niveau, serie) VALUES
('MATH', 'Mathématiques', 4.00, 'Terminale', 'D'),
('PC', 'Physique-Chimie', 3.50, 'Terminale', 'D'),
('SVT', 'Sciences de la Vie et de la Terre', 3.00, 'Terminale', 'D'),
('FR', 'Français', 3.00, 'Toutes', 'Toutes'),
('ANG', 'Anglais', 2.00, 'Toutes', 'Toutes'),
('HG', 'Histoire-Géographie', 2.50, 'Toutes', 'Toutes'),
('PHILO', 'Philosophie', 2.00, 'Terminale', 'Toutes'),
('EPS', 'Éducation Physique', 1.00, 'Toutes', 'Toutes');

-- 7. Utilisateurs (comptes)
INSERT INTO users (email, password_hash, is_active) VALUES
('rakoto.john@student.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),  -- password: password
('rasoa.mary@student.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
('andrian.jean@student.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
('rakoto.prof@school.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
('rasamuel.prof@school.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
('raharison.prof@school.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
('parent.rakoto@family.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
('parent.rasoa@family.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
('parent.andrian@family.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE);

-- 8. Profils étudiants
INSERT INTO profils_etudiants (user_id, matricule, nom, prenom, date_naissance, sexe, adresse, region) VALUES
(1, '2024-001', 'RAKOTO', 'John', '2008-05-15', 'M', 'Lot II 123 Bis, Antananarivo', 'Analamanga'),
(2, '2024-002', 'RASOA', 'Mary', '2008-08-22', 'F', 'Lot IV 456 Ter, Antananarivo', 'Analamanga'),
(3, '2024-003', 'ANDRIAN', 'Jean', '2007-12-10', 'M', 'Lot I 789, Antananarivo', 'Analamanga');

-- 9. Profils professeurs
INSERT INTO profils_professeurs (user_id, matricule, nom, prenom, date_naissance, sexe, specialite, type_contrat) VALUES
(4, 'PROF-001', 'RAKOTO', 'Paul', '1980-03-10', 'M', 'Mathématiques', 'permanent'),
(5, 'PROF-002', 'RASAMUEL', 'Claire', '1985-07-18', 'F', 'Physique-Chimie', 'permanent'),
(6, 'PROF-003', 'RAHARISON', 'Marc', '1978-11-25', 'M', 'Français', 'permanent');

-- 10. Profils parents
INSERT INTO profils_parents (user_id, nom, prenom, telephone, email, lien_parente) VALUES
(7, 'RAKOTO', 'Jean', '032 11 22 33', 'jean.rakoto@family.mg', 'père'),
(8, 'RASOA', 'Marie', '033 44 55 66', 'marie.rasoa@family.mg', 'mère'),
(9, 'ANDRIAN', 'Pierre', '034 77 88 99', 'pierre.andrian@family.mg', 'père');

-- 11. Liaison étudiants-parents
INSERT INTO etudiants_parents (etudiant_id, parent_id, est_contact_principal) VALUES
(1, 1, TRUE),
(2, 2, TRUE),
(3, 3, TRUE);

-- 12. Inscriptions
INSERT INTO inscriptions (etudiant_id, classe_id, annee_scolaire_id, type_inscription, statut) VALUES
(1, 4, 1, 'nouvelle', 'active'),  -- John en Terminale D
(2, 3, 1, 'nouvelle', 'active'),  -- Mary en Première C
(3, 1, 1, 'nouvelle', 'active');  -- Jean en Seconde A

-- 13. Périodes (trimestres)
INSERT INTO periodes (libelle, type_periode, date_debut, date_fin, annee_scolaire) VALUES
('1er Trimestre 2024-2025', 'trimestre', '2024-09-01', '2024-12-15', 2024),
('2ème Trimestre 2024-2025', 'trimestre', '2024-12-16', '2025-03-31', 2025),
('3ème Trimestre 2024-2025', 'trimestre', '2025-04-01', '2025-06-30', 2025);

-- 14. Notes des étudiants (quelques notes pour le 1er trimestre)
-- John RAKOTO (Terminale D)
INSERT INTO notes (valeur, type_evaluation, date_evaluation, etudiant_id, matiere_id, professeur_id, periode_id) VALUES
(15.5, 'devoir', '2024-09-20', 1, 1, 1, 1),   -- Maths
(14.0, 'devoir', '2024-09-22', 1, 2, 2, 1),   -- PC
(16.0, 'interrogation', '2024-10-05', 1, 3, 2, 1),  -- SVT
(13.5, 'devoir', '2024-09-25', 1, 4, 3, 1),   -- Français
(17.0, 'composition', '2024-10-30', 1, 1, 1, 1),  -- Maths
(15.0, 'examen', '2024-11-25', 1, 2, 2, 1);   -- PC

-- Mary RASOA (Première C)
INSERT INTO notes (valeur, type_evaluation, date_evaluation, etudiant_id, matiere_id, professeur_id, periode_id) VALUES
(12.5, 'devoir', '2024-09-20', 2, 1, 1, 1),   -- Maths
(13.0, 'devoir', '2024-09-22', 2, 4, 3, 1),   -- Français
(14.5, 'interrogation', '2024-10-10', 2, 5, 3, 1),  -- Anglais
(11.0, 'devoir', '2024-10-15', 2, 6, 3, 1),   -- HG
(14.0, 'composition', '2024-11-01', 2, 1, 1, 1);  -- Maths

-- Jean ANDRIAN (Seconde A)
INSERT INTO notes (valeur, type_evaluation, date_evaluation, etudiant_id, matiere_id, professeur_id, periode_id) VALUES
(10.5, 'devoir', '2024-09-19', 3, 1, 1, 1),   -- Maths
(11.0, 'devoir', '2024-09-21', 3, 4, 3, 1),   -- Français
(12.0, 'interrogation', '2024-10-08', 3, 5, 3, 1),  -- Anglais
(13.5, 'devoir', '2024-10-12', 3, 6, 3, 1);   -- HG

-- 15. Emploi du temps (quelques cours)
INSERT INTO emploi_du_temps (jour_semaine, heure_debut, heure_fin, date, annee_scolaire, classe_id, matiere_id, professeur_id, salle_id) VALUES
('Lundi', '08:00:00', '10:00:00', '2024-09-02', 2024, 4, 1, 1, 1),   -- Maths Terminale D
('Mardi', '08:00:00', '10:00:00', '2024-09-03', 2024, 4, 2, 2, 2),   -- PC Terminale D
('Mercredi', '10:00:00', '12:00:00', '2024-09-04', 2024, 3, 1, 1, 1), -- Maths Première C
('Jeudi', '08:00:00', '10:00:00', '2024-09-05', 2024, 1, 1, 1, 1),    -- Maths Seconde A
('Vendredi', '08:00:00', '10:00:00', '2024-09-06', 2024, 4, 4, 3, 1);  -- Français Terminale D

-- 16. Absences
-- Création d'abord des séances
INSERT INTO seances (emploi_du_temps_id, date_seance, heure_debut, heure_fin, a_eu_lieu) VALUES
(1, '2024-09-09', '08:00:00', '10:00:00', TRUE),   -- Maths TD
(2, '2024-09-10', '08:00:00', '10:00:00', TRUE),   -- PC TD
(4, '2024-09-12', '08:00:00', '10:00:00', FALSE);  -- Maths SA (cours annulé)

-- Absences
INSERT INTO absences (seance_id, etudiant_id, type, motif, justificatif_url) VALUES
(1, 2, 'justifiee', 'Malade, certificat médical fourni', '/uploads/justificatifs/medicaux/rasoa_certif.pdf'),
(1, 3, 'non_justifiee', '', NULL);

-- 17. Documents générés
INSERT INTO documents (etudiant_id, type_document, titre, fichier_url, annee_scolaire_id, periode_id, est_valide) VALUES
(1, 'releve_notes', 'Relevé de notes T1 2024-2025', '/documents/releves/2024-001_T1.pdf', 1, 1, TRUE),
(2, 'releve_notes', 'Relevé de notes T1 2024-2025', '/documents/releves/2024-002_T1.pdf', 1, 1, TRUE),
(3, 'releve_notes', 'Relevé de notes T1 2024-2025', '/documents/releves/2024-003_T1.pdf', 1, 1, TRUE);

-- 18. Demandes de modification
INSERT INTO demandes_modification_dossier (etudiant_id, champ_modifie, ancienne_valeur, nouvelle_valeur, motif, statut, soumis_par) VALUES
(1, 'telephone', '034 12 34 56', '034 98 76 54', 'Nouveau numéro de téléphone', 'approuvee', 1),
(2, 'adresse', 'Lot IV 456 Ter', 'Lot IV 789 Bis', 'Déménagement', 'en_attente', 2);

-- 19. Notifications
INSERT INTO notification_types (code, libelle, template_message) VALUES
('notes_publiees', 'Notes disponibles', 'Vos notes du trimestre sont disponibles'),
('absence_enregistree', 'Absence enregistrée', 'Vous avez été absent(e) le {date}');

INSERT INTO notifications (user_id, type_id, titre, message, est_lu) VALUES
(1, 1, 'Notes disponibles', 'Vos notes du 1er trimestre sont consultables', FALSE),
(2, 1, 'Notes disponibles', 'Vos notes du 1er trimestre sont consultables', FALSE),
(3, 1, 'Notes disponibles', 'Vos notes du 1er trimestre sont consultables', FALSE);

-- 20. Rôles pour les utilisateurs
INSERT INTO user_roles (user_id, role_id) VALUES
(1, (SELECT id FROM roles WHERE nom = 'etudiant')),
(2, (SELECT id FROM roles WHERE nom = 'etudiant')),
(3, (SELECT id FROM roles WHERE nom = 'etudiant')),
(4, (SELECT id FROM roles WHERE nom = 'professeur')),
(5, (SELECT id FROM roles WHERE nom = 'professeur')),
(6, (SELECT id FROM roles WHERE nom = 'professeur')),
(7, (SELECT id FROM roles WHERE nom = 'parent')),
(8, (SELECT id FROM roles WHERE nom = 'parent')),
(9, (SELECT id FROM roles WHERE nom = 'parent'));

-- ============================================================
-- AFFICHAGE RÉCAPITULATIF
-- ============================================================

\echo '=========================================='
\echo 'Données insérées avec succès !'
\echo '=========================================='
\echo 'Étudiants :'
SELECT id, matricule, nom, prenom FROM profils_etudiants;
\echo ''
\echo 'Classes :'
SELECT id, nom FROM classes;
\echo ''
\echo 'Matières :'
SELECT id, code_matiere, intitule, coefficient FROM matieres;
\echo ''
\echo 'Notes par étudiant :'
SELECT e.nom, e.prenom, m.intitule, n.valeur, n.type_evaluation 
FROM notes n
JOIN profils_etudiants e ON e.id = n.etudiant_id
JOIN matieres m ON m.id = n.matiere_id
ORDER BY e.nom, n.date_evaluation;