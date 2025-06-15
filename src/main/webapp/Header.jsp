<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/header-sidebar.css">
<script>
    window.addEventListener('DOMContentLoaded', () => {
        // Áp d?ng theme
        const savedTheme = localStorage.getItem('theme') || 'dark-mode';
        if (savedTheme === 'dark-mode') {
            document.body.classList.add('dark-mode');
            const toggle = document.getElementById('darkModeToggle');
            if (toggle) toggle.checked = true;
        } else {
            document.body.classList.remove('dark-mode');
            const toggle = document.getElementById('darkModeToggle');
            if (toggle) toggle.checked = false;
        }

        // Áp d?ng tr?ng thái sidebar
        const savedSidebarState = localStorage.getItem('sidebarState') || 'expanded';
        const sidebar = document.querySelector('.sidebar');
        if (sidebar) {
            if (savedSidebarState === 'collapsed') {
                sidebar.classList.add('collapsed');
            } else {
                sidebar.classList.remove('collapsed');
            }
        }

        // X? lý s? ki?n thay ??i theme
        const darkModeToggle = document.getElementById('darkModeToggle');
        if (darkModeToggle) {
            darkModeToggle.addEventListener('change', () => {
                const isDarkMode = darkModeToggle.checked;
                document.body.classList.toggle('dark-mode', isDarkMode);
                localStorage.setItem('theme', isDarkMode ? 'dark-mode' : 'light-mode');
                console.log('Dark Mode:', isDarkMode);
            });
        } else {
            console.warn('Ph?n t? #darkModeToggle không t?n t?i.');
        }
    });
</script>