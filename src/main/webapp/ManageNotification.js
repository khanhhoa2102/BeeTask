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
                    const noNotifText = document.createElement('p');
                    noNotifText.textContent = 'No notifications for this project.';
                    section.appendChild(noNotifText);
                } else {
                    const table = document.createElement('table');
                    table.classList.add('notification-table');

                    const thead = document.createElement('thead');
                    thead.innerHTML = `
                        <tr>
                            <th>Message</th>
                            <th>Created At</th>
                            <th>Actions</th>
                        </tr>`;
                    table.appendChild(thead);

                    const tbody = document.createElement('tbody');

                    notifications.forEach(n => {
                        const row = document.createElement('tr');

                        row.innerHTML = `
                            <td class="message-cell">${n.message}</td>
                            <td>${new Date(n.createdAt).toLocaleString()}</td>
                            <td>
                                <button onclick="openEditModal(${n.projectNotificationId}, \`${n.message.replace(/`/g, '\\`')}\`, ${projectId})">Edit</button>
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
let isEditing = false;

function openAddModal(projectName) {
    isEditing = false;
    document.getElementById('modalTitle').textContent = 'Add Notification';
    document.getElementById('submitButton').textContent = 'Add';
    
    const modal = document.getElementById('addNotificationModal');
    const textarea = document.getElementById('notificationMessage');
    const hiddenInput = document.getElementById('modalProjectId');

    // Find the corresponding projectId by name
    const projectId = projectNameToId[projectName];
    hiddenInput.value = projectId;

    textarea.value = '';
    modal.classList.remove('hidden');
}

function openEditModal(notificationId, message, projectId) {
    isEditing = true;
    document.getElementById('modalTitle').textContent = 'Edit Notification';
    document.getElementById('submitButton').textContent = 'Update';
    document.getElementById('notificationMessage').value = message;
    document.getElementById('editingNotificationId').value = notificationId;
    document.getElementById('modalProjectId').value = projectId;

    document.getElementById('addNotificationModal').classList.remove('hidden');
}

function closeAddModal() {
    document.getElementById('addNotificationModal').classList.add('hidden');
}

document.getElementById('addNotificationForm').onsubmit = function (e) {
    e.preventDefault();

    const message = document.getElementById('notificationMessage').value.trim();
    const projectId = document.getElementById('modalProjectId').value;
    const notificationId = document.getElementById('editingNotificationId').value;

    if (!message) return;

    let action = isEditing ? 'edit' : 'add';
    let url = `${contextPath}/managenotifications?action=${action}&projectId=${encodeURIComponent(projectId)}&message=${encodeURIComponent(message)}`;

    if (isEditing) {
        url += `&id=${encodeURIComponent(notificationId)}`;
    }

    fetch(url)
        .then(res => {
            if (!res.ok) throw new Error('Failed to save notification.');
            return res.text();
        })
        .then(() => {
            document.getElementById('addNotificationModal').classList.add('hidden');
            loadAllNotifications();
        })
        .catch(err => {
            console.error(err);
            alert('An error occurred while saving the notification.');
        });
};

// Close modal on X click
document.getElementById('closeModal').addEventListener('click', closeAddModal);

function deleteNotification(id) {
    if (!confirm("Are you sure you want to delete this notification?")) return;

    fetch(`${contextPath}/managenotifications?action=delete&id=${id}`)
    .then(() => {
        loadAllNotifications();
    });
}


// Initial load
loadAllNotifications();