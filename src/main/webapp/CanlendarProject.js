// Optimized Calendar JavaScript with performance improvements
let isInitialized = false;
let debounceTimers = {};
let animationFrameId = null;
let currentDate = new Date(2025, 4, 1);
let viewMode = 'month';
let isRendering = false;
let cachedElements = {};

// Cache DOM elements for better performance
function cacheElements() {
    if (Object.keys(cachedElements).length > 0) return;
    
    cachedElements = {
        sidebar: document.querySelector('.sidebar'),
        darkModeToggle: document.getElementById('darkModeToggle'),
        prevMonthBtn: document.getElementById('prev-month'),
        nextMonthBtn: document.getElementById('next-month'),
        monthYearSelect: document.getElementById('month-year'),
        currentWeekSpan: document.getElementById('current-week'),
        viewModeSelect: document.getElementById('view-mode-select'),
        calendarTable: document.querySelector('.calendar'),
        calendarBody: document.getElementById('calendar-body'),
        calendarHead: document.querySelector('.calendar thead tr'),
        sidebarCalendar: document.querySelector('.sidebar-calendar'),
        addEventBtn: document.getElementById('add-event-btn'),
        todayBtn: document.getElementById('today-btn'),
        sidebarCalendarBody: document.getElementById('sidebar-calendar-body'),
        sidebarMonthYear: document.getElementById('sidebar-month-year'),
        prevMonthSidebar: document.getElementById('prev-month-sidebar'),
        nextMonthSidebar: document.getElementById('next-month-sidebar')
    };
}

// Debounce function to prevent excessive calls
function debounce(func, wait, immediate) {
    return function executedFunction(...args) {
        const later = () => {
            debounceTimers[func.name] = null;
            if (!immediate) func(...args);
        };
        const callNow = immediate && !debounceTimers[func.name];
        clearTimeout(debounceTimers[func.name]);
        debounceTimers[func.name] = setTimeout(later, wait);
        if (callNow) func(...args);
    };
}

// Throttle function for high-frequency events
function throttle(func, limit) {
    let inThrottle;
    return function(...args) {
        if (!inThrottle) {
            func.apply(this, args);
            inThrottle = true;
            setTimeout(() => inThrottle = false, limit);
        }
    };
}

// Optimized DOM ready check
function domReady(callback) {
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', callback);
    } else {
        callback();
    }
}

// Main initialization with performance checks
domReady(() => {
    if (isInitialized) return;
    
    try {
        cacheElements();
        initializeSidebarToggle();
        initializeDarkMode();
        initializeCalendar();
        initializeAddEvent();
        initializeSidebarCalendar();
        initializeTodayButton();
        initializeEnhancedFeatures();
        isInitialized = true;
        console.log('Calendar initialized successfully');
    } catch (error) {
        console.error('Calendar initialization failed:', error);
        showNotification('Calendar failed to load', 'error');
    }
});

// Optimized sidebar toggle
function initializeSidebarToggle() {
    const toggleButtons = document.querySelectorAll('.toggle-btn, .sidebar-toggle');
    
    if (!cachedElements.sidebar) {
        console.warn('Sidebar element not found');
        return;
    }

    // Apply saved state immediately
    const savedSidebarState = localStorage.getItem('sidebarState') || 'expanded';
    cachedElements.sidebar.classList.toggle('collapsed', savedSidebarState === 'collapsed');

    // Debounced toggle function
    const debouncedToggle = debounce(() => {
        if (!cachedElements.sidebar) return;
        
        cachedElements.sidebar.classList.toggle('collapsed');
        const isCollapsed = cachedElements.sidebar.classList.contains('collapsed');
        
        // Use requestAnimationFrame for smooth animation
        requestAnimationFrame(() => {
            localStorage.setItem('sidebarState', isCollapsed ? 'collapsed' : 'expanded');
        });
    }, 100);

    toggleButtons.forEach(btn => {
        btn.addEventListener('click', debouncedToggle, { passive: true });
    });
}

