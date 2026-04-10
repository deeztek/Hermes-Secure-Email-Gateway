
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2021. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

    Hermes Secure Email Gateway Community Edition is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Hermes Secure Email Gateway Community Edition is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Hermes Secure Email Gateway Community Edition.  If not, see <https://www.gnu.org/licenses/agpl.html>.
--->

<!-- Fonts -->
<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/@fontsource/source-sans-3@5.0.12/index.css"
      integrity="sha256-tXJfXfp6Ewt1ilPzLDtQnJV4hclT9XuaZUKyUvmyr+Q="
      crossorigin="anonymous">

<!-- OverlayScrollbars CSS -->
<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/overlayscrollbars@2.11.0/styles/overlayscrollbars.min.css"
      crossorigin="anonymous">

<!-- Bootstrap Icons -->
<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
      crossorigin="anonymous">

<!-- Font Awesome 6 Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.5.1/css/all.min.css" crossorigin="anonymous">

<!-- AdminLTE 4 CSS -->
<link rel="stylesheet" href="/dist/css/adminlte.min.css">

<!-- Custom CSS overrides for AdminLTE 4 -->
<style>
/* Preloader styling */
.preloader {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(255, 255, 255, 0.7);
  z-index: 9999;
  display: flex;
  justify-content: center;
  align-items: center;
}

/* User panel styling */
.user-panel {
  border-bottom: 1px solid #4f5962;
  justify-content: center;
}
.user-panel .image img {
  width: 2.1rem;
  height: 2.1rem;
  border-radius: 50%;
}
.user-panel .info {
  padding-left: 0.5rem;
}
.user-panel .info a {
  color: #c2c7d0;
}

/* Remove underline from sidebar links */
.app-sidebar a {
  text-decoration: none;
}

/* Elevation shadow class */
.elevation-2 {
  box-shadow: 0 3px 6px rgba(0,0,0,.16), 0 3px 6px rgba(0,0,0,.23);
}

/* Layout fix - ensure proper full-height sidebar */
html, body {
  height: 100%;
}

.app-wrapper {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

/* Sidebar full height - use fixed positioning */
.app-sidebar {
  position: fixed !important;
  top: 0 !important;
  left: 0 !important;
  bottom: 0 !important;
  height: 100vh !important;
  width: 250px !important;
  z-index: 1038 !important;
  overflow-y: auto;
  transition: left 0.3s ease-in-out, transform 0.3s ease-in-out;
}

/* Adjust main content and header to account for fixed sidebar */
.app-header {
  margin-left: 250px;
  transition: margin-left 0.3s ease-in-out;
}

.app-main {
  margin-left: 250px;
  flex: 1;
  transition: margin-left 0.3s ease-in-out;
}

/* Footer positioning - starts after sidebar */
.app-footer {
  margin-left: 250px;
  transition: margin-left 0.3s ease-in-out;
}

/* Desktop: sidebar-collapse hides the sidebar */
.sidebar-collapse .app-sidebar {
  left: -250px !important;
  margin-left: -250px !important;
}
.sidebar-collapse .app-header {
  margin-left: 0;
}
.sidebar-collapse .app-main {
  margin-left: 0;
}
.sidebar-collapse .app-footer {
  margin-left: 0;
}

/* Mobile breakpoint (max-width: 991.98px) */
@media (max-width: 991.98px) {
  /* Default: sidebar hidden on mobile */
  .app-sidebar {
    left: -250px !important;
  }
  .app-header {
    margin-left: 0;
  }
  .app-main {
    margin-left: 0;
  }
  .app-footer {
    margin-left: 0;
  }

  /* When sidebar-open is added (mobile menu toggle), show the sidebar */
  .sidebar-open .app-sidebar {
    left: 0 !important;
  }

  /* Sidebar overlay for mobile - appears behind sidebar to close it when tapped */
  .sidebar-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 1037;
    display: none;
  }
  .sidebar-open .sidebar-overlay {
    display: block;
  }
}

