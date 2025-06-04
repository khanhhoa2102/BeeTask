document.addEventListener('DOMContentLoaded', () => {
    initializeSidebarToggle();
    initializeDarkMode();
    initializeCalendar();
    initializeAddEvent();
    initializeSidebarCalendar();
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

    const savedMode = localStorage.getItem('darkMode');
    if (savedMode === 'enabled') {
        document.body.classList.add('dark-mode');
        darkModeToggle.checked = true;
    }

    darkModeToggle.addEventListener('change', () => {
        document.body.classList.toggle('dark-mode');
        const isDarkMode = document.body.classList.contains('dark-mode');
        localStorage.setItem('darkMode', isDarkMode ? 'enabled' : 'disabled');
        console.log('Dark Mode:', isDarkMode);
    });
}

let currentDate = new Date(2025, 4, 1); // Start with May 2025
let viewMode = 'month';

function initializeCalendar() {
    const prevMonthBtn = document.getElementById('prev-month');
    const nextMonthBtn = document.getElementById('next-month');
    const monthYearSelect = document.getElementById('month-year');
    const currentWeekSpan = document.getElementById('current-week');
    const viewModeSelect = document.getElementById('view-mode-select');
    const calendarTable = document.querySelector('.calendar');

    populateMonthYearDropdown();
    renderCalendar();

    monthYearSelect.addEventListener('change', () => {
        const [year, month] = monthYearSelect.value.split('-').map(Number);
        currentDate = new Date(year, month - 1, currentDate.getDate());
        renderCalendar();
        if (viewMode === 'day') renderSidebarCalendar();
    });

    prevMonthBtn.addEventListener('click', () => {
        if (viewMode === 'month') {
            currentDate.setMonth(currentDate.getMonth() - 1);
        } else if (viewMode === 'week') {
            currentDate.setDate(currentDate.getDate() - 7);
        } else if (viewMode === 'day') {
            currentDate.setDate(currentDate.getDate() - 1);
        }
        updateMonthYearDropdown();
        renderCalendar();
        if (viewMode === 'day') renderSidebarCalendar();
    });

    nextMonthBtn.addEventListener('click', () => {
        if (viewMode === 'month') {
            currentDate.setMonth(currentDate.getMonth() + 1);
        } else if (viewMode === 'week') {
            currentDate.setDate(currentDate.getDate() + 7);
        } else if (viewMode === 'day') {
            currentDate.setDate(currentDate.getDate() + 1);
        }
        updateMonthYearDropdown();
        renderCalendar();
        if (viewMode === 'day') renderSidebarCalendar();
    });

    viewModeSelect.addEventListener('change', () => {
        viewMode = viewModeSelect.value;
        renderCalendar();
        if (viewMode === 'day') renderSidebarCalendar();
    });

    function populateMonthYearDropdown() {
        const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        const currentYear = new Date().getFullYear();
        const startYear = currentYear - 10;
        const endYear = currentYear + 10;

        monthYearSelect.innerHTML = '';

        for (let year = startYear; year <= endYear; year++) {
            for (let month = 1; month <= 12; month++) {
                const option = document.createElement('option');
                const monthIndex = month - 1;
                option.value = `${year}-${month}`;
                option.textContent = `${monthNames[monthIndex]}, ${year}`;
                monthYearSelect.appendChild(option);
            }
        }
    }

    function updateMonthYearDropdown() {
        const month = currentDate.getMonth() + 1;
        const year = currentDate.getFullYear();
        monthYearSelect.value = `${year}-${month}`;
    }

    function renderCalendar() {
        const calendarBody = document.getElementById('calendar-body');
        const calendarHead = document.querySelector('.calendar thead tr');
        const sidebarCalendar = document.querySelector('.sidebar-calendar');
        calendarBody.innerHTML = '';

        // Remove existing view mode classes
        calendarTable.classList.remove('day-view', 'week-view', 'month-view');
        // Add view mode class based on current viewMode
        if (viewMode === 'day') calendarTable.classList.add('day-view');
        else if (viewMode === 'week') calendarTable.classList.add('week-view');
        else if (viewMode === 'month') calendarTable.classList.add('month-view');

        // Show or hide the sidebar calendar based on viewMode
        if (viewMode === 'day') {
            sidebarCalendar.style.display = 'block';
        } else {
            sidebarCalendar.style.display = 'none';
        }

        const today = new Date(2025, 5, 4);
        let isCurrent = false;
        let label = '';

        if (viewMode === 'month') {
            isCurrent = currentDate.getFullYear() === today.getFullYear() && currentDate.getMonth() === today.getMonth();
            label = isCurrent ? 'This Month' : '';
            calendarHead.innerHTML = `
                <th>Sunday</th>
                <th>Monday</th>
                <th>Tuesday</th>
                <th>Wednesday</th>
                <th>Thursday</th>
                <th>Friday</th>
                <th>Saturday</th>
            `;
        } else if (viewMode === 'week') {
            const startOfWeek = new Date(currentDate);
            startOfWeek.setDate(currentDate.getDate() - currentDate.getDay());
            isCurrent = isWeekCurrent(startOfWeek, today);
            label = isCurrent ? 'This week' : '';
            calendarHead.innerHTML = `
                <th>Sunday</th>
                <th>Monday</th>
                <th>Tuesday</th>
                <th>Wednesday</th>
                <th>Thursday</th>
                <th>Friday</th>
                <th>Saturday</th>
            `;
        } else if (viewMode === 'day') {
            isCurrent = currentDate.toDateString() === today.toDateString();
            label = isCurrent ? 'This day' : '';
            const dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
            const dayName = dayNames[currentDate.getDay()];
            calendarHead.innerHTML = `<th colspan="7">${dayName}</th>`;
        }

        currentWeekSpan.textContent = label;

        if (viewMode === 'month') {
            const firstDay = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1).getDay();
            const daysInMonth = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0).getDate();

            let date = 1;
            let rows = Math.ceil((daysInMonth + firstDay) / 7);

            const tasks = {
                "2025-5-1": [
                    { color: "color1", text: "Write a document..." },
                    { color: "color2", text: "Write a document..." },
                    { color: "color3", text: "Write a document..." }
                ],
                "2025-5-2": [{ color: "color1", text: "Write a document..." }],
                "2025-5-6": [{ color: "color1", text: "Write a document..." }],
                "2025-5-8": [{ color: "color2", text: "Write a document..." }],
                "2025-5-15": [{ color: "color2", text: "Write a document..." }],
            };

            for (let i = 0; i < rows; i++) {
                const row = document.createElement('tr');
                for (let j = 0; j < 7; j++) {
                    const cell = document.createElement('td');
                    const index = i * 7 + j;
                    if (index < firstDay || date > daysInMonth) {
                        cell.innerHTML = '<div class="cell-content"><div class="date"></div><div class="task-container"></div></div>';
                    } else {
                        const eventKey = `${currentDate.getFullYear()}-${currentDate.getMonth() + 1}-${date}`;
                        const dayTasks = tasks[eventKey] || [];
                        let taskButtons = '';
                        dayTasks.forEach(task => {
                            taskButtons += `<button class="task-button ${task.color}">${task.text}</button>`;
                        });
                        cell.innerHTML = `
                            <div class="cell-content">
                                <div class="date">${date}</div>
                                <div class="task-container">${taskButtons}</div>
                            </div>
                        `;
                        date++;
                    }
                    row.appendChild(cell);
                }
                calendarBody.appendChild(row);
            }
        } else if (viewMode === 'week') {
            const startOfWeek = new Date(currentDate);
            startOfWeek.setDate(currentDate.getDate() - currentDate.getDay());

            const row = document.createElement('tr');
            for (let i = 0; i < 7; i++) {
                const cellDate = new Date(startOfWeek);
                cellDate.setDate(startOfWeek.getDate() + i);
                const cell = document.createElement('td');
                const eventKey = `${cellDate.getFullYear()}-${cellDate.getMonth() + 1}-${cellDate.getDate()}`;
                const tasks = {
                    "2025-5-1": [
                        { color: "color1", text: "Write a document..." },
                        { color: "color2", text: "Write a document..." },
                        { color: "color3", text: "Write a document..." }
                    ],
                    "2025-5-2": [{ color: "color1", text: "Write a document..." }],
                    "2025-5-6": [{ color: "color1", text: "Write a document..." }],
                };
                const dayTasks = tasks[eventKey] || [];
                let taskButtons = '';
                dayTasks.forEach(task => {
                    taskButtons += `<button class="task-button ${task.color}">${task.text}</button>`;
                });
                cell.innerHTML = `
                    <div class="cell-content">
                        <div class="date">${cellDate.getDate()}</div>
                        <div class="task-container">${taskButtons}</div>
                    </div>
                `;
                row.appendChild(cell);
            }
            calendarBody.appendChild(row);
        } else if (viewMode === 'day') {
            const row = document.createElement('tr');
            const cell = document.createElement('td');
            cell.setAttribute('colspan', '7');
            const eventKey = `${currentDate.getFullYear()}-${currentDate.getMonth() + 1}-${currentDate.getDate()}`;
            const tasks = {
                "2025-5-1": [
                    { color: "color1", text: "Write a document..." },
                    { color: "color2", text: "Write a document..." },
                    { color: "color3", text: "Write a document..." }
                ],
            };
            const dayTasks = tasks[eventKey] || [];
            let taskButtons = '';
            dayTasks.forEach(task => {
                taskButtons += `<button class="task-button ${task.color}">${task.text}</button>`;
            });
            cell.innerHTML = `
                <div class="cell-content">
                    <div class="date">${currentDate.getDate()}</div>
                    <div class="task-container">${taskButtons}</div>
                </div>
            `;
            row.appendChild(cell);
            calendarBody.appendChild(row);
        }

        updateMonthYearDropdown();
    }

    function isWeekCurrent(weekStart, today) {
        const weekEnd = new Date(weekStart);
        weekEnd.setDate(weekStart.getDate() + 6);
        return weekStart <= today && weekEnd >= today;
    }
}