// Optimized dark mode toggle
function initializeDarkMode() {
    if (!cachedElements.darkModeToggle) {
        console.warn('Dark mode toggle not found');
        return;
    }

    // Apply saved theme immediately
    const savedTheme = localStorage.getItem('theme') || 'dark-mode';
    const isDarkMode = savedTheme === 'dark-mode';
    
    document.body.classList.toggle('dark-mode', isDarkMode);
    cachedElements.darkModeToggle.checked = isDarkMode;

    // Debounced theme change
    const debouncedThemeChange = debounce(() => {
        const isDark = cachedElements.darkModeToggle.checked;
        
        // Use CSS transition for smooth change
        document.body.style.transition = 'all 0.3s ease';
        document.body.classList.toggle('dark-mode', isDark);
        
        requestAnimationFrame(() => {
            localStorage.setItem('theme', isDark ? 'dark-mode' : 'light-mode');
            setTimeout(() => {
                document.body.style.transition = '';
            }, 300);
        });
    }, 150);

    cachedElements.darkModeToggle.addEventListener('change', debouncedThemeChange, { passive: true });
}

// Optimized calendar initialization
function initializeCalendar() {
    if (!cachedElements.calendarBody) {
        console.error('Calendar body not found');
        return;
    }

    populateMonthYearDropdown();
    renderCalendar();

    // Debounced event handlers
    const debouncedMonthYearChange = debounce(() => {
        if (isRendering) return;
        
        const [year, month] = cachedElements.monthYearSelect.value.split('-').map(Number);
        currentDate = new Date(year, month - 1, currentDate.getDate());
        renderCalendar();
        if (viewMode === 'day') window.renderSidebarCalendar();
        showNotification('Calendar updated', 'success');
    }, 200);

    const debouncedNavigation = debounce((direction) => {
        if (isRendering) return;
        navigateCalendar(direction);
    }, 150);

    const debouncedViewModeChange = debounce(() => {
        if (isRendering) return;
        
        viewMode = cachedElements.viewModeSelect.value;
        renderCalendar();
        if (viewMode === 'day') window.renderSidebarCalendar();
        showNotification(`Switched to ${viewMode} view`, 'info');
    }, 200);

    // Add event listeners with passive option
    if (cachedElements.monthYearSelect) {
        cachedElements.monthYearSelect.addEventListener('change', debouncedMonthYearChange, { passive: true });
    }

    if (cachedElements.prevMonthBtn) {
        cachedElements.prevMonthBtn.addEventListener('click', () => debouncedNavigation(-1), { passive: true });
    }

    if (cachedElements.nextMonthBtn) {
        cachedElements.nextMonthBtn.addEventListener('click', () => debouncedNavigation(1), { passive: true });
    }

    if (cachedElements.viewModeSelect) {
        cachedElements.viewModeSelect.addEventListener('change', debouncedViewModeChange, { passive: true });
    }

    function navigateCalendar(direction) {
        if (viewMode === 'month') {
            currentDate.setMonth(currentDate.getMonth() + direction);
        } else if (viewMode === 'week') {
            currentDate.setDate(currentDate.getDate() + (direction * 7));
        } else if (viewMode === 'day') {
            currentDate.setDate(currentDate.getDate() + direction);
        }
        updateMonthYearDropdown();
        renderCalendar();
        if (viewMode === 'day') window.renderSidebarCalendar();
    }

    function populateMonthYearDropdown() {
        if (!cachedElements.monthYearSelect) return;
        
        // Use document fragment for better performance
        const fragment = document.createDocumentFragment();
        const monthNames = ["January", "February", "March", "April", "May", "June", 
                           "July", "August", "September", "October", "November", "December"];
        const currentYear = new Date().getFullYear();
        const startYear = currentYear - 10;
        const endYear = currentYear + 10;

        for (let year = startYear; year <= endYear; year++) {
            for (let month = 1; month <= 12; month++) {
                const option = document.createElement('option');
                const monthIndex = month - 1;
                option.value = `${year}-${month}`;
                option.textContent = `${monthNames[monthIndex]}, ${year}`;
                fragment.appendChild(option);
            }
        }
        
        cachedElements.monthYearSelect.innerHTML = '';
        cachedElements.monthYearSelect.appendChild(fragment);
    }

    function updateMonthYearDropdown() {
        if (!cachedElements.monthYearSelect) return;
        
        const month = currentDate.getMonth() + 1;
        const year = currentDate.getFullYear();
        cachedElements.monthYearSelect.value = `${year}-${month}`;
    }
}

