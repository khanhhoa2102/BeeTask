document.addEventListener("DOMContentLoaded", () => {
  initializeTimer()
  initializeCalendar()
  initializeInteractions()
  initializeResponsive()
})

// Updated Timer functionality - Now shows current time with analog clock
function initializeTimer() {
  updateCurrentTime();
  updateAnalogClock();
  
  // Update every second
  setInterval(() => {
    updateCurrentTime();
    updateAnalogClock();
  }, 1000);
}

function updateCurrentTime() {
  const now = new Date();
  
  // Format time (24-hour format)
  const hours = now.getHours().toString().padStart(2, '0');
  const minutes = now.getMinutes().toString().padStart(2, '0');
  const seconds = now.getSeconds().toString().padStart(2, '0');
  
  // Format date in Vietnamese
  const days = ['Chủ Nhật', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy'];
  const months = ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 
                 'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'];
  
  const dayName = days[now.getDay()];
  const day = now.getDate();
  const month = months[now.getMonth()];
  const year = now.getFullYear();
  
  const dateString = `${dayName}, ${day} ${month} ${year}`;
  
  // Update display
  const timeElement = document.getElementById('currentTime');
  const dateElement = document.getElementById('currentDate');
  
  if (timeElement) {
    timeElement.textContent = `${hours}:${minutes}:${seconds}`;
  }
  
  if (dateElement) {
    dateElement.textContent = dateString;
  }
}

function updateAnalogClock() {
  const now = new Date();
  const hours = now.getHours() % 12;
  const minutes = now.getMinutes();
  const seconds = now.getSeconds();
  
  // Calculate angles
  const hourAngle = (hours * 30) + (minutes * 0.5); // 30 degrees per hour + minute adjustment
  const minuteAngle = minutes * 6; // 6 degrees per minute
  const secondAngle = seconds * 6; // 6 degrees per second
  
  // Update clock hands
  const hourHand = document.getElementById('hourHand');
  const minuteHand = document.getElementById('minuteHand');
  const secondHand = document.getElementById('secondHand');
  
  if (hourHand) {
    hourHand.style.transform = `rotate(${hourAngle}deg)`;
  }
  
  if (minuteHand) {
    minuteHand.style.transform = `rotate(${minuteAngle}deg)`;
  }
  
  if (secondHand) {
    secondHand.style.transform = `rotate(${secondAngle}deg)`;
  }
}

// Calendar functionality
function initializeCalendar() {
  const prevBtn = document.querySelector(".calendar-nav.prev")
  const nextBtn = document.querySelector(".calendar-nav.next")
  const monthYear = document.querySelector(".calendar-header h4")

  let currentMonth = new Date().getMonth(); // Current month (0-indexed)
  let currentYear = new Date().getFullYear(); // Current year

  const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

  function updateCalendar() {
    monthYear.textContent = `${months[currentMonth]} ${currentYear}`;
    generateCalendarDates();
  }

  function generateCalendarDates() {
    const calendarDates = document.querySelector('.calendar-dates');
    if (!calendarDates) return;

    // Clear existing dates
    calendarDates.innerHTML = '';

    const firstDay = new Date(currentYear, currentMonth, 1).getDay();
    const daysInMonth = new Date(currentYear, currentMonth + 1, 0).getDate();
    const today = new Date();
    const isCurrentMonth = today.getMonth() === currentMonth && today.getFullYear() === currentYear;
    const todayDate = today.getDate();

    // Add empty cells for days before the first day of the month
    for (let i = 0; i < firstDay; i++) {
      const emptyCell = document.createElement('span');
      calendarDates.appendChild(emptyCell);
    }

    // Add days of the month
    for (let day = 1; day <= daysInMonth; day++) {
      const dateCell = document.createElement('span');
      dateCell.textContent = day;
      
      if (isCurrentMonth && day === todayDate) {
        dateCell.classList.add('today');
      }

      dateCell.addEventListener('click', () => {
        // Remove today class from all dates
        document.querySelectorAll('.calendar-dates span').forEach(d => d.classList.remove('today'));
        // Add today class to clicked date
        dateCell.classList.add('today');
        console.log(`Selected date: ${day}/${currentMonth + 1}/${currentYear}`);
      });

      calendarDates.appendChild(dateCell);
    }
  }

  if (prevBtn) {
    prevBtn.addEventListener("click", () => {
      currentMonth--
      if (currentMonth < 0) {
        currentMonth = 11
        currentYear--
      }
      updateCalendar()
    })
  }

  if (nextBtn) {
    nextBtn.addEventListener("click", () => {
      currentMonth++
      if (currentMonth > 11) {
        currentMonth = 0
        currentYear++
      }
      updateCalendar()
    })
  }

  // Initialize calendar
  updateCalendar();
}

