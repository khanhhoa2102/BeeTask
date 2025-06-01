document.addEventListener('DOMContentLoaded', () => {
    initializeSidebarToggle();
    initializeDarkMode();
    initializeCalendar();
    initializeAddEvent();
});

function initializeSidebarToggle() {
    const toggleButtons = document.querySelectorAll('.toggle-btn, .sidebar-toggle');
    const sidebar = document.querySelector('.sidebar');

    if (!sidebar) {
        console.warn('Phần tử .sidebar không tồn tại.');
        return;
    }

    toggleButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            sidebar.classList.toggle('collapsed');
            console.log('Sidebar toggled. Collapsed:', sidebar.classList.contains('collapsed'));
        });
    });
}

function initializeDarkMode() {
    const darkModeToggle = document.getElementById('darkModeToggle');
    if (!darkModeToggle) {
        console.warn('Phần tử #darkModeToggle không tồn tại. Dark mode sẽ không hoạt động.');
        return;
    }

    // Check for saved dark mode preference
    const savedMode = localStorage.getItem('darkMode');
    if (savedMode === 'enabled') {
        document.body.classList.add('dark-mode');
        darkModeToggle.checked = true;
    }

    // Toggle dark mode on change
    darkModeToggle.addEventListener('change', () => {
        document.body.classList.toggle('dark-mode');
        const isDarkMode = document.body.classList.contains('dark-mode');
        localStorage.setItem('darkMode', isDarkMode ? 'enabled' : 'disabled');
        console.log('Dark Mode:', isDarkMode);
    });
}

let currentDate = new Date(2025, 4, 1); // Start with May 2025 (month is 0-based in JS)

function initializeCalendar() {
    const prevMonthBtn = document.getElementById('prev-month');
    const nextMonthBtn = document.getElementById('next-month');
    const monthYearSpan = document.getElementById('month-year');
    const currentMonthSpan = document.getElementById('current-month');

    renderCalendar();

    prevMonthBtn.addEventListener('click', () => {
        currentDate.setMonth(currentDate.getMonth() - 1);
        renderCalendar();
    });

    nextMonthBtn.addEventListener('click', () => {
        currentDate.setMonth(currentDate.getMonth() + 1);
        renderCalendar();
    });

    function renderCalendar() {
        const calendarBody = document.getElementById('calendar-body');
        calendarBody.innerHTML = '';

        const today = new Date(2025, 5, 1); // June 1, 2025 (today's date as per system)
        const isCurrentMonth = currentDate.getFullYear() === today.getFullYear() && currentDate.getMonth() === today.getMonth();

        // Update header
        const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        monthYearSpan.textContent = `${monthNames[currentDate.getMonth()]} ${currentDate.getFullYear()}`;
        currentMonthSpan.textContent = isCurrentMonth ? "This Month" : "";

        // Get first day of the month and number of days
        const firstDay = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1).getDay();
        const daysInMonth = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0).getDate();

        let date = 1;
        let rows = Math.ceil((daysInMonth + firstDay) / 7);

        // Sample events
        const events = {
            "2025-5-1": { color: "orange", icon: "fas fa-file-alt" },
            "2025-5-2": { color: "green", icon: "fas fa-file-alt" },
            "2025-5-6": { color: "green", icon: "fas fa-file-alt" },
            "2025-5-8": { color: "orange", icon: "fas fa-file-alt" },
            "2025-5-15": { color: "orange", icon: "fas fa-file-alt" },
        };

        for (let i = 0; i < rows; i++) {
            const row = document.createElement('tr');
            for (let j = 0; j < 7; j++) {
                const cell = document.createElement('td');
                const index = i * 7 + j;
                if (index < firstDay || date > daysInMonth) {
                    cell.innerHTML = '';
                } else {
                    const eventKey = `${currentDate.getFullYear()}-${currentDate.getMonth() + 1}-${date}`;
                    const event = events[eventKey];
                    cell.innerHTML = `
                        <div class="date">${date}</div>
                        ${event ? `<div class="event ${event.color}"><i class="${event.icon}"></i></div>` : ''}
                    `;
                    date++;
                }
                row.appendChild(cell);
            }
            calendarBody.appendChild(row);
        }
    }
}

function initializeAddEvent() {
    const addEventBtn = document.getElementById('add-event-btn');
    addEventBtn.addEventListener('click', () => {
        alert('Add new event functionality will be implemented here.');
    });
}