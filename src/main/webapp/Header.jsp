<% session.setAttribute("userId", (Integer)user.getUserId());%>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/header-sidebar.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/Notification.css">
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
    function toggleDropdown() {
        const dropdown = document.getElementById("notificationDropdown");
        dropdown.classList.toggle("show");
        if (dropdown.classList.contains("show")) {
            loadNotifications();
        }
    }

    function loadNotifications() {
        fetch('${pageContext.request.contextPath}/notifications?action=view')
            .then(res => res.json())
            .then(data => {
                const list = document.getElementById("notificationList");
                const countEl = document.getElementById("notificationCount");
                list.innerHTML = "";

                let unreadCount = 0;
                data.forEach(notification => {
                    const li = document.createElement("li");
                    li.textContent = notification.message;
                    if (!notification.isRead) {
                        li.classList.add("unread");
                        unreadCount++;
                    }
                    else li.classList.add("read");
                    list.appendChild(li);
                });

                if (unreadCount > 0) {
                    countEl.style.display = "inline-block";
                    countEl.textContent = unreadCount;
                } else {
                    countEl.style.display = "none";
                }
            });
    }

    function markAllRead(event) {
        event.stopPropagation();
        fetch('${pageContext.request.contextPath}/notifications?action=markAllRead')
            .then(() => loadNotifications());
    }

    function markAllUnread(event) {
        event.stopPropagation();
        fetch('${pageContext.request.contextPath}/notifications?action=markAllUnread')
            .then(() => loadNotifications());
    }
</script>