function initializeSidebarCalendar() {
    const prevMonthBtn = document.getElementById('prev-month-sidebar');
    const nextMonthBtn = document.getElementById('next-month-sidebar');
    const monthYearSpan = document.getElementById('sidebar-month-year');
    const calendarBody = document.getElementById('sidebar-calendar-body');
    let sidebarDate = new Date(currentDate);

    if (viewMode === 'day') renderSidebarCalendar();

    prevMonthBtn.addEventListener('click', () => {
        sidebarDate.setMonth(sidebarDate.getMonth() - 1);
        renderSidebarCalendar();
    });

    nextMonthBtn.addEventListener('click', () => {
        sidebarDate.setMonth(sidebarDate.getMonth() + 1);
        renderSidebarCalendar();
    });

    function renderSidebarCalendar() {
        const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        monthYearSpan.textContent = `${monthNames[sidebarDate.getMonth()]}, ${sidebarDate.getFullYear()}`;
        const firstDay = new Date(sidebarDate.getFullYear(), sidebarDate.getMonth(), 1).getDay();
        const daysInMonth = new Date(sidebarDate.getFullYear(), sidebarDate.getMonth() + 1, 0).getDate();
        const today = new Date(2025, 5, 4);

        calendarBody.innerHTML = '';
        let date = 1;
        let rows = Math.ceil((daysInMonth + firstDay) / 7);

        for (let i = 0; i < rows; i++) {
            const row = document.createElement('tr');
            for (let j = 0; j < 7; j++) {
                const cell = document.createElement('td');
                const index = i * 7 + j;
                if (index < firstDay || date > daysInMonth) {
                    cell.textContent = '';
                } else {
                    const cellDate = new Date(sidebarDate.getFullYear(), sidebarDate.getMonth(), date);
                    cell.textContent = date;
                    if (cellDate.toDateString() === currentDate.toDateString()) {
                        cell.classList.add('selected-day');
                    }
                    if (cellDate.toDateString() === today.toDateString()) {
                        cell.classList.add('today');
                    }
                    cell.addEventListener('click', () => {
                        currentDate = new Date(cellDate);
                        renderCalendar();
                        renderSidebarCalendar();
                    });
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