// Optimized render function with performance improvements
function renderCalendar() {
    if (isRendering || !cachedElements.calendarBody) return;
    
    isRendering = true;
    
    // Cancel any pending animation frame
    if (animationFrameId) {
        cancelAnimationFrame(animationFrameId);
    }
    
    animationFrameId = requestAnimationFrame(() => {
        try {
            performRender();
        } catch (error) {
            console.error('Render error:', error);
            showNotification('Render failed', 'error');
        } finally {
            isRendering = false;
        }
    });
}

function performRender() {
    // Clear previous content efficiently
    cachedElements.calendarBody.innerHTML = '';
    
    // Remove existing view mode classes
    cachedElements.calendarTable.classList.remove('day-view', 'week-view', 'month-view');
    cachedElements.calendarTable.classList.add(`${viewMode}-view`);

    // Show/hide sidebar calendar
    if (cachedElements.sidebarCalendar) {
        cachedElements.sidebarCalendar.style.display = viewMode === 'day' ? 'block' : 'none';
    }

    const today = new Date(2025, 5, 4);
    let isCurrent = false;
    let label = '';

    // Update header and label based on view mode
    if (viewMode === 'month') {
        isCurrent = currentDate.getFullYear() === today.getFullYear() && 
                   currentDate.getMonth() === today.getMonth();
        label = isCurrent ? 'This Month' : '';
        updateCalendarHeader(['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']);
    } else if (viewMode === 'week') {
        const startOfWeek = new Date(currentDate);
        startOfWeek.setDate(currentDate.getDate() - currentDate.getDay());
        isCurrent = isWeekCurrent(startOfWeek, today);
        label = isCurrent ? 'This week' : '';
        updateCalendarHeader(['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']);
    } else if (viewMode === 'day') {
        isCurrent = currentDate.toDateString() === today.toDateString();
        label = isCurrent ? 'Today' : '';
        const dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
        const dayName = dayNames[currentDate.getDay()];
        const formattedDate = currentDate.toLocaleDateString('en-US', { 
            month: 'long', 
            day: 'numeric', 
            year: 'numeric' 
        });
        updateCalendarHeader([`${dayName}, ${formattedDate}`], true);
    }

    if (cachedElements.currentWeekSpan) {
        cachedElements.currentWeekSpan.textContent = label;
    }

    // Render based on view mode
    switch (viewMode) {
        case 'month':
            renderMonthView();
            break;
        case 'week':
            renderWeekView();
            break;
        case 'day':
            renderDayView();
            break;
    }

    updateMonthYearDropdown();
    addCellInteractions();
}

function updateCalendarHeader(headers, isColspan = false) {
    if (!cachedElements.calendarHead) return;
    
    const fragment = document.createDocumentFragment();
    
    if (isColspan) {
        const th = document.createElement('th');
        th.setAttribute('colspan', '7');
        th.textContent = headers[0];
        fragment.appendChild(th);
    } else {
        headers.forEach(header => {
            const th = document.createElement('th');
            th.textContent = header;
            fragment.appendChild(th);
        });
    }
    
    cachedElements.calendarHead.innerHTML = '';
    cachedElements.calendarHead.appendChild(fragment);
}

// Optimized month view rendering
function renderMonthView() {
    const firstDay = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1).getDay();
    const daysInMonth = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0).getDate();
    const today = new Date();
    const tasks = getSampleTasks();
    
    const fragment = document.createDocumentFragment();
    let date = 1;
    const rows = Math.ceil((daysInMonth + firstDay) / 7);

    for (let i = 0; i < rows; i++) {
        const row = document.createElement('tr');
        
        for (let j = 0; j < 7; j++) {
            const cell = document.createElement('td');
            const index = i * 7 + j;
            
            if (index < firstDay || date > daysInMonth) {
                cell.innerHTML = '<div class="cell-content"><div class="date"></div><div class="task-container"></div></div>';
            } else {
                const cellDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), date);
                const isToday = cellDate.toDateString() === today.toDateString();
                const eventKey = `${currentDate.getFullYear()}-${currentDate.getMonth() + 1}-${date}`;
                const dayTasks = tasks[eventKey] || [];
                
                // Build task buttons efficiently
                const taskButtons = dayTasks.map(task => 
                    `<button class="task-button ${task.color}" title="${task.text}">${task.text}</button>`
                ).join('');
                
                cell.innerHTML = `
                    <div class="cell-content">
                        <div class="date ${isToday ? 'today' : ''}">${date}</div>
                        <div class="task-container">${taskButtons}</div>
                    </div>
                `;
                
                if (isToday) cell.classList.add('today-cell');
                cell.setAttribute('data-date', cellDate.toISOString().split('T')[0]);
                date++;
            }
            row.appendChild(cell);
        }
        fragment.appendChild(row);
    }
    
    cachedElements.calendarBody.appendChild(fragment);
}

