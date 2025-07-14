// Enhanced TaskScript.js for BeeTask
document.addEventListener("DOMContentLoaded", () => {
  class TaskManager {
    constructor() {
      this.currentTheme = localStorage.getItem("theme") || "light-mode"
      this.currentView = localStorage.getItem("boardView") || "grid"
      this.init()
    }

    init() {
      this.applyTheme(this.currentTheme)
      this.applyView(this.currentView)
      this.bindEvents()
      this.updateStats()
      this.updateBoardCounters()
      this.initializeSortable()
    }

    bindEvents() {
      // Dark mode toggle
      const themeToggle = document.getElementById("darkModeToggle")
      if (themeToggle) {
        themeToggle.checked = this.currentTheme === "dark-mode"
        themeToggle.addEventListener("change", () => {
          const isDark = themeToggle.checked
          const newTheme = isDark ? "dark-mode" : "light-mode"
          this.applyTheme(newTheme)
          localStorage.setItem("theme", newTheme)
        })
      }

      // Search functionality
      const boardSearch = document.getElementById("boardSearch")
      if (boardSearch) {
        boardSearch.addEventListener("input", (e) => this.handleBoardSearch(e.target.value))
      }

      const searchInput = document.getElementById("searchInput")
      if (searchInput) {
        searchInput.addEventListener("input", (e) => this.handleTaskSearch(e.target.value))
      }

      // View toggle buttons
      document.querySelectorAll(".view-btn").forEach((btn) => {
        btn.addEventListener("click", (e) => this.handleViewToggle(e.target))
      })

      // Filter buttons
      document.querySelectorAll(".filter-btn").forEach((btn) => {
        btn.addEventListener("click", (e) => this.handleFilter(e.target))
      })

      // Board menu toggles
      document.addEventListener("click", (e) => {
        if (!e.target.closest(".board-menu")) {
          document.querySelectorAll(".board-dropdown").forEach((dropdown) => {
            dropdown.style.display = "none"
          })
        }
      })

      // Modal close on outside click
      window.addEventListener("click", (event) => {
        if (event.target.classList.contains("modal")) {
          this.closeAllModals()
        }
      })

      // Keyboard shortcuts
      document.addEventListener("keydown", (e) => this.handleKeyboardShortcuts(e))
    }

    applyTheme(theme) {
      document.body.classList.toggle("dark-mode", theme === "dark-mode")
      this.currentTheme = theme
    }

    applyView(view) {
      const container = document.getElementById("boardsContainer")
      if (container) {
        container.className = `boards-container ${view}-view`

        // Update view buttons
        document.querySelectorAll(".view-btn").forEach((btn) => {
          btn.classList.toggle("active", btn.dataset.view === view)
        })
      }
      this.currentView = view
    }

    handleViewToggle(button) {
      const view = button.dataset.view
      this.applyView(view)
      localStorage.setItem("boardView", view)
    }

    handleBoardSearch(query) {
      const searchTerm = query.toLowerCase().trim()
      document.querySelectorAll(".board-card:not(.add-board-card)").forEach((card) => {
        const title = card.querySelector(".board-title")?.textContent.toLowerCase() || ""
        const match = !searchTerm || title.includes(searchTerm)
        card.style.display = match ? "block" : "none"
      })
    }

    handleTaskSearch(query) {
      const searchTerm = query.toLowerCase().trim()
      document.querySelectorAll(".task-card").forEach((card) => {
        const title = card.querySelector(".task-title")?.textContent.toLowerCase() || ""
        const desc = card.querySelector(".task-description")?.textContent.toLowerCase() || ""
        const match = !searchTerm || title.includes(searchTerm) || desc.includes(searchTerm)
        card.style.display = match ? "block" : "none"
      })

      document.querySelectorAll(".table-row").forEach((row) => {
        const title = row.querySelector(".task-details h4")?.textContent.toLowerCase() || ""
        const match = !searchTerm || title.includes(searchTerm)
        row.style.display = match ? "grid" : "none"
      })

      this.updateBoardCounters()
    }

    handleFilter(btn) {
      document.querySelectorAll(".filter-btn").forEach((b) => b.classList.remove("active"))
      btn.classList.add("active")

      const filter = btn.dataset.filter
      document.querySelectorAll(".table-row").forEach((row) => {
        const status = (row.dataset.status || "").toLowerCase()
        row.style.display = filter === "all" || status === filter ? "grid" : "none"
      })
    }

    handleKeyboardShortcuts(e) {
      // Ctrl/Cmd + K for search
      if ((e.ctrlKey || e.metaKey) && e.key === "k") {
        e.preventDefault()
        const searchInput = document.getElementById("boardSearch") || document.getElementById("searchInput")
        if (searchInput) {
          searchInput.focus()
        }
      }

      // Escape to close modals
      if (e.key === "Escape") {
        this.closeAllModals()
      }

      // Ctrl/Cmd + B for new board
      if ((e.ctrlKey || e.metaKey) && e.key === "b") {
        e.preventDefault()
        window.openAddBoardModal() // Assuming openAddBoardModal is a global function
      }
    }

    updateStats() {
      const totalTasks = document.querySelectorAll(".task-card").length
      const pendingTasks = document.querySelectorAll(
        ".task-card .status-badge.todo, .task-card .status-badge.inprogress",
      ).length
      const completedTasks = document.querySelectorAll(".task-card .status-badge.done").length

      const totalEl = document.getElementById("totalTasks")
      const pendingEl = document.getElementById("pendingTasks")
      const completedEl = document.getElementById("completedTasks")

      if (totalEl) totalEl.textContent = totalTasks
      if (pendingEl) pendingEl.textContent = pendingTasks
      if (completedEl) completedEl.textContent = completedTasks
    }

    updateBoardCounters() {
      document.querySelectorAll(".board-card:not(.add-board-card)").forEach((board) => {
        const visibleTasks = board.querySelectorAll('.task-card:not([style*="display: none"])').length
        const totalTasks = board.querySelectorAll(".task-card").length
        const completedTasks = board.querySelectorAll(".task-card .status-badge.done").length

        const counter = board.querySelector(".task-count")
        const progressFill = board.querySelector(".progress-fill")
        const progressText = board.querySelector(".progress-text")

        if (counter) {
          counter.textContent = visibleTasks
        }

        if (progressFill && progressText) {
          const percentage = totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0
          progressFill.style.width = `${percentage}%`
          progressText.textContent = `${completedTasks}/${totalTasks}`
        }
      })
    }

    initializeSortable() {
      // Load SortableJS
      const Sortable = window.Sortable // Assuming Sortable is available globally
      if (typeof Sortable === "undefined") {
        const script = document.createElement("script")
        script.src = "https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"
        script.onload = () => this.setupSortable()
        document.head.appendChild(script)
      } else {
        this.setupSortable()
      }
    }

    setupSortable() {
      // Drag tasks between boards
      document.querySelectorAll(".board-tasks").forEach((board) => {
        new window.Sortable(board, {
          group: "shared",
          animation: 150,
          ghostClass: "sortable-ghost",
          chosenClass: "sortable-chosen",
          dragClass: "sortable-drag",
          onStart: (evt) => {
            document.querySelectorAll(".board-tasks").forEach((b) => {
              b.classList.add("drag-over")
            })
          },
          onEnd: (evt) => {
            document.querySelectorAll(".board-tasks").forEach((b) => {
              b.classList.remove("drag-over")
            })

            const taskId = evt.item.getAttribute("data-task-id")
            const newBoardId = evt.to.closest(".board-card").getAttribute("data-board-id")
            const newIndex = evt.newIndex

            // Update task position via AJAX
            fetch("task?action=move", {
              method: "POST",
              headers: { "Content-Type": "application/x-www-form-urlencoded" },
              body: `taskId=${taskId}&newBoardId=${newBoardId}&newIndex=${newIndex}`,
            })
              .then((response) => {
                if (response.ok) {
                  this.updateBoardCounters()
                  this.showNotification("Task moved successfully", "success")
                } else {
                  this.showNotification("Error moving task", "error")
                }
              })
              .catch((err) => {
                console.error("Error moving task:", err)
                this.showNotification("Error moving task", "error")
              })
          },
        })
      })

      // Drag boards to reorder
      const boardsContainer = document.getElementById("boardsContainer")
      if (boardsContainer) {
        new window.Sortable(boardsContainer, {
          animation: 200,
          filter: ".add-board-card",
          onEnd: (evt) => {
            const boardCards = document.querySelectorAll(".boards-container .board-card:not(.add-board-card)")
            const updates = []

            boardCards.forEach((card, index) => {
              const boardId = card.getAttribute("data-board-id")
              updates.push(`boardIds[]=${boardId}&positions[]=${index}`)
            })

            fetch("board?action=moveBoardPosition", {
              method: "POST",
              headers: { "Content-Type": "application/x-www-form-urlencoded" },
              body: updates.join("&"),
            })
              .then((response) => {
                if (response.ok) {
                  this.showNotification("Board order updated", "success")
                } else {
                  this.showNotification("Error updating board order", "error")
                }
              })
              .catch((err) => {
                console.error("Error moving board:", err)
                this.showNotification("Error updating board order", "error")
              })
          },
        })
      }
    }

    showNotification(message, type = "info") {
      // Create notification element
      const notification = document.createElement("div")
      notification.className = `notification notification-${type}`
      notification.innerHTML = `
                <div class="notification-content">
                    <i class="fas fa-${type === "success" ? "check-circle" : type === "error" ? "exclamation-circle" : "info-circle"}"></i>
                    <span>${message}</span>
                </div>
            `

      // Add to page
      document.body.appendChild(notification)

      // Show notification
      setTimeout(() => notification.classList.add("show"), 100)

      // Remove notification after 3 seconds
      setTimeout(() => {
        notification.classList.remove("show")
        setTimeout(() => notification.remove(), 300)
      }, 3000)
    }

    closeAllModals() {
      document.querySelectorAll(".modal").forEach((modal) => {
        modal.style.display = "none"
      })
    }

    // Board management functions
    editBoard(boardId, currentName) {
      const newName = prompt("Enter new board name:", currentName)
      if (newName && newName.trim() !== "" && newName !== currentName) {
        fetch("board?action=edit", {
          method: "POST",
          headers: { "Content-Type": "application/x-www-form-urlencoded" },
          body: `boardId=${boardId}&name=${encodeURIComponent(newName.trim())}`,
        })
          .then((response) => {
            if (response.ok) {
              location.reload() // Refresh to show changes
            } else {
              this.showNotification("Error updating board name", "error")
            }
          })
          .catch((err) => {
            console.error("Error editing board:", err)
            this.showNotification("Error updating board name", "error")
          })
      }
    }

    duplicateBoard(boardId) {
      if (confirm("Duplicate this board with all its tasks?")) {
        fetch("board?action=duplicate", {
          method: "POST",
          headers: { "Content-Type": "application/x-www-form-urlencoded" },
          body: `boardId=${boardId}`,
        })
          .then((response) => {
            if (response.ok) {
              location.reload() // Refresh to show new board
            } else {
              this.showNotification("Error duplicating board", "error")
            }
          })
          .catch((err) => {
            console.error("Error duplicating board:", err)
            this.showNotification("Error duplicating board", "error")
          })
      }
    }
  }

  // Initialize TaskManager
  const taskManager = new TaskManager()

  // Global functions for JSP compatibility
  window.toggleBoardMenu = (button) => {
    const dropdown = button.parentElement.querySelector(".board-dropdown")
    const isVisible = dropdown.style.display === "block"

    // Close all other dropdowns
    document.querySelectorAll(".board-dropdown").forEach((d) => {
      d.style.display = "none"
    })

    // Toggle current dropdown
    dropdown.style.display = isVisible ? "none" : "block"
  }

  window.editBoard = (boardId, currentName) => {
    taskManager.editBoard(boardId, currentName)
  }

  window.duplicateBoard = (boardId) => {
    taskManager.duplicateBoard(boardId)
  }

  window.toggleViewMode = () => {
    const newView = taskManager.currentView === "grid" ? "list" : "grid"
    taskManager.applyView(newView)
    localStorage.setItem("boardView", newView)

    // Update button text
    const viewModeText = document.getElementById("viewModeText")
    const viewModeIcon = document.getElementById("viewModeIcon")
    if (viewModeText && viewModeIcon) {
      viewModeText.textContent = newView === "grid" ? "Grid View" : "List View"
      viewModeIcon.className = newView === "grid" ? "fas fa-th-large" : "fas fa-list"
    }
  }

  window.openAddBoardModal = () => {
    document.getElementById("addBoardModal").style.display = "block"
  }

  window.closeAddBoardModal = () => {
    document.getElementById("addBoardModal").style.display = "none"
  }

  window.openAddTaskModal = (boardId) => {
    document.getElementById("addTaskModal").style.display = "block"
    document.getElementById("taskBoardId").value = boardId
  }

  window.closeAddTaskModal = () => {
    document.getElementById("addTaskModal").style.display = "none"
  }

  window.openTaskDetailPopup = (taskId, title, description, dueDate, priority, status) => {
    document.getElementById("taskDetailId").value = taskId
    document.getElementById("taskDetailTitle").innerText = title
    document.getElementById("taskDetailDescription").innerText = description
    document.getElementById("taskDetailDueDate").innerText = dueDate
    document.getElementById("taskDetailPriority").innerText = priority
    document.getElementById("taskDetailStatus").innerText = status
    document.getElementById("taskDetailModal").style.display = "block"
  }

  window.closeTaskDetailModal = () => {
    document.getElementById("taskDetailModal").style.display = "none"
  }

  window.closeEditTaskModal = () => {
    document.getElementById("editTaskModal").style.display = "none"
  }

  console.log("✅ Enhanced TaskScript.js initialized successfully.")
})

// Add notification styles dynamically
const notificationStyles = `
    .notification {
        position: fixed;
        top: 20px;
        right: 20px;
        background: white;
        border-radius: 0.75rem;
        padding: 1rem 1.5rem;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        z-index: 10000;
        transform: translateX(100%);
        opacity: 0;
        transition: all 0.3s ease;
        border-left: 4px solid #3b82f6;
        max-width: 300px;
    }

    .notification.show {
        transform: translateX(0);
        opacity: 1;
    }

    .notification-success {
        border-left-color: #10b981;
    }

    .notification-error {
        border-left-color: #ef4444;
    }

    .notification-content {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        font-size: 0.875rem;
        font-weight: 500;
    }

    .notification-success .notification-content i {
        color: #10b981;
    }

    .notification-error .notification-content i {
        color: #ef4444;
    }

    .notification-info .notification-content i {
        color: #3b82f6;
    }

    body.dark-mode .notification {
        background: #1e293b;
        color: #f8fafc;
        border-left-color: #3b82f6;
    }
`

// Inject notification styles
const styleSheet = document.createElement("style")
styleSheet.textContent = notificationStyles
document.head.appendChild(styleSheet)