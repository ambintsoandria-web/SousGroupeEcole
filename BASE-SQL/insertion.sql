-- ============================================================
-- INSERTION DES DONNÉES COMPLÈTES
-- ============================================================

-- 1. Rôles
INSERT INTO roles (id, nom, description) VALUES
(1, 'super_admin', 'Accès total, gestion technique du système'),
(2, 'directeur', 'Pilotage pédagogique et financier, validation'),
(3, 'secretariat', 'Inscriptions, dossiers, finance opérationnelle'),
(4, 'comptable', 'Finances, paiements, rapports financiers'),
(5, 'professeur', 'Saisie notes, absences, emploi du temps'),
(6, 'etudiant', 'Consultation notes, dossier, emploi du temps'),
(7, 'parent', 'Consultation dossier enfant, notifications');

-- 2. Horaires EDT
INSERT INTO horaire_edt (id, libelle, heure_debut, heure_fin, ordre) VALUES
(1, '07h00 - 08h00', '07:00', '08:00', 1),
(2, '08h00 - 09h00', '08:00', '09:00', 2),
(3, '09h00 - 10h00', '09:00', '10:00', 3),
(4, '10h00 - 11h00', '10:00', '11:00', 4),
(5, '11h00 - 12h00', '11:00', '12:00', 5),
(6, '13h00 - 14h00', '13:00', '14:00', 6),
(7, '14h00 - 15h00', '14:00', '15:00', 7),
(8, '15h00 - 16h00', '15:00', '16:00', 8),
(9, '16h00 - 17h00', '16:00', '17:00', 9);

-- 3. Établissement
INSERT INTO etablissements (id, nom, adresse, telephone, email) VALUES 
(1, 'Lycée Moderne', 'Antananarivo', '034 00 000 00', 'contact@lycee.mg');

-- 4. Années scolaires
INSERT INTO annees_scolaires (id, etablissement_id, libelle, date_debut, date_fin, est_active) VALUES
(1, 1, '2024-2025', '2024-09-01', '2025-06-30', FALSE),
(2, 1, '2025-2026', '2025-09-01', '2026-06-30', TRUE);

-- 5. Niveaux
INSERT INTO niveaux (id, etablissement_id, libelle, ordre) VALUES
(1, 1, 'Seconde', 1),
(2, 1, 'Première', 2),
(3, 1, 'Terminale', 3);

-- 6. Classes
INSERT INTO classes (id, niveau_id, annee_scolaire_id, nom, capacite_max) VALUES
(1, 3, 2, 'Terminale C', 35),
(2, 3, 2, 'Terminale D', 30);

-- 7. Salles
INSERT INTO salles (id, etablissement_id, nom, capacite, type) VALUES
(1, 1, 'Salle 101', 40, 'cours'),
(2, 1, 'Salle 102', 35, 'cours'),
(3, 1, 'Labo SVT', 25, 'laboratoire'),
(4, 1, 'Salle 103', 40, 'cours'),
(5, 1, 'Amphithéâtre', 100, 'cours');

-- 8. Matières (8 matières)
INSERT INTO matieres (id, etablissement_id, nom, code) VALUES
(1, 1, 'Mathématiques', 'MATH'),
(2, 1, 'Français', 'FR'),
(3, 1, 'Anglais', 'ANG'),
(4, 1, 'Histoire-Géographie', 'HG'),
(5, 1, 'Sciences Physiques', 'PC'),
(6, 1, 'SVT', 'SVT'),
(7, 1, 'Philosophie', 'PHILO'),
(8, 1, 'EPS', 'EPS');

-- 9. Coefficients
INSERT INTO coefficients (matiere_id, niveau_id, valeur) VALUES
(1, 3, 4.00), (2, 3, 3.00), (3, 3, 2.00), (4, 3, 2.00),
(5, 3, 3.00), (6, 3, 3.00), (7, 3, 2.00), (8, 3, 1.00);

