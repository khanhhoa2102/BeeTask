const userId = '<%= session.getAttribute("userId") %>';

function loadAllNotifications() {
    fetch(`${contextPath}/notifications?action=viewall`)
        .then(res => res.json())
        .then(data => {
            const tbody = document.querySelector("#notificationTable tbody");
            tbody.innerHTML = "";

            data.forEach(n => {
                const tr = document.createElement("tr");
                tr.innerHTML = `
                    <td>${n.notificationId}</td>
                    <td><span contenteditable="true" data-id="${n.notificationId}" class="editable">${n.message}</span></td>
                    <td>${n.createdAt || ""}</td>
                    <td>
                        <button onclick="editNotification(${n.notificationId})">Edit</button>
                        <button onclick="deleteNotification(${n.notificationId})">Delete</button>
                    </td>
                `;
                tbody.appendChild(tr);
            });
        });
}

function createNotification(event) {
    event.preventDefault();
    const targetId = document.getElementById("targetIdInput").value;
    const message = document.getElementById("messageInput").value;

    fetch(`${contextPath}/notifications?action=create`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `targetId=${targetId}&message=${encodeURIComponent(message)}`
    }).then(() => {
        document.getElementById("createForm").reset();
        loadNotifications();
    });
}

function editNotification(id) {
    const messageSpan = document.querySelector(`.editable[data-id="${id}"]`);
    const newMessage = messageSpan.textContent.trim();

    fetch(`${contextPath}/notifications?action=edit`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `notificationId=${id}&message=${encodeURIComponent(newMessage)}`
    }).then(() => {
        loadNotifications();
    });
}

function deleteNotification(id) {
    if (!confirm("Are you sure you want to delete this notification?")) return;

    fetch(`${contextPath}/notifications?action=delete`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `notificationId=${id}`
    }).then(() => {
        loadNotifications();
    });
}

// Initial load
loadAllNotifications();