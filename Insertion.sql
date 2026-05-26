-- ============================================================
-- INSERTIONS CORRIGÉES
-- ============================================================

-- 1. Rôles
INSERT INTO roles (id, nom, description) VALUES
(1, 'professeur', 'Saisie notes, absences, emploi du temps'),
(2, 'etudiant', 'Consultation notes, dossier, emploi du temps'),
(3, 'parent', 'Consultation dossier enfant, notifications');

-- 2. Établissement
INSERT INTO etablissements (id, nom, adresse, telephone, email) VALUES
(1, 'Lycée Moderne', 'Antananarivo', '034 00 000 00', 'contact@lycee.mg');

-- 3. Année scolaire
INSERT INTO annees_scolaires (id, etablissement_id, libelle, date_debut, date_fin, est_active) VALUES
(1, 1, '2024-2025', '2024-09-01', '2025-06-30', TRUE);

-- 4. Niveaux
INSERT INTO niveaux (id, etablissement_id, libelle, ordre) VALUES
(1, 1, 'Seconde', 1),
(2, 1, 'Première', 2),
(3, 1, 'Terminale', 3);

-- 5. Classes
INSERT INTO classes (id, niveau_id, annee_scolaire_id, nom, capacite_max) VALUES
(1, 1, 1, 'Seconde A', 35),
(2, 2, 1, 'Première C', 30),
(3, 3, 1, 'Terminale D', 30);

-- 6. Salles
INSERT INTO salles (id, etablissement_id, nom, capacite, type) VALUES
(1, 1, 'Salle 101', 40, 'cours'),
(2, 1, 'Salle 102', 35, 'cours'),
(3, 1, 'Labo SVT', 25, 'laboratoire');

-- 7. Matières
INSERT INTO matieres (id, code_matiere, intitule, coefficient) VALUES
(1, 'MATH', 'Mathématiques', 4),
(2, 'PC', 'Physique-Chimie', 3),
(3, 'FR', 'Français', 3),
(4, 'ANG', 'Anglais', 2);

