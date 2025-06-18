document.addEventListener("DOMContentLoaded", () => {
  initializeTimer()
  initializeCalendar()
  initializeInteractions()
  initializeResponsive()
})

// Timer functionality
function initializeTimer() {
  let seconds = 0
  let minutes = 36
  let hours = 2
  let isRunning = false
  let timerInterval

  const timerDisplay = document.querySelector(".timer-display .time")
  const playBtn = document.querySelector(".timer-btn.play")
  const pauseBtn = document.querySelector(".timer-btn.pause")

  function updateDisplay() {
    const formattedHours = hours.toString().padStart(2, "0")
    const formattedMinutes = minutes.toString().padStart(2, "0")
    const formattedSeconds = seconds.toString().padStart(2, "0")
    timerDisplay.textContent = `${formattedHours}:${formattedMinutes}:${formattedSeconds}`
  }

  function startTimer() {
    if (!isRunning) {
      isRunning = true
      timerInterval = setInterval(() => {
        seconds++
        if (seconds >= 60) {
          seconds = 0
          minutes++
          if (minutes >= 60) {
            minutes = 0
            hours++
          }
        }
        updateDisplay()
      }, 1000)
    }
  }

  function pauseTimer() {
    isRunning = false
    clearInterval(timerInterval)
  }

  playBtn.addEventListener("click", startTimer)
  pauseBtn.addEventListener("click", pauseTimer)

  updateDisplay()
}

// Calendar functionality
function initializeCalendar() {
  const prevBtn = document.querySelector(".calendar-nav.prev")
  const nextBtn = document.querySelector(".calendar-nav.next")
  const monthYear = document.querySelector(".calendar-header h4")

  let currentMonth = 8 // September (0-indexed)
  let currentYear = 2023

  const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

  function updateCalendar() {
    monthYear.textContent = `${months[currentMonth]} ${currentYear}`
    // Here you would update the calendar dates
    // For now, we'll keep the static dates
  }

  prevBtn.addEventListener("click", () => {
    currentMonth--
    if (currentMonth < 0) {
      currentMonth = 11
      currentYear--
    }
    updateCalendar()
  })

  nextBtn.addEventListener("click", () => {
    currentMonth++
    if (currentMonth > 11) {
      currentMonth = 0
      currentYear++
    }
    updateCalendar()
  })
}

// Interactive elements
function initializeInteractions() {
  // Task cards hover effects
  const taskCards = document.querySelectorAll(".task-card")
  taskCards.forEach((card) => {
    card.addEventListener("click", () => {
      console.log("Navigate to task:", card.querySelector(".task-title").textContent)
      // Add navigation logic here
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
      console.log("Navigate to project:", item.querySelector("span").textContent)
    })
  })

  // Message items
  const messageItems = document.querySelectorAll(".message-item")
  messageItems.forEach((item) => {
    item.addEventListener("click", () => {
      console.log("Open message from:", item.querySelector(".sender-name").textContent)
      // Add message opening logic here
    })
  })

  // Calendar dates
  const calendarDates = document.querySelectorAll(".calendar-dates span")
  calendarDates.forEach((date) => {
    if (date.textContent) {
      date.addEventListener("click", () => {
        // Remove today class from all dates
        calendarDates.forEach((d) => d.classList.remove("today"))
        // Add today class to clicked date
        date.classList.add("today")
        console.log("Selected date:", date.textContent)
      })
    }
  })

  // Search functionality
  const searchInput = document.querySelector(".search-input")
  searchInput.addEventListener("input", (e) => {
    const searchTerm = e.target.value.toLowerCase()
    console.log("Searching for:", searchTerm)
    // Add search logic here
  })

  // User menu dropdown
  const userMenu = document.querySelector(".user-menu")
  userMenu.addEventListener("click", () => {
    console.log("Toggle user menu")
    // Add dropdown menu logic here
  })

  // Notification button
  const notificationBtn = document.querySelector(".notification-btn")
  notificationBtn.addEventListener("click", () => {
    console.log("Show notifications")
    // Add notification panel logic here
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
            `

      document.body.appendChild(sidebarToggle)

      sidebarToggle.addEventListener("click", () => {
        sidebar.classList.toggle("open")
      })

      // Close sidebar when clicking outside
      document.addEventListener("click", (e) => {
        if (!sidebar.contains(e.target) && !sidebarToggle.contains(e.target) && sidebar.classList.contains("open")) {
          sidebar.classList.remove("open")
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
  notification.innerHTML = `
        <div class="notification-content">
            <i class="fas fa-${type === "success" ? "check-circle" : "info-circle"}"></i>
            <span>${message}</span>
        </div>
    `

  notification.style.cssText = `
        position: fixed;
        top: 2rem;
        right: 2rem;
        background: ${type === "success" ? "#10b981" : "#667eea"};
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
    `

  document.body.appendChild(notification)

  setTimeout(() => {
    notification.style.transform = "translateX(0)"
  }, 100)

  setTimeout(() => {
    notification.style.transform = "translateX(100%)"
    setTimeout(() => {
      document.body.removeChild(notification)
    }, 300)
  }, 3000)
}

// Add smooth animations for task progress bars
function animateProgressBars() {
  const progressBars = document.querySelectorAll(".progress-fill")
  progressBars.forEach((bar) => {
    const width = bar.style.width
    bar.style.width = "0%"
    setTimeout(() => {
      bar.style.width = width
    }, 500)
  })
}

// Initialize progress bar animations when page loads
setTimeout(animateProgressBars, 1000)
