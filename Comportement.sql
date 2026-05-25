-- =============================================================
--  LycéePro — Extensions Étudiant
--  Module 1 : Vie Scolaire (sanctions, récompenses, comportement)
--  Module 2 : Communication (messagerie, notifications parents)
--  Base : MySQL / MariaDB 8.0+
-- =============================================================

-- =============================================================
-- MODULE 1 : VIE SCOLAIRE
-- =============================================================

-- -------------------------------------------------------------
-- 1.1 COMPORTEMENT  (fiche hebdomadaire de comportement)
-- -------------------------------------------------------------
CREATE TABLE comportement (
    id_comportement     CHAR(36)        PRIMARY KEY DEFAULT (UUID()),
    date_observation    DATE            NOT NULL,
    note_comportement   TINYINT UNSIGNED NOT NULL
                        CHECK (note_comportement BETWEEN 0 AND 20),
    appreciation        ENUM('excellent','bien','satisfaisant',
                             'insuffisant','mauvais') NOT NULL,
    commentaire         TEXT,
    -- Qui a observé ?
    id_etudiant         CHAR(36)        NOT NULL,
    id_professeur       CHAR(36)        NOT NULL,
    id_periode          CHAR(36)        NOT NULL,
    created_at          DATETIME        NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_comp_etudiant   FOREIGN KEY (id_etudiant)
        REFERENCES etudiant(id_etudiant)   ON DELETE CASCADE,
    CONSTRAINT fk_comp_prof       FOREIGN KEY (id_professeur)
        REFERENCES professeur(id_professeur) ON DELETE RESTRICT,
    CONSTRAINT fk_comp_periode    FOREIGN KEY (id_periode)
        REFERENCES periode(id_periode)     ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------
-- 1.2 SANCTION
-- -------------------------------------------------------------
CREATE TABLE sanction (
    id_sanction         CHAR(36)        PRIMARY KEY DEFAULT (UUID()),
    type_sanction       ENUM('avertissement','blâme','retenue',
                             'exclusion_temporaire','exclusion_définitive',
                             'convocation_parents','travail_interet_general')
                        NOT NULL,
    motif               VARCHAR(300)    NOT NULL,
    description         TEXT,
    date_sanction       DATE            NOT NULL,
    date_debut          DATE,
    date_fin            DATE,
    -- Suivi
    notifie_parents     TINYINT(1)      NOT NULL DEFAULT 0,
    date_notification   DATETIME,
    statut              ENUM('prononcée','en_cours','levée','annulée')
                        NOT NULL DEFAULT 'prononcée',
    observation_suite   TEXT,
    -- Clés
    id_etudiant         CHAR(36)        NOT NULL,
    id_prononceur       CHAR(36)        NOT NULL,  -- professeur ou directeur
    created_at          DATETIME        NOT NULL DEFAULT NOW(),
    updated_at          DATETIME        NOT NULL DEFAULT NOW()
                        ON UPDATE NOW(),
    CONSTRAINT fk_sanction_etudiant  FOREIGN KEY (id_etudiant)
        REFERENCES etudiant(id_etudiant)     ON DELETE CASCADE,
    CONSTRAINT fk_sanction_prof      FOREIGN KEY (id_prononceur)
        REFERENCES professeur(id_professeur) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------
-- 1.3 RECOMPENSE / DISTINCTION
-- -------------------------------------------------------------
CREATE TABLE recompense (
    id_recompense       CHAR(36)        PRIMARY KEY DEFAULT (UUID()),
    type_recompense     ENUM('félicitations','tableaux_honneur','prix',
                             'mention_spéciale','bourse','médaille')
                        NOT NULL,
    intitule            VARCHAR(200)    NOT NULL,
    description         TEXT,
    date_remise         DATE            NOT NULL,
    valeur_monetaire    DECIMAL(10,2)   DEFAULT 0.00,  -- si bourse/prix
    -- Clés
    id_etudiant         CHAR(36)        NOT NULL,
    id_attribueur       CHAR(36)        NOT NULL,
    id_periode          CHAR(36),
    created_at          DATETIME        NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_recomp_etudiant   FOREIGN KEY (id_etudiant)
        REFERENCES etudiant(id_etudiant)     ON DELETE CASCADE,
    CONSTRAINT fk_recomp_prof       FOREIGN KEY (id_attribueur)
        REFERENCES professeur(id_professeur) ON DELETE RESTRICT,
    CONSTRAINT fk_recomp_periode    FOREIGN KEY (id_periode)
        REFERENCES periode(id_periode)       ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------
-- 1.4 CONSEIL DE DISCIPLINE
-- -------------------------------------------------------------
CREATE TABLE conseil_discipline (
    id_conseil          CHAR(36)        PRIMARY KEY DEFAULT (UUID()),
    date_conseil        DATE            NOT NULL,
    motif_convocation   TEXT            NOT NULL,
    decision            ENUM('aucune_suite','avertissement_écrit',
                             'exclusion_temporaire','exclusion_définitive',
                             'mutation','autre')
                        NOT NULL,
    compte_rendu        TEXT,
    membres_presents    TEXT,           -- JSON ou texte libre
    id_etudiant         CHAR(36)        NOT NULL,
    id_sanction         CHAR(36),       -- sanction résultante
    created_at          DATETIME        NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_cd_etudiant   FOREIGN KEY (id_etudiant)
        REFERENCES etudiant(id_etudiant)  ON DELETE CASCADE,
    CONSTRAINT fk_cd_sanction   FOREIGN KEY (id_sanction)
        REFERENCES sanction(id_sanction)  ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------
-- 1.5 ACTIVITE PARASCOLAIRE
-- -------------------------------------------------------------
CREATE TABLE activite_parascolaire (
    id_activite         CHAR(36)        PRIMARY KEY DEFAULT (UUID()),
    nom_activite        VARCHAR(150)    NOT NULL,
    type_activite       ENUM('sport','art','science','culture',
                             'bénévolat','club','autre')
                        NOT NULL,
    description         TEXT,
    responsable         VARCHAR(150),
    created_at          DATETIME        NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table de liaison étudiant ↔ activité
CREATE TABLE etudiant_activite (
    id_etudiant         CHAR(36)        NOT NULL,
    id_activite         CHAR(36)        NOT NULL,
    date_inscription    DATE            NOT NULL DEFAULT (CURRENT_DATE),
    date_fin            DATE,
    role_dans_activite  VARCHAR(100),   -- capitaine, membre, trésorier…
    statut              ENUM('actif','inactif') NOT NULL DEFAULT 'actif',
    PRIMARY KEY (id_etudiant, id_activite),
    CONSTRAINT fk_ea_etudiant   FOREIGN KEY (id_etudiant)
        REFERENCES etudiant(id_etudiant)             ON DELETE CASCADE,
    CONSTRAINT fk_ea_activite   FOREIGN KEY (id_activite)
        REFERENCES activite_parascolaire(id_activite) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =============================================================
-- MODULE 2 : COMMUNICATION
-- =============================================================

-- -------------------------------------------------------------
-- 2.1 MESSAGERIE (conversations internes)
-- -------------------------------------------------------------
CREATE TABLE conversation (
    id_conversation     CHAR(36)        PRIMARY KEY DEFAULT (UUID()),
    sujet               VARCHAR(255)    NOT NULL,
    type_conversation   ENUM('direct','groupe','broadcast')
                        NOT NULL DEFAULT 'direct',
    created_at          DATETIME        NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Participants à une conversation
CREATE TABLE conversation_participant (
    id_conversation     CHAR(36)        NOT NULL,
    id_utilisateur      CHAR(36)        NOT NULL,
    date_ajout          DATETIME        NOT NULL DEFAULT NOW(),
    derniere_lecture    DATETIME,
    quitte              TINYINT(1)      NOT NULL DEFAULT 0,
    PRIMARY KEY (id_conversation, id_utilisateur),
    CONSTRAINT fk_cp_conv FOREIGN KEY (id_conversation)
        REFERENCES conversation(id_conversation) ON DELETE CASCADE,
    CONSTRAINT fk_cp_user FOREIGN KEY (id_utilisateur)
        REFERENCES utilisateur(id_utilisateur)   ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Messages
CREATE TABLE message (
    id_message          CHAR(36)        PRIMARY KEY DEFAULT (UUID()),
    contenu             TEXT            NOT NULL,
    type_contenu        ENUM('texte','fichier','image','lien')
                        NOT NULL DEFAULT 'texte',
    fichier_url         TEXT,
    lu                  TINYINT(1)      NOT NULL DEFAULT 0,
    id_conversation     CHAR(36)        NOT NULL,
    id_expediteur       CHAR(36)        NOT NULL,
    created_at          DATETIME        NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_msg_conv FOREIGN KEY (id_conversation)
        REFERENCES conversation(id_conversation)  ON DELETE CASCADE,
    CONSTRAINT fk_msg_exp  FOREIGN KEY (id_expediteur)
        REFERENCES utilisateur(id_utilisateur)    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------
-- 2.2 NOTIFICATION (alertes automatiques)
-- -------------------------------------------------------------
CREATE TABLE notification (
    id_notification     CHAR(36)        PRIMARY KEY DEFAULT (UUID()),
    titre               VARCHAR(200)    NOT NULL,
    corps               TEXT            NOT NULL,
    type_notification   ENUM('absence','note','bulletin','sanction',
                             'paiement','message','événement','alerte_générale')
                        NOT NULL,
    canal               ENUM('app','email','sms','push')
                        NOT NULL DEFAULT 'app',
    statut              ENUM('en_attente','envoyée','lue','échouée')
                        NOT NULL DEFAULT 'en_attente',
    date_envoi          DATETIME,
    -- Destinataire
    id_destinataire     CHAR(36)        NOT NULL,
    -- Lien vers l'objet source (optionnel)
    entite_liee         VARCHAR(50),    -- 'note', 'absence', 'sanction'…
    id_entite_liee      CHAR(36),
    created_at          DATETIME        NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_notif_dest FOREIGN KEY (id_destinataire)
        REFERENCES utilisateur(id_utilisateur) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------
-- 2.3 CARNET DE LIAISON NUMÉRIQUE (parent ↔ école)
-- -------------------------------------------------------------
CREATE TABLE carnet_liaison (
    id_carnet           CHAR(36)        PRIMARY KEY DEFAULT (UUID()),
    objet               VARCHAR(255)    NOT NULL,
    contenu             TEXT            NOT NULL,
    type_message        ENUM('information','demande','signalement',
                             'autorisation','autre')
                        NOT NULL DEFAULT 'information',
    priorite            ENUM('normale','urgente') NOT NULL DEFAULT 'normale',
    statut              ENUM('envoyé','lu','traité','archivé')
                        NOT NULL DEFAULT 'envoyé',
    reponse             TEXT,
    date_reponse        DATETIME,
    -- Parties
    id_etudiant         CHAR(36)        NOT NULL,
    id_expediteur       CHAR(36)        NOT NULL,  -- tuteur ou staff
    id_destinataire     CHAR(36)        NOT NULL,  -- staff ou tuteur
    created_at          DATETIME        NOT NULL DEFAULT NOW(),
    updated_at          DATETIME        NOT NULL DEFAULT NOW()
                        ON UPDATE NOW(),
    CONSTRAINT fk_cl_etudiant FOREIGN KEY (id_etudiant)
        REFERENCES etudiant(id_etudiant)           ON DELETE CASCADE,
    CONSTRAINT fk_cl_exp      FOREIGN KEY (id_expediteur)
        REFERENCES utilisateur(id_utilisateur)     ON DELETE CASCADE,
    CONSTRAINT fk_cl_dest     FOREIGN KEY (id_destinataire)
        REFERENCES utilisateur(id_utilisateur)     ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------
-- 2.4 RENDEZ-VOUS (réunion parents-professeurs)
-- -------------------------------------------------------------
CREATE TABLE rendez_vous (
    id_rdv              CHAR(36)        PRIMARY KEY DEFAULT (UUID()),
    date_rdv            DATETIME        NOT NULL,
    duree_minutes       TINYINT UNSIGNED NOT NULL DEFAULT 15,
    motif               VARCHAR(255)    NOT NULL,
    lieu                VARCHAR(150),
    type_rdv            ENUM('présentiel','téléphonique','visioconférence')
                        NOT NULL DEFAULT 'présentiel',
    statut              ENUM('demandé','confirmé','annulé','effectué')
                        NOT NULL DEFAULT 'demandé',
    notes_compte_rendu  TEXT,
    -- Parties
    id_etudiant         CHAR(36)        NOT NULL,
    id_tuteur           CHAR(36)        NOT NULL,
    id_professeur       CHAR(36)        NOT NULL,
    created_at          DATETIME        NOT NULL DEFAULT NOW(),
    updated_at          DATETIME        NOT NULL DEFAULT NOW()
                        ON UPDATE NOW(),
    CONSTRAINT fk_rdv_etudiant  FOREIGN KEY (id_etudiant)
        REFERENCES etudiant(id_etudiant)     ON DELETE CASCADE,
    CONSTRAINT fk_rdv_tuteur    FOREIGN KEY (id_tuteur)
        REFERENCES tuteur(id_tuteur)         ON DELETE CASCADE,
    CONSTRAINT fk_rdv_prof      FOREIGN KEY (id_professeur)
        REFERENCES professeur(id_professeur) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------
-- 2.5 SUIVI DE LECTURE DES MESSAGES (accusés de réception)
-- -------------------------------------------------------------
CREATE TABLE message_lecture (
    id_message          CHAR(36)        NOT NULL,
    id_utilisateur      CHAR(36)        NOT NULL,
    date_lecture        DATETIME        NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id_message, id_utilisateur),
    CONSTRAINT fk_ml_msg  FOREIGN KEY (id_message)
        REFERENCES message(id_message)         ON DELETE CASCADE,
    CONSTRAINT fk_ml_user FOREIGN KEY (id_utilisateur)
        REFERENCES utilisateur(id_utilisateur) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =============================================================
-- INDEX
-- =============================================================
CREATE INDEX idx_comportement_etudiant   ON comportement(id_etudiant);
CREATE INDEX idx_sanction_etudiant       ON sanction(id_etudiant);
CREATE INDEX idx_sanction_statut         ON sanction(statut);
CREATE INDEX idx_recompense_etudiant     ON recompense(id_etudiant);
CREATE INDEX idx_notification_dest       ON notification(id_destinataire, statut);
CREATE INDEX idx_message_conv            ON message(id_conversation, created_at);
CREATE INDEX idx_carnet_etudiant         ON carnet_liaison(id_etudiant);
CREATE INDEX idx_rdv_etudiant            ON rendez_vous(id_etudiant, date_rdv);
CREATE INDEX idx_rdv_prof                ON rendez_vous(id_professeur, date_rdv);


-- =============================================================
-- VUES UTILES
-- =============================================================

-- Vue : bilan vie scolaire par étudiant
CREATE OR REPLACE VIEW v_bilan_vie_scolaire AS
SELECT
    e.matricule,
    CONCAT(e.nom, ' ', e.prenoms)                AS etudiant,
    c.nom_classe                                  AS classe,
    COUNT(DISTINCT s.id_sanction)                 AS nb_sanctions,
    COUNT(DISTINCT r.id_recompense)               AS nb_recompenses,
    ROUND(AVG(co.note_comportement), 2)           AS moy_comportement,
    COUNT(DISTINCT ea.id_activite)                AS nb_activites
FROM etudiant e
JOIN classe c                     ON c.id_classe      = e.id_classe
LEFT JOIN sanction s              ON s.id_etudiant    = e.id_etudiant
    AND s.statut != 'annulée'
LEFT JOIN recompense r            ON r.id_etudiant    = e.id_etudiant
LEFT JOIN comportement co         ON co.id_etudiant   = e.id_etudiant
LEFT JOIN etudiant_activite ea    ON ea.id_etudiant   = e.id_etudiant
    AND ea.statut = 'actif'
GROUP BY e.id_etudiant, e.matricule, e.nom, e.prenoms, c.nom_classe;

-- Vue : notifications non lues par utilisateur
CREATE OR REPLACE VIEW v_notifications_non_lues AS
SELECT
    u.login,
    n.type_notification,
    n.titre,
    n.corps,
    n.canal,
    n.created_at
FROM notification n
JOIN utilisateur u ON u.id_utilisateur = n.id_destinataire
WHERE n.statut IN ('en_attente', 'envoyée')
ORDER BY n.created_at DESC;

-- Vue : derniers messages par conversation
CREATE OR REPLACE VIEW v_derniers_messages AS
SELECT
    cv.sujet,
    CONCAT(e.nom, ' ', e.prenoms)   AS expediteur,
    m.contenu,
    m.created_at                     AS date_message
FROM message m
JOIN conversation cv              ON cv.id_conversation = m.id_conversation
JOIN utilisateur  u               ON u.id_utilisateur   = m.id_expediteur
LEFT JOIN etudiant e              ON e.id_utilisateur   = u.id_utilisateur
ORDER BY m.created_at DESC;

-- Vue : rendez-vous à venir
CREATE OR REPLACE VIEW v_rdv_a_venir AS
SELECT
    rv.date_rdv,
    rv.type_rdv,
    rv.motif,
    rv.statut,
    CONCAT(e.nom, ' ', e.prenoms)   AS etudiant,
    CONCAT(t.nom, ' ', t.prenoms)   AS parent,
    CONCAT(p.nom, ' ', p.prenoms)   AS professeur
FROM rendez_vous rv
JOIN etudiant   e ON e.id_etudiant   = rv.id_etudiant
JOIN tuteur     t ON t.id_tuteur     = rv.id_tuteur
JOIN professeur p ON p.id_professeur = rv.id_professeur
WHERE rv.date_rdv >= NOW()
  AND rv.statut = 'confirmé'
ORDER BY rv.date_rdv ASC;


-- =============================================================
-- PROCEDURES STOCKÉES
-- =============================================================

DELIMITER $$

-- Proc : Envoyer une notification automatique d'absence
CREATE PROCEDURE notifier_absence(
    IN p_id_etudiant    CHAR(36),
    IN p_id_absence     CHAR(36)
)
BEGIN
    DECLARE v_id_tuteur_user CHAR(36);
    DECLARE v_nom_etudiant   VARCHAR(255);

    -- Récupérer le compte utilisateur du tuteur
    SELECT u.id_utilisateur,
           CONCAT(e.nom, ' ', e.prenoms)
    INTO   v_id_tuteur_user, v_nom_etudiant
    FROM   etudiant e
    JOIN   tuteur   t ON t.id_tuteur       = e.id_tuteur
    JOIN   utilisateur u ON u.id_utilisateur = t.id_utilisateur
    WHERE  e.id_etudiant = p_id_etudiant
    LIMIT 1;

    IF v_id_tuteur_user IS NOT NULL THEN
        INSERT INTO notification (
            id_notification, titre, corps,
            type_notification, canal, statut,
            id_destinataire, entite_liee, id_entite_liee
        ) VALUES (
            UUID(),
            CONCAT('Absence signalée — ', v_nom_etudiant),
            CONCAT('Une absence vient d\'être enregistrée pour ',
                   v_nom_etudiant, '. Veuillez vous connecter pour plus de détails.'),
            'absence', 'app', 'en_attente',
            v_id_tuteur_user, 'absence', p_id_absence
        );
    END IF;
END$$

-- Proc : Créer un rendez-vous et notifier les deux parties
CREATE PROCEDURE creer_rdv(
    IN p_id_etudiant    CHAR(36),
    IN p_id_tuteur      CHAR(36),
    IN p_id_professeur  CHAR(36),
    IN p_date_rdv       DATETIME,
    IN p_motif          VARCHAR(255),
    IN p_type           VARCHAR(30)
)
BEGIN
    DECLARE v_id_rdv        CHAR(36) DEFAULT UUID();
    DECLARE v_user_tuteur   CHAR(36);
    DECLARE v_user_prof     CHAR(36);

    INSERT INTO rendez_vous (
        id_rdv, date_rdv, motif, type_rdv, statut,
        id_etudiant, id_tuteur, id_professeur
    ) VALUES (
        v_id_rdv, p_date_rdv, p_motif, p_type, 'demandé',
        p_id_etudiant, p_id_tuteur, p_id_professeur
    );

    SELECT id_utilisateur INTO v_user_tuteur
    FROM tuteur WHERE id_tuteur = p_id_tuteur;

    SELECT id_utilisateur INTO v_user_prof
    FROM professeur WHERE id_professeur = p_id_professeur;

    -- Notifier le tuteur
    IF v_user_tuteur IS NOT NULL THEN
        INSERT INTO notification (id_notification, titre, corps,
            type_notification, canal, statut, id_destinataire,
            entite_liee, id_entite_liee)
        VALUES (UUID(), 'Nouveau rendez-vous planifié',
            CONCAT('Un rendez-vous est prévu le ', p_date_rdv,
                   ' — Motif : ', p_motif),
            'événement', 'app', 'en_attente',
            v_user_tuteur, 'rendez_vous', v_id_rdv);
    END IF;

    -- Notifier le professeur
    IF v_user_prof IS NOT NULL THEN
        INSERT INTO notification (id_notification, titre, corps,
            type_notification, canal, statut, id_destinataire,
            entite_liee, id_entite_liee)
        VALUES (UUID(), 'Rendez-vous avec un parent',
            CONCAT('Un rendez-vous parent est planifié le ', p_date_rdv,
                   ' — Motif : ', p_motif),
            'événement', 'app', 'en_attente',
            v_user_prof, 'rendez_vous', v_id_rdv);
    END IF;
END$$

DELIMITER ;

-- =============================================================
-- FIN DU SCRIPT EXTENSIONS
-- =============================================================
