document.addEventListener('DOMContentLoaded', function() {
    // User Avatar Dropdown functionality
    const userAvatarBtn = document.getElementById('userAvatarBtn');
    const userDropdown = document.getElementById('userDropdown');
    const notificationBtn = document.getElementById('notificationBtn');
    const notificationDropdown = document.getElementById('notificationDropdown');
    const helpBtn = document.getElementById('helpBtn');

    if (notificationBtn && notificationDropdown){
        document.addEventListener('click', function(e) {
            if (
                notificationBtn &&
                notificationDropdown &&
                !notificationDropdown.contains(e.target)
            ) {
                if (notificationDropdown.classList.contains('show')) {
                    notificationDropdown.classList.remove('show');
                }
            }
        });
        
        notificationBtn.addEventListener('click', function(e) {
            e.stopPropagation();
        });
    }
    
    if (userAvatarBtn && userDropdown) {
        // Toggle dropdown when clicking avatar button
        userAvatarBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            userDropdown.classList.toggle('show');
        });

        // Close dropdown when clicking outside
        document.addEventListener('click', function(e) {
            if(userDropdown.classList.contains('show')){
                if (!userAvatarBtn.contains(e.target) && !userDropdown.contains(e.target)) {
                    userDropdown.classList.remove('show');
                }
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

    const sidebar = document.querySelector(".sidebar");
    const toggleButtons = document.querySelectorAll(".toggle-btn, .sidebar-toggle");

    if (!sidebar)
        return;

    // Apply saved state
    const savedState = localStorage.getItem('sidebarState') || 'expanded';
    sidebar.classList.toggle('collapsed', savedState === 'collapsed');

    toggleButtons.forEach(btn => {
        btn.addEventListener("click", function () {
            sidebar.classList.toggle("collapsed");
            const isCollapsed = sidebar.classList.contains("collapsed");
            localStorage.setItem('sidebarState', isCollapsed ? 'collapsed' : 'expanded');
        });
    });

    // Other button functionalities
    const bookmarkBtn = document.getElementById('bookmarkBtn');



    if (bookmarkBtn) {
        bookmarkBtn.addEventListener('click', function() {
            console.log('Bookmark clicked');
            // Add bookmark functionality here
        });
    }

    if (notificationBtn) {
        notificationBtn.addEventListener('click', function() {
            
        });
    }

    if (helpBtn) {
        helpBtn.addEventListener('click', function() {
            console.log('Help clicked');
            // Add help functionality here
        });
    }
});

function toggleDropdown() {
    const dropdown = document.getElementById("notificationDropdown");
    dropdown.classList.toggle("show");
    if (dropdown.classList.contains("show")) {
        loadNotifications();
    }
}

function loadNotifications() {
    fetch(`${contextPath}/notifications?action=view`)
        .then(res => res.json())
        .then(data => {
            const list = document.getElementById("notificationList");
            list.innerHTML = "";

            let unreadCount = 0;
            data.forEach(notification => {
                const li = document.createElement("li");
                li.textContent = notification.message;
                if (!notification.isRead) {
                    li.classList.add("unread");
                    unreadCount++;
                } else li.classList.add("read");
                list.appendChild(li);
            });
        });
}

function markAllRead(event) {
    event.stopPropagation();
    fetch(`${contextPath}/notifications?action=markAllRead`)
        .then(() => loadNotifications());
}

function markAllUnread(event) {
    event.stopPropagation();
    fetch(`${contextPath}/notifications?action=markAllUnread`)
        .then(() => loadNotifications());
}