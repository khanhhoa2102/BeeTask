// Professional Project Management System
class ProjectManager {
  constructor() {
    this.projects = []
    this.filteredProjects = []
    this.currentView = "grid"
    this.searchQuery = ""
    this.init()
  }

  init() {
    // Get DOM elements
    this.searchInput = document.getElementById("projectSearch")
    this.projectsContainer = document.getElementById("projectsContainer")
    this.projectModal = document.getElementById("projectModal")
    this.deleteModal = document.getElementById("deleteModal")
    this.projectForm = document.getElementById("projectForm")
    this.deleteForm = document.getElementById("deleteForm")
    this.viewButtons = document.querySelectorAll(".view-btn")

    // Initialize projects data
    this.initializeProjects()

    // Bind events
    this.bindEvents()

    // Bind project navigation
    this.bindProjectNavigation()

    // Initial render
    this.filterProjects()
  }

  initializeProjects() {
    // Extract project data from DOM
    const projectCards = document.querySelectorAll(".project-card")
    this.projects = Array.from(projectCards).map((card) => ({
      id: card.dataset.projectId,
      name: card.dataset.projectName,
      element: card,
    }))
    this.filteredProjects = [...this.projects]
  }

  bindProjectNavigation() {
    // Handle project card clicks for navigation - Simple and direct approach
    document.addEventListener("click", (e) => {
      const projectCard = e.target.closest(".project-card")

      if (projectCard) {
        // Don't navigate if clicking on action buttons or their children
        if (
          e.target.closest(".action-btn") ||
          e.target.closest(".card-actions") ||
          e.target.classList.contains("action-btn")
        ) {
          console.log("Clicked on action button, not navigating")
          return
        }

        const projectId = projectCard.dataset.projectId
        console.log("Project card clicked, projectId:", projectId)

        if (projectId) {
          // Add loading state
          projectCard.classList.add("loading")

          // Show notification
          this.showNotification("Openning...", "info")

          // Navigate immediately (remove the setTimeout delay)
          console.log("Navigating to Task.jsp?projectId=" + projectId)
          window.location.href = `Task.jsp?projectId=${projectId}`
        }
      }
    })
  }

  bindEvents() {
    // Search functionality
    if (this.searchInput) {
      this.searchInput.addEventListener("input", (e) => {
        this.searchQuery = e.target.value.toLowerCase().trim()
        this.filterProjects()
      })

      // Clear search on escape
      this.searchInput.addEventListener("keydown", (e) => {
        if (e.key === "Escape") {
          this.searchInput.value = ""
          this.searchQuery = ""
          this.filterProjects()
        }
      })
    }

    // View toggle
    this.viewButtons.forEach((btn) => {
      btn.addEventListener("click", () => {
        this.setActiveView(btn)
        this.currentView = btn.dataset.view
        this.updateView()
      })
    })

    // Modal events
    if (this.projectModal) {
      this.projectModal.addEventListener("click", (e) => {
        if (e.target === this.projectModal) {
          this.closeModal()
        }
      })
    }

    if (this.deleteModal) {
      this.deleteModal.addEventListener("click", (e) => {
        if (e.target === this.deleteModal) {
          this.closeDeleteModal()
        }
      })
    }

    // Form submission
    if (this.projectForm) {
      this.projectForm.addEventListener("submit", (e) => {
        this.handleFormSubmit(e)
      })
    }

    // Keyboard shortcuts
    document.addEventListener("keydown", (e) => {
      // Close modals on escape
      if (e.key === "Escape") {
        this.closeModal()
        this.closeDeleteModal()
      }
      // Focus search on '/' key
      if (e.key === "/" && e.target.tagName !== "INPUT" && e.target.tagName !== "TEXTAREA") {
        e.preventDefault()
        this.searchInput?.focus()
      }
    })
  }

  setActiveView(activeBtn) {
    this.viewButtons.forEach((btn) => btn.classList.remove("active"))
    activeBtn.classList.add("active")
  }

  updateView() {
    if (this.projectsContainer) {
      this.projectsContainer.classList.toggle("list-view", this.currentView === "list")
    }
  }

  filterProjects() {
    this.filteredProjects = this.projects.filter((project) => {
      const matchesSearch = this.searchQuery === "" || project.name.includes(this.searchQuery)
      return matchesSearch
    })

    this.renderProjects()
  }