/* Modal backdrop - translucent background */
.modal-backdrop {
  background-color: rgba(0, 0, 0, 0.5) !important;
}
.modal-backdrop.show {
  opacity: 1 !important;
}

/* Card padding for forms - provides default padding when forms are direct children of cards */
.card > form,
.card > .form-group,
.card > .col-sm-6,
.card > .col-sm-8,
.card > div:first-child:not(.card-header):not(.card-body) {
  padding: 1rem;
}

/* Card spacing - adds margin between consecutive cards */
.card.col-sm-8 {
  margin-bottom: 1.5rem;
}

/* Fix link colors in content areas - should be dark/primary, not white */
.app-main a:not(.btn):not(.nav-link):not(.dropdown-item):not(.page-link):not(.paginate_button) {
  color: #0d6efd;
}
.app-main a:not(.btn):not(.nav-link):not(.dropdown-item):not(.page-link):not(.paginate_button):hover {
  color: #0a58ca;
}

/* Ensure DataTables pagination buttons have correct text color */
.paginate_button.current,
.paginate_button.current:hover {
  color: #fff !important;
}
.paginate_button:not(.current) {
  color: #0d6efd !important;
}
.paginate_button:not(.current):hover {
  color: #0a58ca !important;
}

/* Fix for links inside cards and content */
.card-body a:not(.btn):not(.page-link),
.content a:not(.btn):not(.page-link),
.container-fluid a:not(.btn):not(.nav-link):not(.page-link) {
  color: #0d6efd;
}
.card-body a:not(.btn):not(.page-link):hover,
.content a:not(.btn):not(.page-link):hover,
.container-fluid a:not(.btn):not(.nav-link):not(.page-link):hover {
  color: #0a58ca;
}

/* Ensure Bootstrap pagination active page has white text */
.page-item.active .page-link {
  color: #fff !important;
}

/* Fix button padding - ensure proper padding for all btn elements */
.btn {
  padding: 0.375rem 0.75rem;
}
input[type="submit"].btn,
button[type="submit"].btn {
  padding: 0.375rem 0.75rem;
  margin-top: 1rem;
}

/* Ensure btn-primary has visible styling */
.btn-primary {
  background-color: #0d6efd;
  border-color: #0d6efd;
  color: #fff;
  padding: 0.375rem 0.75rem;
}
.btn-primary:hover {
  background-color: #0b5ed7;
  border-color: #0a58ca;
  color: #fff;
}

/* Form element spacing */
.form-group {
  margin-bottom: 1rem;
}
.form-control {
  margin-bottom: 0.5rem;
}
</style>

<!-- jQuery UI CSS -->
<link rel="stylesheet" href="/plugins/jquery-ui/jquery-ui.min.css">

<!-- DataTables Bootstrap 5 CSS -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.bootstrap5.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.bootstrap5.min.css">

<!-- DataTables Checkboxes CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jquery-datatables-checkboxes@1.2.14/css/dataTables.checkboxes.css">

<!-- Tempus Dominus 6 Datetimepicker CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@eonasdan/tempus-dominus@6.9.4/dist/css/tempus-dominus.min.css" crossorigin="anonymous">

<!-- Tom Select CSS (searchable dropdowns) -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/tom-select@2.4.3/dist/css/tom-select.bootstrap5.min.css" crossorigin="anonymous">

<!-- Favicon -->
<link rel="icon" href="favicon.ico" type="image/x-icon">
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">

<!-- REQUIRED SCRIPTS -->

<!-- jQuery -->
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"
        integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
        crossorigin="anonymous"></script>

<!-- jQuery UI -->
<script src="/plugins/jquery-ui/jquery-ui.min.js"></script>

<!-- OverlayScrollbars JS -->
<script src="https://cdn.jsdelivr.net/npm/overlayscrollbars@2.11.0/browser/overlayscrollbars.browser.es6.min.js"
        crossorigin="anonymous"></script>

<!-- Popper.js (required for Bootstrap 5) -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"
        crossorigin="anonymous"></script>

<!-- Bootstrap 5 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.min.js"
        crossorigin="anonymous"></script>

