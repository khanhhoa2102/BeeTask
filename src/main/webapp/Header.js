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
}

function loadNotifications() {
    fetch(`${contextPath}/notifications?action=view`)
        .then(res => res.json())
        .then(data => {
            const list = document.getElementById("systemSection");
            list.innerHTML = "";

            let unreadCount = 0;
            data.forEach(notification => {
                const li = document.createElement("li");
                li.classList.add("notification-item");

                // ✅ Create Message Div
                const messageDiv = document.createElement("span");
                messageDiv.textContent = notification.message;

                // ✅ Create Button Container
                const buttonDiv = document.createElement("div");
                buttonDiv.classList.add("notification-buttons");

                // Toggle Read/Unread Button
                const toggleBtn = document.createElement("button");
                toggleBtn.textContent = notification.isRead ? "Mark as Unread" : "Mark as Read";
                toggleBtn.addEventListener("click", function (e) {
                    e.stopPropagation();
                    if (notification.isRead) {
                        markNotificationAsUnread(notification.notificationId);
                    } else {
                        markNotificationAsRead(notification.notificationId);
                    }
                });

                // Delete Button
                const deleteBtn = document.createElement("button");
                deleteBtn.textContent = "Delete";
                deleteBtn.addEventListener("click", function (e) {
                    e.stopPropagation();
                    deleteNotification(notification.notificationId);
                });

                buttonDiv.appendChild(toggleBtn);
                buttonDiv.appendChild(deleteBtn);

                // Apply read/unread styling
                if (!notification.isRead) {
                    li.classList.add("unread");
                    unreadCount++;
                } else {
                    li.classList.add("read");
                }

                li.appendChild(messageDiv);
                li.appendChild(buttonDiv);
                list.appendChild(li);
            });

            document.getElementById("unreadCount").textContent = unreadCount > 0 ? unreadCount : "";
        });
}

function toggleSection(sectionId) {
    const section = document.getElementById(sectionId);
    section.classList.toggle("collapsed");
    const toggleBtn = section.previousElementSibling;
    toggleBtn.textContent = section.classList.contains("collapsed") ? "▶ System" : "▼ System";
}

function markAllRead(){
    fetch(`${contextPath}/notifications?action=markAllRead`)
        .then(res => res.text())
        .then(response => {
            if (response === "OK") {
                loadNotifications();
                loadProjectNotifications();
            }
        });
}

function markAllUnread(){
    fetch(`${contextPath}/notifications?action=markAllUnread`)
        .then(res => res.text())
        .then(response => {
            if (response === "OK") {
                loadNotifications();
                loadProjectNotifications();
            }
        });
}

function markNotificationAsRead(id) {
    fetch(`${contextPath}/notifications?action=markAsRead&id=${id}`)
        .then(res => res.text())
        .then(response => {
            if (response === "OK") {
                loadNotifications(); // Reload updated list
            }
        });
}

function markNotificationAsUnread(id) {
    fetch(`${contextPath}/notifications?action=markAsUnread&id=${id}`)
        .then(res => res.text())
        .then(response => {
            if (response === "OK") {
                loadNotifications(); // Reload updated list
            }
        });
}

function deleteNotification(id) {
    fetch(`${contextPath}/notifications?action=delete&id=${id}`)
        .then(res => res.text())
        .then(response => {
            if (response === "OK") {
                loadNotifications(); // Refresh after deletion
            }
        });
}

function loadProjectNotifications() {
    fetch(`${contextPath}/projectnotifications?action=getByUserId`)
        .then(response => response.json())
        .then(data => {
            const notificationList = document.getElementById('notificationList');
            notificationList.innerHTML = '';

            for (const [projectName, info] of Object.entries(data)) {
                const notifications = info.notifications;
                
                const section = document.createElement('div');
                section.classList.add('notification-section');

                const header = document.createElement('button');
                header.classList.add('section-toggle');
                header.innerHTML = `▶ ${projectName}`;
                header.onclick = () => {
                    list.classList.toggle('collapsed');
                    header.innerHTML = `${list.classList.contains('collapsed') ? '▶' : '▼'} ${projectName}`;
                };

                const list = document.createElement('ul');
                list.classList.add('notification-section-content');

                notifications.forEach(n => {
                    const item = document.createElement('li');
                    item.classList.add('notification-item');
                    item.classList.add(n.isRead ? 'read' : 'unread');

                    const message = document.createElement('div');
                    message.classList.add('notification-message');
                    message.textContent = n.message;

                    const btnGroup = document.createElement('div');
                    btnGroup.classList.add('notification-buttons');

                    const toggleBtn = document.createElement('button');
                    toggleBtn.textContent = n.isRead ? 'Mark as Unread' : 'Mark as Read';
                    toggleBtn.onclick = () => toggleRead(n.projectNotificationId, !n.isRead);

                    const deleteBtn = document.createElement('button');
                    deleteBtn.textContent = 'Delete';
                    deleteBtn.onclick = () => deleteNotification(n.projectNotificationId);

                    btnGroup.append(toggleBtn, deleteBtn);
                    item.append(message, btnGroup);
                    list.appendChild(item);
                });

                section.append(header, list);
                notificationList.appendChild(section);
            }
        });
}


function toggleRead(notificationId, isRead) {
    fetch(`${contextPath}/projectnotifications?action=${isRead ? 'markRead' : 'markUnread'}&id=${notificationId}`)
            .then(() => loadProjectNotifications());
}

function deleteNotification(notificationId) {
    fetch(`${contextPath}/projectnotifications?action=deleteByUser&id=${notificationId}`)
        .then(() => loadProjectNotifications());
}

loadNotifications();
loadProjectNotifications();

setInterval(loadNotifications, 30000);
setInterval(loadProjectNotifications, 30000);