  renderProjects() {
    // Show/hide projects based on filter
    this.projects.forEach((project) => {
      const isVisible = this.filteredProjects.includes(project)
      if (isVisible) {
        project.element.style.display = "block"
        project.element.classList.remove("hidden")
        project.element.style.animation = "fadeIn 0.3s ease-out"
      } else {
        project.element.style.display = "none"
        project.element.classList.add("hidden")
      }
    })

    // Show empty state if no results
    this.showEmptyState(this.filteredProjects.length === 0 && this.searchQuery !== "")
  }

  showEmptyState(show) {
    let emptyState = document.querySelector(".search-empty-state")
    if (show && !emptyState) {
      emptyState = document.createElement("div")
      emptyState.className = "search-empty-state"
      emptyState.style.cssText = `
        grid-column: 1 / -1;
        text-align: center;
        padding: 3rem 1rem;
        color: #9ca3af;
      `
      emptyState.innerHTML = `
        <div style="font-size: 3rem; margin-bottom: 1rem;">
          <i class="fas fa-search"></i>
        </div>
        <h3 style="font-size: 1.25rem; font-weight: 600; color: #ffffff; margin-bottom: 0.5rem;">
          No project found
        </h3>
        <p style="margin: 0;">
          Try adjusting search key
        </p>
      `
      this.projectsContainer.appendChild(emptyState)
    } else if (!show && emptyState) {
      emptyState.remove()
    }
  }

  handleFormSubmit(e) {
    const submitBtn = document.getElementById("submitBtn")
    const originalText = submitBtn.innerHTML

    // Show loading state
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang lưu...'
    submitBtn.disabled = true

    // Let the form submit naturally, but show loading state
    setTimeout(() => {
      submitBtn.innerHTML = originalText
      submitBtn.disabled = false
    }, 2000)
  }

  showNotification(message, type = "success") {
    const notification = document.createElement("div")
    notification.className = `notification ${type}`
    const bgColor = type === "success" ? "#10b981" : type === "error" ? "#ef4444" : "#3b82f6"
    const icon = type === "success" ? "fa-check-circle" : type === "error" ? "fa-exclamation-circle" : "fa-info-circle"

    notification.innerHTML = `
      <div style="display: flex; align-items: center; gap: 0.5rem;">
        <i class="fas ${icon}"></i>
        <span>${message}</span>
      </div>
    `

    notification.style.cssText = `
      position: fixed;
      top: 20px;
      right: 20px;
      padding: 1rem 1.5rem;
      background: ${bgColor};
      color: white;
      border-radius: 0.75rem;
      box-shadow: 0 4px 12px rgba(0,0,0,0.3);
      z-index: 1001;
      transform: translateX(100%);
      transition: transform 0.3s ease;
      max-width: 300px;
      font-size: 0.875rem;
      font-weight: 500;
    `

    document.body.appendChild(notification)

    // Animate in
    setTimeout(() => {
      notification.style.transform = "translateX(0)"
    }, 10)

    // Remove after 4 seconds
    setTimeout(() => {
      notification.style.transform = "translateX(100%)"
      setTimeout(() => {
        if (document.body.contains(notification)) {
          document.body.removeChild(notification)
        }
      }, 300)
    }, 4000)
  }

  closeModal() {
    if (this.projectModal) {
      this.projectModal.style.display = "none"
      document.body.style.overflow = "auto"
      // Reset form
      if (this.projectForm) {
        this.projectForm.reset()
        document.getElementById("formAction").value = "create"
        document.getElementById("projectId").value = ""
        document.getElementById("modalTitle").innerHTML = '<i class="fas fa-plus-circle"></i> Tạo dự án mới'
        document.getElementById("submitBtn").innerHTML = '<i class="fas fa-save"></i> Lưu dự án'
      }
    }
  }

  closeDeleteModal() {
    if (this.deleteModal) {
      this.deleteModal.style.display = "none"
      document.body.style.overflow = "auto"
    }
  }
}

// Global functions for project actions
function openCreateModal() {
  const modal = document.getElementById("projectModal")
  if (modal) {
    modal.style.display = "block"
    document.body.style.overflow = "hidden"

    // Reset form for create
    document.getElementById("formAction").value = "create"
    document.getElementById("projectId").value = ""
    document.getElementById("modalTitle").innerHTML = '<i class="fas fa-plus-circle"></i> Create new project'
    document.getElementById("submitBtn").innerHTML = '<i class="fas fa-save"></i> Save'

    // Focus first input
    const firstInput = modal.querySelector("#projectName")
    if (firstInput) {
      setTimeout(() => {
        firstInput.focus()
      }, 150)
    }
  }
}