<!-- AdminLTE 4 JS -->
<script src="/dist/js/adminlte.min.js"></script>

<!-- OverlayScrollbars Configuration and Preloader -->
<script>
document.addEventListener('DOMContentLoaded', function () {
  // OverlayScrollbars for sidebar
  const sidebarWrapper = document.querySelector('.sidebar-wrapper');
  if (sidebarWrapper && typeof OverlayScrollbarsGlobal !== 'undefined') {
    OverlayScrollbarsGlobal.OverlayScrollbars(sidebarWrapper, {
      scrollbars: {
        theme: 'os-theme-light',
        autoHide: 'leave',
        clickScroll: true,
      },
    });
  }

  // Hide preloader after page fully loads
  const preloader = document.querySelector('.preloader');
  if (preloader) {
    preloader.style.transition = 'opacity 0.5s ease';
    preloader.style.opacity = '0';
    setTimeout(function() {
      preloader.style.display = 'none';
    }, 500);
  }

// Show preloader when navigating to a new page (using event delegation for dynamic links)
document.addEventListener('click', function(e) {
  const link = e.target.closest('a[href]');
  if (!link) return;

  const href = link.getAttribute('href');
  // Only show preloader for internal navigation links (not #, javascript:, external, or new window)
  if (href &&
      !href.startsWith('#') &&
      !href.startsWith('javascript:') &&
      !link.getAttribute('target') &&
      !link.getAttribute('data-bs-toggle') &&
      !href.startsWith('http://') &&
      !href.startsWith('https://')) {
    const preloader = document.querySelector('.preloader');
    if (preloader) {
      preloader.style.transition = 'none';
      preloader.style.display = 'flex';
      preloader.style.opacity = '1';
    }
  }
});

  // Show preloader on form submit
  document.querySelectorAll('form').forEach(function(form) {
    form.addEventListener('submit', function() {
      const preloader = document.querySelector('.preloader');
      if (preloader) {
        preloader.style.display = 'flex';
        preloader.style.opacity = '1';
      }
    });
  });
});

// Show preloader on page unload (browser navigation)
window.addEventListener('beforeunload', function() {
  const preloader = document.querySelector('.preloader');
  if (preloader) {
    preloader.style.display = 'flex';
    preloader.style.opacity = '1';
  }
});
</script>

<!-- Moment.js -->
<script src="/plugins/moment/moment.min.js"></script>

<!-- Tempus Dominus 6 Datetimepicker -->
<script src="https://cdn.jsdelivr.net/npm/@eonasdan/tempus-dominus@6.9.4/dist/js/tempus-dominus.min.js" crossorigin="anonymous"></script>

<!-- Tom Select JS (searchable dropdowns) -->
<script src="https://cdn.jsdelivr.net/npm/tom-select@2.4.3/dist/js/tom-select.complete.min.js" crossorigin="anonymous"></script>

<!-- InputMask -->
<script src="/plugins/inputmask/jquery.inputmask.min.js"></script>

<!-- DateRange Picker -->
<script src="/plugins/daterangepicker/daterangepicker.js"></script>

<!-- Bootstrap ColorPicker -->
<script src="/plugins/bootstrap-colorpicker/js/bootstrap-colorpicker.min.js"></script>

<!-- DataTables Core -->
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>

<!-- DataTables Responsive -->
<script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
<script src="https://cdn.datatables.net/responsive/2.5.0/js/responsive.bootstrap5.min.js"></script>

<!-- DataTables Buttons -->
<script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.bootstrap5.min.js"></script>

<!-- DataTables Buttons Dependencies -->
<script src="/plugins/jszip/jszip.min.js"></script>
<script src="/plugins/pdfmake/pdfmake.min.js"></script>
<script src="/plugins/pdfmake/vfs_fonts.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.colVis.min.js"></script>

<!-- DataTables Checkboxes -->
<script src="https://cdn.jsdelivr.net/npm/jquery-datatables-checkboxes@1.2.14/js/dataTables.checkboxes.min.js"></script>