// Optimized week view rendering
function renderWeekView() {
    const startOfWeek = new Date(currentDate);
    startOfWeek.setDate(currentDate.getDate() - currentDate.getDay());
    const today = new Date();
    const tasks = getSampleTasks();
    
    const row = document.createElement('tr');
    
    for (let i = 0; i < 7; i++) {
        const cellDate = new Date(startOfWeek);
        cellDate.setDate(startOfWeek.getDate() + i);
        const cell = document.createElement('td');
        const isToday = cellDate.toDateString() === today.toDateString();
        const eventKey = `${cellDate.getFullYear()}-${cellDate.getMonth() + 1}-${cellDate.getDate()}`;
        const dayTasks = tasks[eventKey] || [];
        
        const taskButtons = dayTasks.map(task => 
            `<button class="task-button ${task.color}" title="${task.text}">${task.text}</button>`
        ).join('');
        
        cell.innerHTML = `
            <div class="cell-content">
                <div class="date ${isToday ? 'today' : ''}">${cellDate.getDate()}</div>
                <div class="task-container">${taskButtons}</div>
            </div>
        `;
        
        if (isToday) cell.classList.add('today-cell');
        cell.setAttribute('data-date', cellDate.toISOString().split('T')[0]);
        row.appendChild(cell);
    }
    
    cachedElements.calendarBody.appendChild(row);
}

// Optimized day view rendering
function renderDayView() {
    const today = new Date();
    const isToday = currentDate.toDateString() === today.toDateString();
    const eventKey = `${currentDate.getFullYear()}-${currentDate.getMonth() + 1}-${currentDate.getDate()}`;
    const tasks = getSampleTasks();
    const dayTasks = tasks[eventKey] || [];
    
    const taskButtons = dayTasks.map(task => 
        `<button class="task-button ${task.color}" title="${task.text}">${task.text}</button>`
    ).join('');
    
    const row = document.createElement('tr');
    const cell = document.createElement('td');
    cell.setAttribute('colspan', '7');
    cell.innerHTML = `
        <div class="cell-content">
            <div class="date ${isToday ? 'today' : ''}">${currentDate.getDate()}</div>
            <div class="task-container">${taskButtons}</div>
        </div>
    `;
    
    if (isToday) cell.classList.add('today-cell');
    cell.setAttribute('data-date', currentDate.toISOString().split('T')[0]);
    row.appendChild(cell);
    cachedElements.calendarBody.appendChild(row);
}

// Optimized cell interactions with event delegation
function addCellInteractions() {
    // Remove existing listeners to prevent memory leaks
    cachedElements.calendarBody.removeEventListener('click', handleCellClick);
    
    // Use event delegation for better performance
    cachedElements.calendarBody.addEventListener('click', handleCellClick, { passive: true });
}

// Throttled cell click handler
const handleCellClick = throttle((e) => {
    const cell = e.target.closest('td[data-date]');
    if (!cell) return;
    
    if (e.target.classList.contains('task-button')) {
        showNotification(`Task: ${e.target.textContent}`, 'info');
        return;
    }
    
    const date = new Date(cell.getAttribute('data-date'));
    currentDate = date;
    
    if (viewMode !== 'day') {
        viewMode = 'day';
        if (cachedElements.viewModeSelect) {
            cachedElements.viewModeSelect.value = 'day';
        }
    }
    
    renderCalendar();
    window.renderSidebarCalendar();
    showNotification(`Selected ${date.toLocaleDateString()}`, 'info');
}, 200);

