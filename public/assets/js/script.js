/* ============================================================
     ROLE CONFIGURATIONS
  ============================================================ */
  const roles = {
    directeur: {
      nav: 'nav-directeur',
      url: '/directeur/dashboard'
    },
    secretariat: {
      nav: 'nav-secretariat',
      url: '/secretariat/paiement'
    },
    professeur: {
      nav: 'nav-professeur',
      url: '/professeur/calendar'
    },
    etudiant: {
      nav: 'nav-etudiant',
      url: '/etudiant/calendar'
    }
  };

  const pageTitles = {
    'dir-dashboard': 'Tableau de bord',
    'dir-finances': 'Finances & Bénéfices',
    'dir-professeurs': 'Corps Professoral',
    'dir-prof-profil': 'Profil Professeur',
    'dir-ecolages': 'Écolages du Mois',
    'sec-paiements': 'Ajouter un Paiement',
    'sec-bilan': 'Bilan de Paiement',
    'sec-eleves': 'Liste des Élèves',
    'sec-profils': 'Profil Élève',
    'prof-emploi': 'Emploi du Temps',
    'prof-notes': 'Notes des Élèves',
    'prof-devoirs': 'Devoirs & Leçons',
    'prof-bulletins': 'Bulletins',
    'prof-profil': 'Mon Profil',
    'etu-emploi': 'Mon Emploi du Temps',
    'etu-notes': 'Mes Notes',
    'etu-bulletin': 'Mon Bulletin',
    'etu-devoirs': 'Devoirs & Leçons',
    'actualites': 'Actualités',
    'notifications-page': 'Notifications',
  };

  const pageRoles = {
    'dir-dashboard': 'directeur',
    'dir-finances': 'directeur',
    'dir-professeurs': 'directeur',
    'dir-prof-profil': 'directeur',
    'dir-ecolages': 'directeur',
    'sec-paiements': 'secretariat',
    'sec-bilan': 'secretariat',
    'sec-eleves': 'secretariat',
    'sec-profils': 'secretariat',
    'prof-emploi': 'professeur',
    'prof-notes': 'professeur',
    'prof-devoirs': 'professeur',
    'prof-bulletins': 'professeur',
    'prof-profil': 'professeur',
    'etu-emploi': 'etudiant',
    'etu-notes': 'etudiant',
    'etu-bulletin': 'etudiant',
    'etu-devoirs': 'etudiant',
    'actualites': null,
    'notifications-page': null,
  };

  const roleStorageKey = 'lyceepro.activeRole';

  function applyRole(roleKey, persist = true) {
    const r = roles[roleKey];
    if (!r) return;

    if (persist) {
      localStorage.setItem(roleStorageKey, roleKey);
    }

    document.body.dataset.activeRole = roleKey;

    // Changer la navigation affichée
    document.querySelectorAll('.nav-section').forEach(nav => {
      nav.style.display = nav.id === r.nav ? 'block' : 'none';
    });

    // Changer la valeur du select
    const roleSelect = document.getElementById('roleSelect');
    if (roleSelect) roleSelect.value = roleKey;
    
    // NE PAS TOUCHER AUX NOMS/INITIALES - PHP les gère
  }

  function getRoleFromPage(pageId) {
    return pageRoles[pageId] || null;
  }

  function syncHeaderToPage(pageId) {
    if (!pageId) return;

    const title = pageTitles[pageId] || 'LycéePro';
    const topbarTitle = document.getElementById('topbar-title');
    if (topbarTitle) {
      topbarTitle.textContent = title;
    }

    document.querySelectorAll('.nav-item.active').forEach(item => item.classList.remove('active'));
    const activeLink = document.querySelector(`.nav-item[data-page="${pageId}"]`);
    if (activeLink) {
      activeLink.classList.add('active');
    }
  }

  function switchRole(roleKey) {
    const r = roles[roleKey];
    if (!r) return;
    applyRole(roleKey, true);
    window.location.href = r.url;
  }

  function showPage(pageId) {
    const target = document.getElementById(pageId);
    if (!target) return;

    const sections = document.querySelectorAll('.page-section');
    if (sections.length > 1) {
      sections.forEach(s => s.classList.remove('active'));
    }
    target.classList.add('active');
    syncHeaderToPage(pageId);
  }

  /* ============================================================
     MODALS
  ============================================================ */
  function openModal(id) {
    document.getElementById(id).classList.add('open');
  }
  function closeModal(id) {
    document.getElementById(id).classList.remove('open');
  }

  document.querySelectorAll('.modal-backdrop').forEach(backdrop => {
    backdrop.addEventListener('click', (e) => {
      if (e.target === backdrop) backdrop.classList.remove('open');
    });
  });

  /* ============================================================
     NOTIFICATIONS
  ============================================================ */
  function toggleNotif() {
    document.getElementById('notif-dropdown').classList.toggle('open');
  }

  document.addEventListener('click', (e) => {
    const dropdown = document.getElementById('notif-dropdown');
    if (!e.target.closest('.topbar-btn') || !dropdown.contains(e.target)) {
      dropdown.classList.remove('open');
    }
  });

  /* ============================================================
     TOAST
  ============================================================ */
  function showToast(message, duration = 3000) {
    const container = document.getElementById('toast-container');
    const toast = document.createElement('div');
    toast.className = 'toast';
    toast.innerHTML = message;
    container.appendChild(toast);
    setTimeout(() => {
      toast.style.opacity = '0';
      toast.style.transform = 'translateX(20px)';
      setTimeout(() => toast.remove(), 300);
    }, duration);
  }

  /* ============================================================
     FILTER PILLS
  ============================================================ */
  document.querySelectorAll('.filter-pills').forEach(group => {
    group.querySelectorAll('.pill').forEach(pill => {
      pill.addEventListener('click', () => {
        group.querySelectorAll('.pill').forEach(p => p.classList.remove('active'));
        pill.classList.add('active');
      });
    });
  });

  /* ============================================================
     TABS
  ============================================================ */
  document.querySelectorAll('.tabs').forEach(tabs => {
    tabs.querySelectorAll('.tab').forEach(tab => {
      tab.addEventListener('click', () => {
        tabs.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
        tab.classList.add('active');
      });
    });
  });

  /* ============================================================
     KEYBOARD
  ============================================================ */
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      document.querySelectorAll('.modal-backdrop.open').forEach(m => m.classList.remove('open'));
      document.getElementById('notif-dropdown').classList.remove('open');
    }
  });

  /* ============================================================
     INIT
  ============================================================ */
  window.addEventListener('DOMContentLoaded', () => {
    const activePage = document.body.dataset.activePage;
    const activeSection = activePage ? document.getElementById(activePage) : document.querySelector('.page-section.active');
    if (activeSection) {
      activeSection.classList.add('active');
    }

    const storedRole = localStorage.getItem(roleStorageKey);
    const pageRole = getRoleFromPage(activePage);
    const finalRole = pageRole || storedRole || document.body.dataset.activeRole || 'directeur';
    
    applyRole(finalRole, false);
    syncHeaderToPage(activePage || (activeSection && activeSection.id));

    setTimeout(() => showToast('👋 Bienvenue sur LycéePro !'), 800);
  });