-- 10. Utilisateurs (2 élèves + 8 profs)
INSERT INTO users (id, email, password_hash, is_active) VALUES
-- Élèves
(1, 'rakoto.john@student.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
(2, 'rasoa.mary@student.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
-- Professeurs
(10, 'rabe.prof@school.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
(11, 'rasoa.prof@school.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
(12, 'andry.prof@school.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
(13, 'hery.prof@school.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
(14, 'mamy.prof@school.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
(15, 'jean.prof@school.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
(16, 'lala.prof@school.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
(17, 'tovo.prof@school.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE);

-- 11. Profils étudiants
INSERT INTO profils_etudiants (id, user_id, matricule, nom, prenom, date_naissance, sexe, telephone) VALUES
(1, 1, '2024001', 'RAKOTO', 'John', '2008-03-15', 'M', '034200001'),
(2, 2, '2024002', 'RASOA', 'Mary', '2009-07-22', 'F', '034200002');

-- 12. Profils professeurs
INSERT INTO profils_professeurs (id, user_id, matricule, nom, prenom, specialite, telephone) VALUES
(1, 10, 'PROF001', 'RABE', 'Paul', 'Mathématiques', '034100001'),
(2, 11, 'PROF002', 'RASOA', 'Marie', 'Français', '034100002'),
(3, 12, 'PROF003', 'RAKOTO', 'Andry', 'Sciences Physiques', '034100003'),
(4, 13, 'PROF004', 'ANDRIAMAMY', 'Hery', 'Histoire-Géographie', '034100004'),
(5, 14, 'PROF005', 'RANDRIANARIVO', 'Mamy', 'SVT', '034100005'),
(6, 15, 'PROF006', 'RAZAFINDRAMISA', 'Jean', 'Anglais', '034100006'),
(7, 16, 'PROF007', 'RANDRIAMANGA', 'Lala', 'Philosophie', '034100007'),
(8, 17, 'PROF008', 'RAHARIJAO', 'Tovo', 'EPS', '034100008');

-- 13. User roles
INSERT INTO user_roles (user_id, role_id) VALUES
(1, 6), (2, 6),  -- étudiants
(10, 5), (11, 5), (12, 5), (13, 5), (14, 5), (15, 5), (16, 5), (17, 5);  -- professeurs

-- 14. Inscriptions
INSERT INTO inscriptions (id, etudiant_id, classe_id, annee_scolaire_id, statut) VALUES
(1, 1, 1, 2, 'active'),
(2, 2, 2, 2, 'active');

-- 15. Périodes
INSERT INTO periodes (id, annee_scolaire_id, libelle, type, ordre, date_debut, date_fin) VALUES
(1, 2, '1er Trimestre 2025-2026', 'trimestre', 1, '2025-09-01', '2025-11-30'),
(2, 2, '2ème Trimestre 2025-2026', 'trimestre', 2, '2025-12-01', '2026-02-28'),
(3, 2, '3ème Trimestre 2025-2026', 'trimestre', 3, '2026-03-01', '2026-06-30');

-- 16. Affectations d'enseignement
INSERT INTO affectations_enseignement (id, professeur_id, matiere_id, classe_id, annee_scolaire_id, heures_hebdo) VALUES
(1, 1, 1, 1, 2, 4.0),  -- Maths
(2, 2, 2, 1, 2, 3.0),  -- Français
(3, 6, 3, 1, 2, 2.0),  -- Anglais
(4, 4, 4, 1, 2, 2.0),  -- HG
(5, 3, 5, 1, 2, 3.0),  -- PC
(6, 5, 6, 1, 2, 3.0),  -- SVT
(7, 7, 7, 1, 2, 2.0),  -- Philo
(8, 8, 8, 1, 2, 1.0);  -- EPS

-- 17. Emploi du temps
INSERT INTO emploi_du_temps (id, affectation_id, salle_id, jour_semaine, heure_debut, heure_fin, horaire_edt_id) VALUES
-- Lundi
(1, 1, 1, 1, '07:00', '08:00', 1),
(2, 5, 2, 1, '08:00', '09:00', 2),
(3, 2, 1, 1, '09:00', '10:00', 3),
-- Mardi
(4, 1, 1, 2, '07:00', '08:00', 1),
(5, 3, 4, 2, '08:00', '09:00', 2),
(6, 4, 4, 2, '09:00', '10:00', 3),
(7, 7, 1, 2, '14:00', '15:00', 7),
-- Mercredi
(8, 2, 1, 3, '07:00', '08:00', 1),
(9, 1, 1, 3, '08:00', '09:00', 2),
(10, 6, 3, 3, '09:00', '10:00', 3),
(11, 8, 5, 3, '14:00', '15:00', 7),
-- Jeudi
(12, 5, 2, 4, '07:00', '08:00', 1),
(13, 4, 4, 4, '08:00', '09:00', 2),
(14, 2, 1, 4, '09:00', '10:00', 3),
-- Vendredi
(15, 1, 1, 5, '07:00', '08:00', 1),
(16, 3, 4, 5, '08:00', '09:00', 2),
(17, 6, 3, 5, '09:00', '10:00', 3),
(18, 7, 1, 5, '14:00', '15:00', 7);

-- 18. Séances pour la semaine du 14 au 18 Avril 2026
INSERT INTO seances (emploi_du_temps_id, date_seance, heure_debut, heure_fin, a_eu_lieu) VALUES
-- Lundi 14 Avril
(1, '2026-04-14', '07:00', '08:00', TRUE),
(2, '2026-04-14', '08:00', '09:00', TRUE),
(3, '2026-04-14', '09:00', '10:00', TRUE),
-- Mardi 15 Avril
(4, '2026-04-15', '07:00', '08:00', TRUE),
(5, '2026-04-15', '08:00', '09:00', TRUE),
(6, '2026-04-15', '09:00', '10:00', TRUE),
(7, '2026-04-15', '14:00', '15:00', TRUE),
-- Mercredi 16 Avril
(8, '2026-04-16', '07:00', '08:00', TRUE),
(9, '2026-04-16', '08:00', '09:00', TRUE),
(10, '2026-04-16', '09:00', '10:00', TRUE),
(11, '2026-04-16', '14:00', '15:00', TRUE),
-- Jeudi 17 Avril
(12, '2026-04-17', '07:00', '08:00', TRUE),
(13, '2026-04-17', '08:00', '09:00', TRUE),
(14, '2026-04-17', '09:00', '10:00', TRUE),
-- Vendredi 18 Avril
(15, '2026-04-18', '07:00', '08:00', TRUE),
(16, '2026-04-18', '08:00', '09:00', TRUE),
(17, '2026-04-18', '09:00', '10:00', TRUE),
(18, '2026-04-18', '14:00', '15:00', TRUE);



-- ============================================================
-- NOTES POUR LES 2 ÉTUDIANTS
-- ============================================================

-- NOTES JOHN (etudiant_id = 1) - Période 4 (1er Trimestre 2025-2026)
-- ============================================================
-- NOTES POUR JOHN (etudiant_id = 1)
-- Utilise les affectation_id existants: 1,2,3,4,5,6,7,8
-- ============================================================
-- ============================================================
-- NOTES POUR JOHN (etudiant_id = 1)
-- Périodes: 1 = T1, 2 = T2, 3 = T3
-- ============================================================

-- NOTES JOHN - Période 1 (1er Trimestre 2025-2026)
INSERT INTO notes (etudiant_id, affectation_id, periode_id, type_evaluation, valeur, commentaire, saisi_par) VALUES
(1, 1, 1, 'devoir', 15.5, 'Bon travail', 10),
(1, 1, 1, 'interrogation', 14.0, 'Correct', 10),
(1, 2, 1, 'devoir', 13.0, 'Passable', 10),
(1, 2, 1, 'interrogation', 14.5, 'Bien', 10),
(1, 3, 1, 'devoir', 12.0, 'Correct', 10),
(1, 4, 1, 'devoir', 11.0, 'Passable', 10),
(1, 5, 1, 'devoir', 14.0, 'Bien', 10),
(1, 6, 1, 'devoir', 16.0, 'Très bien', 10),
(1, 7, 1, 'devoir', 13.5, 'Correct', 10),
(1, 8, 1, 'devoir', 15.0, 'Bien', 10);

-- NOTES JOHN - Période 2 (2ème Trimestre 2025-2026)
INSERT INTO notes (etudiant_id, affectation_id, periode_id, type_evaluation, valeur, commentaire, saisi_par) VALUES
(1, 1, 2, 'devoir', 16.0, 'Excellent', 10),
(1, 1, 2, 'composition', 17.5, 'Félicitations', 10),
(1, 2, 2, 'devoir', 12.5, 'Moyen', 10),
(1, 2, 2, 'interrogation', 11.0, 'Insuffisant', 10),
(1, 3, 2, 'devoir', 13.0, 'Correct', 10),
(1, 3, 2, 'composition', 14.0, 'Bien', 10),
(1, 4, 2, 'devoir', 10.0, 'Passable', 10),
(1, 5, 2, 'devoir', 15.0, 'Bien', 10),
(1, 6, 2, 'devoir', 14.5, 'Bien', 10),
(1, 6, 2, 'interrogation', 16.0, 'Très bien', 10),
(1, 7, 2, 'devoir', 12.0, 'Correct', 10),
(1, 8, 2, 'devoir', 14.0, 'Bien', 10);

-- NOTES JOHN - Période 3 (3ème Trimestre 2025-2026 - ACTUEL)
INSERT INTO notes (etudiant_id, affectation_id, periode_id, type_evaluation, valeur, commentaire, saisi_par) VALUES
(1, 1, 3, 'devoir', 18.0, 'Excellent', 10),
(1, 1, 3, 'composition', 19.0, 'Félicitations', 10),
(1, 1, 3, 'interrogation', 17.0, 'Très bien', 10),
(1, 2, 3, 'devoir', 14.0, 'Bien', 10),
(1, 2, 3, 'composition', 15.5, 'Très bien', 10),
(1, 3, 3, 'devoir', 14.0, 'Bien', 10),
(1, 3, 3, 'interrogation', 13.5, 'Correct', 10),
(1, 4, 3, 'devoir', 12.0, 'Passable', 10),
(1, 4, 3, 'composition', 13.0, 'Correct', 10),
(1, 5, 3, 'devoir', 16.5, 'Très bien', 10),
(1, 5, 3, 'interrogation', 15.0, 'Bien', 10),
(1, 6, 3, 'devoir', 17.0, 'Excellent', 10),
(1, 6, 3, 'composition', 18.0, 'Félicitations', 10),
(1, 7, 3, 'devoir', 14.0, 'Bien', 10),
(1, 8, 3, 'devoir', 16.0, 'Très bien', 10);

-- ============================================================
-- NOTES POUR MARY (etudiant_id = 2)
-- ============================================================

-- Période 1
INSERT INTO notes (etudiant_id, affectation_id, periode_id, type_evaluation, valeur, commentaire, saisi_par) VALUES
(2, 1, 1, 'devoir', 14.0, 'Correct', 10),
(2, 1, 1, 'interrogation', 15.0, 'Bien', 10),
(2, 2, 1, 'devoir', 15.0, 'Bien', 10),
(2, 3, 1, 'devoir', 13.0, 'Correct', 10),
(2, 4, 1, 'devoir', 12.0, 'Passable', 10),
(2, 5, 1, 'devoir', 14.5, 'Bien', 10),
(2, 6, 1, 'devoir', 15.0, 'Bien', 10),
(2, 7, 1, 'devoir', 12.5, 'Correct', 10),
(2, 8, 1, 'devoir', 16.0, 'Très bien', 10);

-- Période 2
INSERT INTO notes (etudiant_id, affectation_id, periode_id, type_evaluation, valeur, commentaire, saisi_par) VALUES
(2, 1, 2, 'devoir', 16.0, 'Excellent', 10),
(2, 1, 2, 'composition', 17.0, 'Très bien', 10),
(2, 2, 2, 'devoir', 13.5, 'Correct', 10),
(2, 2, 2, 'interrogation', 12.0, 'Passable', 10),
(2, 3, 2, 'devoir', 14.0, 'Bien', 10),
(2, 4, 2, 'devoir', 11.0, 'Passable', 10),
(2, 5, 2, 'devoir', 15.5, 'Bien', 10),
(2, 6, 2, 'devoir', 14.0, 'Bien', 10),
(2, 7, 2, 'devoir', 13.0, 'Correct', 10),
(2, 8, 2, 'devoir', 15.0, 'Bien', 10);

-- Période 3 (ACTUELLE)
INSERT INTO notes (etudiant_id, affectation_id, periode_id, type_evaluation, valeur, commentaire, saisi_par) VALUES
(2, 1, 3, 'devoir', 17.5, 'Excellent', 10),
(2, 1, 3, 'composition', 18.0, 'Félicitations', 10),
(2, 2, 3, 'devoir', 14.0, 'Bien', 10),
(2, 2, 3, 'composition', 15.0, 'Très bien', 10),
(2, 3, 3, 'devoir', 15.0, 'Bien', 10),
(2, 4, 3, 'devoir', 12.5, 'Correct', 10),
(2, 5, 3, 'devoir', 16.0, 'Très bien', 10),
(2, 6, 3, 'devoir', 16.5, 'Excellent', 10),
(2, 7, 3, 'devoir', 14.0, 'Bien', 10),
(2, 8, 3, 'devoir', 17.0, 'Très bien', 10);

select * from notes join affectations_enseignement 
on notes.affectation_id = affectations_enseignement.id 
where etudiant_id = 1 
and periode_id =1 
and affectations_enseignement.annee_scolaire_id = 2;