// Optimized sidebar calendar
function initializeSidebarCalendar() {
    if (!cachedElements.prevMonthSidebar || !cachedElements.nextMonthSidebar) return;
    
    let sidebarDate = new Date(currentDate);
    
    const debouncedSidebarNav = debounce((direction) => {
        sidebarDate.setMonth(sidebarDate.getMonth() + direction);
        window.renderSidebarCalendar();
    }, 150);

    cachedElements.prevMonthSidebar.addEventListener('click', () => debouncedSidebarNav(-1), { passive: true });
    cachedElements.nextMonthSidebar.addEventListener('click', () => debouncedSidebarNav(1), { passive: true });

    function renderSidebarCalendar() {
        if (!cachedElements.sidebarCalendarBody || !cachedElements.sidebarMonthYear) return;
        
        const monthNames = ["January", "February", "March", "April", "May", "June", 
                           "July", "August", "September", "October", "November", "December"];
        cachedElements.sidebarMonthYear.textContent = `${monthNames[sidebarDate.getMonth()]}, ${sidebarDate.getFullYear()}`;
        
        const firstDay = new Date(sidebarDate.getFullYear(), sidebarDate.getMonth(), 1).getDay();
        const daysInMonth = new Date(sidebarDate.getFullYear(), sidebarDate.getMonth() + 1, 0).getDate();
        const today = new Date(2025, 5, 4);
        
        const fragment = document.createDocumentFragment();
        let date = 1;
        const rows = Math.ceil((daysInMonth + firstDay) / 7);

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
                    
                    // Use throttled click handler
                    cell.addEventListener('click', throttle(() => {
                        currentDate = new Date(cellDate);
                        renderCalendar();
                        window.renderSidebarCalendar();
                        showNotification(`Selected ${cellDate.toLocaleDateString()}`, 'success');
                    }, 200), { passive: true });
                    
                    date++;
                }
                row.appendChild(cell);
            }
            fragment.appendChild(row);
        }
        
        cachedElements.sidebarCalendarBody.innerHTML = '';
        cachedElements.sidebarCalendarBody.appendChild(fragment);
    }

    // Make function globally available
    window.renderSidebarCalendar = renderSidebarCalendar;
    
    if (viewMode === 'day') window.renderSidebarCalendar();
}

// Optimized event handlers
function initializeAddEvent() {
    if (!cachedElements.addEventBtn) return;
    
    const debouncedAddEvent = debounce(() => {
        showNotification('Add Event feature coming soon!', 'info');
        console.log('Add new event for date:', currentDate.toLocaleDateString());
    }, 300);
    
    cachedElements.addEventBtn.addEventListener('click', debouncedAddEvent, { passive: true });
}

function initializeTodayButton() {
    if (!cachedElements.todayBtn) return;
    
    const debouncedToday = debounce(() => {
        currentDate = new Date(2025, 5, 4);
        renderCalendar();
        if (viewMode === 'day' && window.renderSidebarCalendar) {
            window.renderSidebarCalendar();
        }
        showNotification('Jumped to today', 'success');
    }, 200);
    
    cachedElements.todayBtn.addEventListener('click', debouncedToday, { passive: true });
}

// Optimized enhanced features
function initializeEnhancedFeatures() {
    // Throttled keyboard shortcuts
    const throttledKeyHandler = throttle((e) => {
        if (e.ctrlKey || e.metaKey) {
            switch(e.key) {
                case 'ArrowLeft':
                    e.preventDefault();
                    cachedElements.prevMonthBtn?.click();
                    break;
                case 'ArrowRight':
                    e.preventDefault();
                    cachedElements.nextMonthBtn?.click();
                    break;
                case 't':
                    e.preventDefault();
                    cachedElements.todayBtn?.click();
                    break;
            }
        }
    }, 100);

    document.addEventListener('keydown', throttledKeyHandler, { passive: false });

    // Optimized button feedback
    const buttons = document.querySelectorAll('button');
    buttons.forEach(button => {
        button.addEventListener('click', function() {
            this.style.transform = 'scale(0.98)';
            requestAnimationFrame(() => {
                setTimeout(() => {
                    this.style.transform = '';
                }, 150);
            });
        }, { passive: true });
    });
}

// Utility functions
function isWeekCurrent(weekStart, today) {
    const weekEnd = new Date(weekStart);
    weekEnd.setDate(weekStart.getDate() + 6);
    return weekStart <= today && weekEnd >= today;
}

function updateMonthYearDropdown() {
    if (!cachedElements.monthYearSelect) return;
    
    const month = currentDate.getMonth() + 1;
    const year = currentDate.getFullYear();
    cachedElements.monthYearSelect.value = `${year}-${month}`;
}

