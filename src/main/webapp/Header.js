document.addEventListener('DOMContentLoaded', function() {
    // User Avatar Dropdown functionality
    const userAvatarBtn = document.getElementById('userAvatarBtn');
    const userDropdown = document.getElementById('userDropdown');

    if (userAvatarBtn && userDropdown) {
        // Toggle dropdown when clicking avatar button
        userAvatarBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            userDropdown.classList.toggle('show');
        });

        // Close dropdown when clicking outside
        document.addEventListener('click', function(e) {
            if (!userAvatarBtn.contains(e.target) && !userDropdown.contains(e.target)) {
                userDropdown.classList.remove('show');
            }
        });

        // Prevent dropdown from closing when clicking inside it
        userDropdown.addEventListener('click', function(e) {
            e.stopPropagation();
        });
    }

    // Dark Mode Toggle functionality
    const darkModeToggle = document.getElementById('darkModeToggle');
    if (darkModeToggle) {
        // Load saved theme
        const savedTheme = localStorage.getItem('theme') || 'light';
        if (savedTheme === 'dark') {
            document.body.classList.add('dark-mode');
            darkModeToggle.checked = true;
        }

        darkModeToggle.addEventListener('change', function() {
            if (this.checked) {
                document.body.classList.add('dark-mode');
                localStorage.setItem('theme', 'dark');
            } else {
                document.body.classList.remove('dark-mode');
                localStorage.setItem('theme', 'light');
            }
        });
    }

    // Sidebar toggle functionality
    const toggleBtn = document.querySelector('.toggle-btn');
    const sidebar = document.querySelector('.sidebar');
    const container = document.querySelector('.container');

    if (toggleBtn && sidebar && container) {
        toggleBtn.addEventListener('click', function () {
            sidebar.classList.toggle('collapsed');
            container.classList.toggle('sidebar-collapsed');
        });
    }

    // Other button functionalities
    const bookmarkBtn = document.getElementById('bookmarkBtn');
    const notificationBtn = document.getElementById('notificationBtn');
    const helpBtn = document.getElementById('helpBtn');

    if (bookmarkBtn) {
        bookmarkBtn.addEventListener('click', function() {
            console.log('Bookmark clicked');
            // Add bookmark functionality here
        });
    }

    if (notificationBtn) {
        notificationBtn.addEventListener('click', function() {
            console.log('Notification clicked');
            // Add notification functionality here
        });
    }

    if (helpBtn) {
        helpBtn.addEventListener('click', function() {
            console.log('Help clicked');
            // Add help functionality here
        });
    }
});

