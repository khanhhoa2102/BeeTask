
// Minimalist Dashboard JavaScript
document.addEventListener('DOMContentLoaded', () => {
    initializeClock();
    initializeCalendar();
    initializeInteractions();
    initializeAnimations();
});

// Clock functionality
function initializeClock() {
    updateClock();
    setInterval(updateClock, 1000);
}

function updateClock() {
    const now = new Date();

    // Update digital time
    const timeString = now.toLocaleTimeString('en-US', {
        hour12: false,
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
    });

    const dateString = now.toLocaleDateString('en-US', {
        weekday: 'long',
        day: 'numeric',
        month: 'long',
        year: 'numeric'
    });

    const timeElement = document.getElementById('currentTime');
    const dateElement = document.getElementById('currentDate');

    if (timeElement)
        timeElement.textContent = timeString;
    if (dateElement)
        dateElement.textContent = dateString;

    // Update analog clock
    updateAnalogClock(now);
}

function updateAnalogClock(now) {
    const hours = now.getHours() % 12;
    const minutes = now.getMinutes();
    const seconds = now.getSeconds();

    const hourAngle = (hours * 30) + (minutes * 0.5);
    const minuteAngle = minutes * 6;
    const secondAngle = seconds * 6;

    const hourHand = document.getElementById('miniHourHand');
    const minuteHand = document.getElementById('miniMinuteHand');
    const secondHand = document.getElementById('miniSecondHand');

    if (hourHand)
        hourHand.style.transform = `rotate(${hourAngle}deg)`;
    if (minuteHand)
        minuteHand.style.transform = `rotate(${minuteAngle}deg)`;
    if (secondHand)
        secondHand.style.transform = `rotate(${secondAngle}deg)`;
}

// Calendar functionality
function initializeCalendar() {
    const prevBtn = document.getElementById('prevMonth');
    const nextBtn = document.getElementById('nextMonth');
    const monthYearSpan = document.getElementById('monthYear');

    let currentDate = new Date();

    function updateCalendar() {
        const months = [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'
        ];

        if (monthYearSpan) {
            monthYearSpan.textContent = `${months[currentDate.getMonth()]}, ${currentDate.getFullYear()}`;
        }

        generateCalendarDates();
    }

    function generateCalendarDates() {
        const calendarDates = document.getElementById('calendarDates');
        if (!calendarDates)
            return;

        calendarDates.innerHTML = '';

        const year = currentDate.getFullYear();
        const month = currentDate.getMonth();
        const firstDay = new Date(year, month, 1).getDay();
        const daysInMonth = new Date(year, month + 1, 0).getDate();
        const today = new Date();

        // Previous month's trailing days
        const prevMonth = new Date(year, month - 1, 0);
        const prevMonthDays = prevMonth.getDate();

        for (let i = firstDay - 1; i >= 0; i--) {
            const dateSpan = createDateSpan(prevMonthDays - i, 'other-month');
            calendarDates.appendChild(dateSpan);
        }

        // Current month days
        for (let day = 1; day <= daysInMonth; day++) {
            const dateSpan = createDateSpan(day);

            // Mark today
            if (year === today.getFullYear() &&
                    month === today.getMonth() &&
                    day === today.getDate()) {
                dateSpan.classList.add('today');
            }

            calendarDates.appendChild(dateSpan);
        }

        // Next month's leading days
        const totalCells = calendarDates.children.length;
        const remainingCells = 42 - totalCells; // 6 rows × 7 days

        for (let day = 1; day <= remainingCells && remainingCells < 7; day++) {
            const dateSpan = createDateSpan(day, 'other-month');
            calendarDates.appendChild(dateSpan);
        }
    }

    function createDateSpan(day, className = '') {
        const span = document.createElement('span');
        span.textContent = day;
        if (className)
            span.classList.add(className);

        span.addEventListener('click', () => {
            // Remove previous selection
            document.querySelectorAll('.calendar-dates span.selected').forEach(s => {
                s.classList.remove('selected');
            });

            // Add selection to clicked date
            if (!span.classList.contains('other-month')) {
                span.classList.add('selected');
                showNotification(`Selected date ${day}`, 'info');
            }
        });

        return span;
    }

    if (prevBtn) {
        prevBtn.addEventListener('click', () => {
            currentDate.setMonth(currentDate.getMonth() - 1);
            updateCalendar();
        });
    }

    if (nextBtn) {
        nextBtn.addEventListener('click', () => {
            currentDate.setMonth(currentDate.getMonth() + 1);
            updateCalendar();
        });
    }

    // Initialize calendar
    updateCalendar();
}