function editProject(projectId) {
  const modal = document.getElementById("projectModal")
  if (modal) {
    // Find project card to get current values
    const projectCard = document.querySelector(`[data-project-id="${projectId}"]`)
    if (projectCard) {
      const title = projectCard.querySelector(".project-title").textContent
      const description = projectCard.querySelector(".project-description").textContent

      // Set form values
      document.getElementById("formAction").value = "update"
      document.getElementById("projectId").value = projectId
      document.getElementById("projectName").value = title
      document.getElementById("projectDescription").value = description === "Không có mô tả" ? "" : description

      // Update modal title
      document.getElementById("modalTitle").innerHTML = '<i class="fas fa-edit"></i> Chỉnh sửa dự án'
      document.getElementById("submitBtn").innerHTML = '<i class="fas fa-save"></i> Cập nhật dự án'

      modal.style.display = "block"
      document.body.style.overflow = "hidden"

      // Focus first input
      const firstInput = modal.querySelector("#projectName")
      if (firstInput) {
        setTimeout(() => {
          firstInput.focus()
          firstInput.select()
        }, 150)
      }
    }
  }
}

function confirmDelete(projectId, projectName) {
  const modal = document.getElementById("deleteModal")
  if (modal) {
    document.getElementById("deleteProjectId").value = projectId
    document.getElementById("deleteProjectName").textContent = projectName

    modal.style.display = "block"
    document.body.style.overflow = "hidden"
  }
}

function closeModal() {
  if (window.projectManager) {
    window.projectManager.closeModal()
  }
}

function closeDeleteModal() {
  if (window.projectManager) {
    window.projectManager.closeDeleteModal()
  }
}

// Initialize when DOM is loaded
document.addEventListener("DOMContentLoaded", () => {
  console.log("DOM loaded, initializing project manager...")
  window.projectManager = new ProjectManager()

  // Initialize dark mode
  const savedTheme = localStorage.getItem("theme") || "light-mode"
  const darkModeToggle = document.getElementById("darkModeToggle")

  if (savedTheme === "dark-mode") {
    document.body.classList.add("dark-mode")
    if (darkModeToggle) darkModeToggle.checked = true
  } else {
    document.body.classList.remove("dark-mode")
    if (darkModeToggle) darkModeToggle.checked = false
  }

  // Toggle dark mode
  if (darkModeToggle) {
    darkModeToggle.addEventListener("change", () => {
      const isDark = darkModeToggle.checked
      document.body.classList.toggle("dark-mode", isDark)
      localStorage.setItem("theme", isDark ? "dark-mode" : "light-mode")
    })
  }

  // Initialize sidebar toggle
  initializeSidebarToggle()

  console.log("✅ Project management system initialized")
})

function initializeSidebarToggle() {
  const sidebar = document.querySelector('.sidebar');
  const toggleButtons = document.querySelectorAll('.toggle-btn, .sidebar-toggle');

  if (!sidebar) return;

  const savedState = localStorage.getItem('sidebarState') || 'expanded';
  sidebar.classList.toggle('collapsed', savedState === 'collapsed');

  toggleButtons.forEach(btn => {
    btn.addEventListener('click', () => {
      sidebar.classList.toggle('collapsed');
      const isCollapsed = sidebar.classList.contains('collapsed');
      localStorage.setItem('sidebarState', isCollapsed ? 'collapsed' : 'expanded');
    });
  });
}

// Utility functions
function debounce(func, wait) {
  let timeout
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout)
      func(...args)
    }
    clearTimeout(timeout)
    timeout = setTimeout(later, wait)
  }
}

// Enhanced search with debouncing
const debouncedSearch = debounce((query) => {
  if (window.projectManager) {
    window.projectManager.searchQuery = query
    window.projectManager.filterProjects()
  }
}, 300)

// Add loading spinner styles
const style = document.createElement("style")
style.textContent = `
  .loading-spinner {
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.5rem;
    color: #ffffff;
  }
  
  .loading-spinner i {
    animation: spin 1s linear infinite;
  }
    
  @keyframes spin {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
  }
  
  .animate-fade-in {
    animation: fadeIn 0.3s ease-out;
  }
  
  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
  }
`
document.head.appendChild(style)