// Cached sample tasks for better performance
let cachedTasks = null;
function getSampleTasks() {
    if (cachedTasks) return cachedTasks;
    
    cachedTasks = {
        "2025-5-1": [
            { color: "color1", text: "Write documentation" },
            { color: "color2", text: "Team meeting" },
            { color: "color3", text: "Code review" }
        ],
        "2025-5-2": [{ color: "color1", text: "Project planning" }],
        "2025-5-6": [{ color: "color1", text: "Client presentation" }],
        "2025-5-8": [{ color: "color2", text: "Sprint planning" }],
        "2025-5-15": [{ color: "color2", text: "Release deployment" }],
        "2025-6-4": [
            { color: "color1", text: "Today's tasks" },
            { color: "color3", text: "Important meeting" }
        ]
    };
    
    return cachedTasks;
}

// Optimized notification system with queue
let notificationQueue = [];
let isShowingNotification = false;

function showNotification(message, type = 'info') {
    notificationQueue.push({ message, type });
    processNotificationQueue();
}

function processNotificationQueue() {
    if (isShowingNotification || notificationQueue.length === 0) return;
    
    isShowingNotification = true;
    const { message, type } = notificationQueue.shift();
    
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.innerHTML = `
        <div class="notification-content">
            <i class="fas fa-${getNotificationIcon(type)}"></i>
            <span>${message}</span>
        </div>
    `;

    notification.style.cssText = `
        position: fixed;
        top: 2rem;
        right: 2rem;
        background: ${getNotificationColor(type)};
        color: white;
        padding: 1rem 1.5rem;
        border-radius: 15px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        z-index: 10000;
        transform: translateX(100%);
        transition: transform 0.3s ease;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        max-width: 300px;
        font-size: 0.9rem;
        font-weight: 500;
    `;

    document.body.appendChild(notification);

    requestAnimationFrame(() => {
        notification.style.transform = 'translateX(0)';
    });

    setTimeout(() => {
        notification.style.transform = 'translateX(100%)';
        setTimeout(() => {
            if (document.body.contains(notification)) {
                document.body.removeChild(notification);
            }
            isShowingNotification = false;
            // Process next notification in queue
            if (notificationQueue.length > 0) {
                setTimeout(processNotificationQueue, 100);
            }
        }, 300);
    }, 2000);
}

function getNotificationIcon(type) {
    const icons = {
        success: 'check-circle',
        info: 'info-circle',
        warning: 'exclamation-triangle',
        error: 'times-circle'
    };
    return icons[type] || 'info-circle';
}

function getNotificationColor(type) {
    const colors = {
        success: '#10b981',
        info: '#667eea',
        warning: '#f59e0b',
        error: '#ef4444'
    };
    return colors[type] || '#667eea';
}

// Cleanup function for memory management
function cleanup() {
    // Cancel any pending animation frames
    if (animationFrameId) {
        cancelAnimationFrame(animationFrameId);
    }
    
    // Clear all debounce timers
    Object.keys(debounceTimers).forEach(key => {
        if (debounceTimers[key]) {
            clearTimeout(debounceTimers[key]);
        }
    });
    
    // Clear notification queue
    notificationQueue = [];
    isShowingNotification = false;
}

// Handle page unload
window.addEventListener('beforeunload', cleanup);

// Export optimized functions
window.showNotification = showNotification;
window.renderCalendar = renderCalendar;
window.renderSidebarCalendar = window.renderSidebarCalendar || (() => {});

// Optimized dark mode toggle
function initializeDarkMode() {
    if (!cachedElements.darkModeToggle) {
        console.warn('Dark mode toggle not found');
        return;
    }

    // Apply saved theme immediately
    const savedTheme = localStorage.getItem('theme') || 'dark-mode';
    const isDarkMode = savedTheme === 'dark-mode';
    
    document.body.classList.toggle('dark-mode', isDarkMode);
    cachedElements.darkModeToggle.checked = isDarkMode;

    // Debounced theme change
    const debouncedThemeChange = debounce(() => {
        const isDark = cachedElements.darkModeToggle.checked;
        
        // Use CSS transition for smooth change
        document.body.style.transition = 'all 0.3s ease';
        document.body.classList.toggle('dark-mode', isDark);
        
        requestAnimationFrame(() => {
            localStorage.setItem('theme', isDark ? 'dark-mode' : 'light-mode');
            setTimeout(() => {
                document.body.style.transition = '';
            }, 300);
        });
    }, 150);

    cachedElements.darkModeToggle.addEventListener('change', debouncedThemeChange, { passive: true });
}