// Interactive elements
function initializeInteractions() {
    // Primary button
    const primaryBtn = document.querySelector('.primary-btn');
    if (primaryBtn) {
        primaryBtn.addEventListener('click', () => {
            showNotification('Create new project feature is coming soon!', 'info');
        });
    }

    // Secondary button
    const secondaryBtn = document.querySelector('.secondary-btn');
    if (secondaryBtn) {
        secondaryBtn.addEventListener('click', () => {
            showNotification('Opening tutorial...', 'info');
        });
    }

    // Stat items
    const statItems = document.querySelectorAll('.stat-item');
    statItems.forEach(item => {
        item.addEventListener('click', () => {
            const label = item.querySelector('.stat-label').textContent;
            showNotification(`View details: ${label}`, 'info');
        });
    });

    // Activity items
    const activityItems = document.querySelectorAll('.activity-item');
    activityItems.forEach(item => {
        item.addEventListener('click', () => {
            const text = item.querySelector('.activity-text').textContent;
            showNotification(`Details: ${text}`, 'info');
        });
    });
}

// Animations
function initializeAnimations() {
    // Animate floating shapes
    const shapes = document.querySelectorAll('.shape');
    shapes.forEach((shape, index) => {
        shape.style.animationDelay = `${index * 0.5}s`;
    });

    // Animate stats on load
    setTimeout(() => {
        const statNumbers = document.querySelectorAll('.stat-number');
        statNumbers.forEach(stat => {
            const finalValue = parseInt(stat.textContent);
            animateNumber(stat, 0, finalValue, 1000);
        });
    }, 500);
}

// Utility functions
function animateNumber(element, start, end, duration) {
    const startTime = performance.now();

    function update(currentTime) {
        const elapsed = currentTime - startTime;
        const progress = Math.min(elapsed / duration, 1);

        const current = Math.floor(start + (end - start) * easeOutCubic(progress));
        element.textContent = current;

        if (progress < 1) {
            requestAnimationFrame(update);
        }
    }

    requestAnimationFrame(update);
}

function easeOutCubic(t) {
    return 1 - Math.pow(1 - t, 3);
}

function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;

    const iconMap = {
        success: 'check-circle',
        info: 'info-circle',
        warning: 'exclamation-triangle',
        error: 'times-circle'
    };

    const colorMap = {
        success: '#10b981',
        info: '#667eea',
        warning: '#f59e0b',
        error: '#ef4444'
    };

    notification.innerHTML = `
        <div class="notification-content">
            <i class="fas fa-${iconMap[type] || 'info-circle'}"></i>
            <span>${message}</span>
        </div>
    `;

    notification.style.cssText = `
        position: fixed;
        top: 2rem;
        right: 2rem;
        background: ${colorMap[type] || '#667eea'};
        color: white;
        padding: 1rem 1.5rem;
        border-radius: 12px;
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

    setTimeout(() => {
        notification.style.transform = 'translateX(0)';
    }, 100);

    setTimeout(() => {
        notification.style.transform = 'translateX(100%)';
        setTimeout(() => {
            if (document.body.contains(notification)) {
                document.body.removeChild(notification);
            }
        }, 300);
    }, 3000);
}

// Dark mode toggle (if needed)
function toggleDarkMode() {
    document.body.classList.toggle('dark-mode');
    const isDark = document.body.classList.contains('dark-mode');
    localStorage.setItem('darkMode', isDark);
    showNotification(isDark ? 'Switched to dark mode' : 'Switched to light mode', 'info');
}

// Load saved dark mode preference
function loadDarkModePreference() {
    const savedMode = localStorage.getItem('darkMode');
    if (savedMode === 'true') {
        document.body.classList.add('dark-mode');
    }
}

// Initialize dark mode on load
document.addEventListener('DOMContentLoaded', loadDarkModePreference);

// Export functions for global access
window.showNotification = showNotification;
window.toggleDarkMode = toggleDarkMode;


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

    cachedElements.darkModeToggle.addEventListener('change', debouncedThemeChange, {passive: true});
}

document.addEventListener("DOMContentLoaded", function () {
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
});

document.addEventListener('DOMContentLoaded', function () {
    // Khởi tạo dark mode từ localStorage
    const savedTheme = localStorage.getItem('theme') || 'light-mode';
    const darkModeToggle = document.getElementById('darkModeToggle');

    if (savedTheme === 'dark-mode') {
        document.body.classList.add('dark-mode');
        if (darkModeToggle)
            darkModeToggle.checked = true;
    } else {
        document.body.classList.remove('dark-mode');
        if (darkModeToggle)
            darkModeToggle.checked = false;
    }

    // Toggle dark mode
    if (darkModeToggle) {
        darkModeToggle.addEventListener('change', function () {
            const isDark = darkModeToggle.checked;
            document.body.classList.toggle('dark-mode', isDark);
            localStorage.setItem('theme', isDark ? 'dark-mode' : 'light-mode');
        });
    }

    console.log("✅ Dark mode initialized in Home.jsp");
});