// Interactive elements
function initializeInteractions() {
  // Task cards hover effects
  const taskCards = document.querySelectorAll(".task-card")
  taskCards.forEach((card) => {
    card.addEventListener("click", () => {
      const taskTitle = card.querySelector(".task-title");
      if (taskTitle) {
        console.log("Navigate to task:", taskTitle.textContent)
        showNotification(`Opened task: ${taskTitle.textContent}`, "success");
      }
    })
  })

  // Project items in sidebar
  const projectItems = document.querySelectorAll(".project-item")
  projectItems.forEach((item) => {
    item.addEventListener("click", () => {
      // Remove active class from all items
      projectItems.forEach((p) => p.classList.remove("active"))
      // Add active class to clicked item
      item.classList.add("active")
      const projectName = item.querySelector("span");
      if (projectName) {
        console.log("Navigate to project:", projectName.textContent)
        showNotification(`Switched to project: ${projectName.textContent}`, "info");
      }
    })
  })

  // Message items
  const messageItems = document.querySelectorAll(".message-item")
  messageItems.forEach((item) => {
    item.addEventListener("click", () => {
      const senderName = item.querySelector(".sender-name");
      if (senderName) {
        console.log("Open message from:", senderName.textContent)
        showNotification(`Opening message from ${senderName.textContent}`, "info");
      }
    })
  })

  // Search functionality
  const searchInput = document.querySelector(".search-input")
  if (searchInput) {
    searchInput.addEventListener("input", (e) => {
      const searchTerm = e.target.value.toLowerCase()
      console.log("Searching for:", searchTerm)
      
      if (searchTerm.length > 2) {
        // Simulate search results
        setTimeout(() => {
          showNotification(`Found results for "${searchTerm}"`, "success");
        }, 500);
      }
    })
  }

  // User menu dropdown
  const userMenu = document.querySelector(".user-menu")
  if (userMenu) {
    userMenu.addEventListener("click", () => {
      console.log("Toggle user menu")
      showNotification("User menu opened", "info");
    })
  }

  // Notification button
  const notificationBtn = document.querySelector(".notification-btn")
  if (notificationBtn) {
    notificationBtn.addEventListener("click", () => {
      console.log("Show notifications")
      showNotification("You have 3 new notifications", "info");
    })
  }

  // Stats cards interactions
  const statCards = document.querySelectorAll(".stat-card")
  statCards.forEach((card) => {
    card.addEventListener("click", () => {
      const statInfo = card.querySelector(".stat-info p");
      if (statInfo) {
        showNotification(`Viewing ${statInfo.textContent} details`, "info");
      }
    })
  })

  // View all buttons
  const viewAllBtns = document.querySelectorAll(".view-all-btn")
  viewAllBtns.forEach((btn) => {
    btn.addEventListener("click", () => {
      showNotification("Loading all items...", "info");
    })
  })
}