-- 8. Utilisateurs (mot de passe = '123456')
INSERT INTO users (id, email, password_hash, is_active) VALUES
(1, 'rakoto.john@student.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
(2, 'rasoa.mary@student.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
(3, 'rabe.prof@school.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
(4, 'rasamuel.prof@school.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE);

-- 9. User roles
INSERT INTO user_roles (user_id, role_id) VALUES
(1, 2),  -- étudiant
(2, 2),  -- étudiant
(3, 1),  -- professeur
(4, 1);  -- professeur

-- 10. Profils étudiants
INSERT INTO profils_etudiants (id, user_id, matricule, nom, prenom) VALUES
(1, 1, '2024001', 'RAKOTO', 'John'),
(2, 2, '2024002', 'RASOA', 'Mary');

-- 11. Profils professeurs
INSERT INTO profils_professeurs (id, user_id, matricule, nom, prenom, specialite) VALUES
(1, 3, 'PROF001', 'RABE', 'Paul', 'Mathématiques'),
(2, 4, 'PROF002', 'RASAMUEL', 'Claire', 'Physique-Chimie');

-- 12. Inscriptions
INSERT INTO inscriptions (id, etudiant_id, classe_id, annee_scolaire_id, statut) VALUES
(1, 1, 3, 1, 'active'),
(2, 2, 2, 1, 'active');

-- 13. Périodes
INSERT INTO periodes (id, libelle, type_periode, date_debut, date_fin, annee_scolaire_id) VALUES
(1, '1er Trimestre 2024-2025', 'trimestre', '2024-09-01', '2024-11-30', 1),
(2, '2ème Trimestre 2024-2025', 'trimestre', '2024-12-01', '2025-02-28', 1),
(3, '3ème Trimestre 2024-2025', 'trimestre', '2025-03-01', '2025-05-31', 1);

-- 14. Emplois du temps
INSERT INTO emploi_du_temps (id, classe_id, periode_id) VALUES
(1, 3, 1),  -- Terminale D - Période 1
(2, 3, 2),  -- Terminale D - Période 2
(3, 3, 3),  -- Terminale D - Période 3
(4, 2, 1),  -- Première C - Période 1
(5, 2, 2),  -- Première C - Période 2
(6, 2, 3);  -- Première C - Période 3

-- 15. Séances pour Terminale D - Période 1 (emploi_du_temps_id = 1)
INSERT INTO seances (id, emploi_du_temps_id, jour_semaine, heure_debut, heure_fin, matiere_id, professeur_id, salle_id, est_annule) VALUES
(1, 1, 'Lundi',    '08:00:00', '10:00:00', 1, 1, 1, FALSE),
(2, 1, 'Mardi',    '08:00:00', '10:00:00', 2, 2, 2, FALSE),
(3, 1, 'Mercredi', '10:00:00', '12:00:00', 3, 1, 1, FALSE),
(4, 1, 'Jeudi',    '08:00:00', '10:00:00', 1, 1, 1, FALSE),
(5, 1, 'Vendredi', '08:00:00', '10:00:00', 4, 1, 1, FALSE);

-- 16. Séances pour Première C - Période 1 (emploi_du_temps_id = 4)
INSERT INTO seances (id, emploi_du_temps_id, jour_semaine, heure_debut, heure_fin, matiere_id, professeur_id, salle_id, est_annule) VALUES
(6, 4, 'Lundi',    '08:00:00', '10:00:00', 1, 1, 1, FALSE),
(7, 4, 'Mercredi', '08:00:00', '10:00:00', 1, 1, 1, FALSE),
(8, 4, 'Jeudi',    '10:00:00', '12:00:00', 3, 1, 1, FALSE),
(9, 4, 'Vendredi', '08:00:00', '10:00:00', 4, 1, 1, FALSE);

-- 17. Notes
INSERT INTO notes (id_note, valeur, type_evaluation, date_evaluation, etudiant_id, matiere_id, professeur_id, periode_id) VALUES
(1, 15, 'devoir', '2024-09-20', 1, 1, 1, 1),
(2, 14, 'devoir', '2024-09-22', 1, 2, 2, 1),
(3, 16, 'interrogation', '2024-09-25', 1, 3, 1, 1),
(4, 13, 'devoir', '2024-09-20', 2, 1, 1, 1),
(5, 15, 'devoir', '2024-09-23', 2, 4, 1, 1);

-- 18. Documents
INSERT INTO documents (id, etudiant_id, type_document, titre, annee_scolaire_id, periode_id) VALUES
(1, 1, 'releve_notes', 'Relevé T1 2024-2025', 1, 1),
(2, 2, 'releve_notes', 'Relevé T1 2024-2025', 1, 1);

-- 19. Notification types
INSERT INTO notification_types (id, code, libelle, template_message) VALUES
(1, 'notes_publiees', 'Notes disponibles', 'Vos notes sont disponibles');

-- 20. Notifications
INSERT INTO notifications (id, user_id, type_id, titre, message) VALUES
(1, 1, 1, 'Notes disponibles', 'Vos notes du trimestre sont consultables'),
(2, 2, 1, 'Notes disponibles', 'Vos notes du trimestre sont consultables');

-- ============================================================
-- RÉINITIALISER LES SÉQUENCES
-- ============================================================
SELECT setval('etablissements_id_seq', (SELECT MAX(id) FROM etablissements));
SELECT setval('annees_scolaires_id_seq', (SELECT MAX(id) FROM annees_scolaires));
SELECT setval('niveaux_id_seq', (SELECT MAX(id) FROM niveaux));
SELECT setval('classes_id_seq', (SELECT MAX(id) FROM classes));
SELECT setval('salles_id_seq', (SELECT MAX(id) FROM salles));
SELECT setval('matieres_id_seq', (SELECT MAX(id) FROM matieres));
SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));
SELECT setval('profils_etudiants_id_seq', (SELECT MAX(id) FROM profils_etudiants));
SELECT setval('profils_professeurs_id_seq', (SELECT MAX(id) FROM profils_professeurs));
SELECT setval('inscriptions_id_seq', (SELECT MAX(id) FROM inscriptions));
SELECT setval('periodes_id_seq', (SELECT MAX(id) FROM periodes));
SELECT setval('emploi_du_temps_id_seq', (SELECT MAX(id) FROM emploi_du_temps));
SELECT setval('seances_id_seq', (SELECT MAX(id) FROM seances));
SELECT setval('notes_id_note_seq', (SELECT MAX(id) FROM notes));
SELECT setval('documents_id_seq', (SELECT MAX(id) FROM documents));
SELECT setval('notification_types_id_seq', (SELECT MAX(id) FROM notification_types));
SELECT setval('notifications_id_seq', (SELECT MAX(id) FROM notifications));
SELECT setval('roles_id_seq', (SELECT MAX(id) FROM roles));

-- ============================================================
-- FIN
-- ============================================================
\echo '============================================================'
\echo 'Données insérées avec succès !'
\echo '============================================================'
\echo 'Comptes de test :'
\echo '  Étudiant: rakoto.john@student.mg / 123456'
\echo '  Étudiant: rasoa.mary@student.mg / 123456'
\echo '  Professeur: rabe.prof@school.mg / 123456'
\echo '  Professeur: rasamuel.prof@school.mg / 123456'
\echo '============================================================'