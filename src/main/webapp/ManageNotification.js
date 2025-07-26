const userId = '<%= session.getAttribute("userId") %>';

function loadAllNotifications() {
    fetch(`${contextPath}/managenotifications?action=getByCreatedUser`)
        .then(response => response.json())
        .then(data => {
            const wrapper = document.getElementById('projectNotificationsWrapper');
            wrapper.innerHTML = '';

            if (Object.keys(data).length === 0) {
                wrapper.innerHTML = '<p>No notifications available.</p>';
                return;
            }

            for (const [projectName, info] of Object.entries(data)) {
                const notifications = info.notifications;
                const projectId = info.projectId;
                projectNameToId[projectName] = projectId;
                const section = document.createElement('div');
                section.classList.add('project-section');

                const header = document.createElement('h3');
                header.textContent = projectName;
                section.appendChild(header);

                // Add button
                const addBtn = document.createElement('button');
                addBtn.textContent = 'Add Notification';
                addBtn.classList.add('add-btn');
                addBtn.onclick = () => openAddModal(projectName);
                section.appendChild(addBtn);

                if (notifications.length === 0) {
                    section.innerHTML += '<p>No notifications for this project.</p>';
                } else {
                    const table = document.createElement('table');
                    table.classList.add('notification-table');

                    const thead = document.createElement('thead');
                    thead.innerHTML = `
                        <tr>
                            <th>ID</th>
                            <th>Message</th>
                            <th>Created At</th>
                            <th>Actions</th>
                        </tr>`;
                    table.appendChild(thead);

                    const tbody = document.createElement('tbody');

                    notifications.forEach(n => {
                        const row = document.createElement('tr');

                        row.innerHTML = `
                            <td>${n.projectNotificationId}</td>
                            <td>${n.message}</td>
                            <td>${new Date(n.createdAt).toLocaleString()}</td>
                            <td>
                                <button onclick="deleteNotification(${n.projectNotificationId})">Delete</button>
                            </td>
                        `;

                        tbody.appendChild(row);
                    });

                    table.appendChild(tbody);
                    section.appendChild(table);
                }

                wrapper.appendChild(section);
            }
        })
        .catch(error => {
            console.error('Error loading notifications:', error);
        });
}

// Keep track of project name to ID mapping
let projectNameToId = {};

function openAddModal(projectName) {
    const modal = document.getElementById('addNotificationModal');
    const textarea = document.getElementById('notificationMessage');
    const hiddenInput = document.getElementById('modalProjectId');

    // Find the corresponding projectId by name
    const projectId = projectNameToId[projectName];
    hiddenInput.value = projectId;

    textarea.value = '';
    modal.classList.remove('hidden');
}

function closeAddModal() {
    document.getElementById('addNotificationModal').classList.add('hidden');
}

// Submit handler
document.getElementById('addNotificationForm').addEventListener('submit', function (e) {
    e.preventDefault();
    const projectId = document.getElementById('modalProjectId').value;
    const message = document.getElementById('notificationMessage').value;

    fetch(`${contextPath}/managenotifications?action=add&projectId=${encodeURIComponent(projectId)}&message=${encodeURIComponent(message)}`)
    .then(() => {
        closeAddModal();
        loadAllNotifications(); // Refresh list
    })
    .catch(error => console.error('Error adding notification:', error));
});

// Close modal on X click
document.getElementById('closeModal').addEventListener('click', closeAddModal);

function editNotification(id) {
    const messageSpan = document.querySelector(`.editable[data-id="${id}"]`);
    const newMessage = messageSpan.textContent.trim();

    fetch(`${contextPath}/notifications?action=edit`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `notificationId=${id}&message=${encodeURIComponent(newMessage)}`
    }).then(() => {
        loadAllNotifications();
    });
}

function deleteNotification(id) {
    if (!confirm("Are you sure you want to delete this notification?")) return;

    fetch(`${contextPath}/managenotifications?action=delete&id=${id}`)
    .then(() => {
        loadAllNotifications();
    });
}


// Initial load
loadAllNotifications();