// Responsive functionality
function initializeResponsive() {
  const sidebar = document.querySelector(".sidebar")
  let sidebarToggle

  // Create mobile menu button if screen is small
  function createMobileToggle() {
    if (window.innerWidth <= 768 && !sidebarToggle) {
      sidebarToggle = document.createElement("button")
      sidebarToggle.className = "mobile-toggle"
      sidebarToggle.innerHTML = '<i class="fas fa-bars"></i>'
      sidebarToggle.style.cssText = `
        position: fixed;
        top: 1rem;
        left: 1rem;
        z-index: 1001;
        background: #667eea;
        color: white;
        border: none;
        padding: 0.75rem;
        border-radius: 10px;
        cursor: pointer;
        box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        transition: all 0.3s ease;
      `

      document.body.appendChild(sidebarToggle)

      sidebarToggle.addEventListener("click", () => {
        sidebar.classList.toggle("open")
        sidebarToggle.innerHTML = sidebar.classList.contains("open") 
          ? '<i class="fas fa-times"></i>' 
          : '<i class="fas fa-bars"></i>';
      })

      // Close sidebar when clicking outside
      document.addEventListener("click", (e) => {
        if (!sidebar.contains(e.target) && !sidebarToggle.contains(e.target) && sidebar.classList.contains("open")) {
          sidebar.classList.remove("open")
          sidebarToggle.innerHTML = '<i class="fas fa-bars"></i>';
        }
      })
    } else if (window.innerWidth > 768 && sidebarToggle) {
      sidebarToggle.remove()
      sidebarToggle = null
      sidebar.classList.remove("open")
    }
  }

  // Initialize on load
  createMobileToggle()

  // Handle window resize
  window.addEventListener("resize", createMobileToggle)
}

// Utility functions
function showNotification(message, type = "success") {
  const notification = document.createElement("div")
  notification.className = `notification ${type}`
  
  const iconMap = {
    success: "check-circle",
    info: "info-circle",
    warning: "exclamation-triangle",
    error: "times-circle"
  };

  const colorMap = {
    success: "#10b981",
    info: "#667eea",
    warning: "#f59e0b",
    error: "#ef4444"
  };

  notification.innerHTML = `
    <div class="notification-content">
      <i class="fas fa-${iconMap[type] || 'info-circle'}"></i>
      <span>${message}</span>
    </div>
  `

  notification.style.cssText = `
    position: fixed;
    top: 2rem;
    right: 2rem;
    background: ${colorMap[type] || '#667eea'};
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
  `

  document.body.appendChild(notification)

  setTimeout(() => {
    notification.style.transform = "translateX(0)"
  }, 100)

  setTimeout(() => {
    notification.style.transform = "translateX(100%)"
    setTimeout(() => {
      if (document.body.contains(notification)) {
        document.body.removeChild(notification)
      }
    }, 300)
  }, 3000)
}

// Add smooth animations for task progress bars
function animateProgressBars() {
  const progressBars = document.querySelectorAll(".progress-fill")
  progressBars.forEach((bar, index) => {
    const width = bar.style.width
    bar.style.width = "0%"
    bar.style.transition = "width 1s ease-in-out"
    
    setTimeout(() => {
      bar.style.width = width
    }, 500 + (index * 200)) // Stagger the animations
  })
}

// Initialize progress bar animations when page loads
setTimeout(animateProgressBars, 1000)

// Additional utility functions for enhanced functionality

// Format time for different locales
function formatTimeForLocale(date, locale = 'vi-VN') {
  return date.toLocaleTimeString(locale, {
    hour12: false,
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
  });
}

// Format date for different locales
function formatDateForLocale(date, locale = 'vi-VN') {
  return date.toLocaleDateString(locale, {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });
}

// Smooth scroll to element
function smoothScrollTo(element) {
  if (element) {
    element.scrollIntoView({
      behavior: 'smooth',
      block: 'start'
    });
  }
}

// Debounce function for search
function debounce(func, wait) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

// Enhanced search with debouncing
const debouncedSearch = debounce((searchTerm) => {
  console.log("Performing search for:", searchTerm);
  // Add actual search logic here
}, 300);

// Theme toggle functionality (if needed)
function toggleTheme() {
  const body = document.body;
  const isDark = body.classList.contains('dark-theme');
  
  if (isDark) {
    body.classList.remove('dark-theme');
    localStorage.setItem('theme', 'light');
    showNotification("Switched to light theme", "info");
  } else {
    body.classList.add('dark-theme');
    localStorage.setItem('theme', 'dark');
    showNotification("Switched to dark theme", "info");
  }
}

// Load saved theme on page load
function loadSavedTheme() {
  const savedTheme = localStorage.getItem('theme');
  if (savedTheme === 'dark') {
    document.body.classList.add('dark-theme');
  }
}

// Initialize theme on page load
document.addEventListener('DOMContentLoaded', loadSavedTheme);

// Export functions for global access (if needed)
window.updateCurrentTime = updateCurrentTime;
window.showNotification = showNotification;
window.toggleTheme = toggleTheme;