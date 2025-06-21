// Professional Template Gallery Manager
class TemplateGalleryManager {
  constructor() {
    this.templates = []
    this.filteredTemplates = []
    this.currentCategory = "all"
    this.searchQuery = ""
    this.init()
  }

  init() {
    // Get DOM elements
    this.searchInput = document.getElementById("templateSearch")
    this.categoryItems = document.querySelectorAll(".category-item")
    this.templateCards = document.querySelectorAll(".featured-card, .business-card")
    this.createBoardModal = document.getElementById("createBoardModal")

    // Initialize templates data
    this.initializeTemplates()

    // Bind events
    this.bindEvents()

    // Initial render
    this.filterTemplates()
  }

  initializeTemplates() {
    // Extract template data from DOM
    this.templates = Array.from(this.templateCards).map((card) => ({
      id: card.dataset.templateId,
      category: card.dataset.category || this.getCategoryFromSection(card),
      title: card.querySelector(".card-title")?.textContent || "",
      description: card.querySelector(".card-description")?.textContent || "",
      element: card,
    }))

    this.filteredTemplates = [...this.templates]
  }

  getCategoryFromSection(card) {
    // Determine category based on card's parent section
    if (card.closest(".business-section")) return "business"
    if (card.closest(".featured-section")) return "featured"
    return "other"
  }

  bindEvents() {
    // Search functionality
    if (this.searchInput) {
      this.searchInput.addEventListener("input", (e) => {
        this.searchQuery = e.target.value.toLowerCase().trim()
        this.filterTemplates()
      })

      // Clear search on escape
      this.searchInput.addEventListener("keydown", (e) => {
        if (e.key === "Escape") {
          this.searchInput.value = ""
          this.searchQuery = ""
          this.filterTemplates()
        }
      })
    }

    // Category selection
    this.categoryItems.forEach((item) => {
      item.addEventListener("click", () => {
        this.setActiveCategory(item)
        this.currentCategory = item.dataset.category
        this.filterTemplates()
      })
    })

    // Modal events
    if (this.createBoardModal) {
      // Close modal on backdrop click
      this.createBoardModal.addEventListener("click", (e) => {
        if (e.target === this.createBoardModal) {
          this.closeModal()
        }
      })

      // Prevent modal content clicks from closing modal
      const modalContainer = this.createBoardModal.querySelector(".modal-container")
      if (modalContainer) {
        modalContainer.addEventListener("click", (e) => {
          e.stopPropagation()
        })
      }
    }

    // Keyboard shortcuts
    document.addEventListener("keydown", (e) => {
      // Close modal on escape
      if (e.key === "Escape") {
        this.closeModal()
      }

      // Focus search on '/' key
      if (e.key === "/" && e.target.tagName !== "INPUT" && e.target.tagName !== "TEXTAREA") {
        e.preventDefault()
        this.searchInput?.focus()
      }
    })

    // Template card hover effects
    this.templateCards.forEach((card) => {
      card.addEventListener("mouseenter", () => {
        this.addHoverEffect(card)
      })

      card.addEventListener("mouseleave", () => {
        this.removeHoverEffect(card)
      })
    })
  }

  setActiveCategory(activeItem) {
    // Remove active class from all categories
    this.categoryItems.forEach((item) => item.classList.remove("active"))

    // Add active class to selected category
    activeItem.classList.add("active")
  }

  filterTemplates() {
    this.filteredTemplates = this.templates.filter((template) => {
      const matchesCategory =
        this.currentCategory === "all" ||
        template.category === this.currentCategory ||
        (this.currentCategory === "featured" && template.element.closest(".featured-section"))

      const matchesSearch =
        this.searchQuery === "" ||
        template.title.toLowerCase().includes(this.searchQuery) ||
        template.description.toLowerCase().includes(this.searchQuery)

      return matchesCategory && matchesSearch
    })

    this.renderTemplates()
  }

  renderTemplates() {
    // Show/hide templates based on filter
    this.templates.forEach((template) => {
      const isVisible = this.filteredTemplates.includes(template)

      if (isVisible) {
        template.element.style.display = "block"
        template.element.classList.remove("hidden")
        // Add fade in animation
        template.element.style.animation = "fadeIn 0.3s ease-out"
      } else {
        template.element.style.display = "none"
        template.element.classList.add("hidden")
      }
    })

    // Show empty state if no results
    this.showEmptyState(this.filteredTemplates.length === 0)
  }

  showEmptyState(show) {
    let emptyState = document.querySelector(".empty-state")

    if (show && !emptyState) {
      emptyState = document.createElement("div")
      emptyState.className = "empty-state"
      emptyState.innerHTML = `
        <div style="text-align: center; padding: 3rem 1rem; color: #9ca3af;">
          <div style="font-size: 3rem; margin-bottom: 1rem;">
            <i class="fas fa-search"></i>
          </div>
          <h3 style="font-size: 1.25rem; font-weight: 600; color: #ffffff; margin-bottom: 0.5rem;">
            Không tìm thấy mẫu nào
          </h3>
          <p style="margin: 0;">
            Thử điều chỉnh từ khóa tìm kiếm hoặc chọn danh mục khác
          </p>
        </div>
      `

      // Insert after featured section
      const featuredSection = document.querySelector(".featured-section")
      if (featuredSection) {
        featuredSection.parentNode.insertBefore(emptyState, featuredSection.nextSibling)
      }
    } else if (!show && emptyState) {
      emptyState.remove()
    }
  }

  addHoverEffect(card) {
    // Add subtle glow effect
    card.style.boxShadow = "0 8px 25px rgba(87, 157, 255, 0.15)"
  }

  removeHoverEffect(card) {
    // Remove glow effect
    card.style.boxShadow = ""
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
    if (this.createBoardModal) {
      this.createBoardModal.style.display = "none"
      document.body.style.overflow = "auto"

      // Reset form
      const form = this.createBoardModal.querySelector("#createBoardForm")
      if (form) {
        form.reset()
      }
    }
  }
}

// Global functions for template actions
function previewTemplate(templateId) {
  // Add loading effect to the card
  const templateCard = document.querySelector(`[data-template-id="${templateId}"]`)
  if (templateCard) {
    templateCard.classList.add("loading")

    // Add loading spinner to overlay
    const overlay = templateCard.querySelector(".card-overlay")
    if (overlay) {
      overlay.innerHTML = `
        <div style="color: white; font-size: 1.5rem;">
          <i class="fas fa-spinner fa-spin"></i>
        </div>
      `
      overlay.style.opacity = "1"
    }
  }

  // Show notification
  if (window.templateGallery) {
    window.templateGallery.showNotification("Đang tải xem trước...", "info")
  }

  // Simulate loading and redirect
  setTimeout(() => {
    window.location.href = '/BeeTask/TemplateDetail.jsp?templateId=' + templateId;
  }, 800)
}

function useTemplate(templateId) {
  // Add loading effect to the card
  const templateCard = document.querySelector(`[data-template-id="${templateId}"]`)
  if (templateCard) {
    templateCard.classList.add("loading")

    // Add loading spinner to overlay
    const overlay = templateCard.querySelector(".card-overlay")
    if (overlay) {
      overlay.innerHTML = `
        <div style="color: white; font-size: 1.5rem;">
          <i class="fas fa-spinner fa-spin"></i>
        </div>
      `
      overlay.style.opacity = "1"
    }
  }

  // Show notification
  if (window.templateGallery) {
    window.templateGallery.showNotification("Đang tạo dự án từ mẫu...", "info")
  }

  // Simulate API call and redirect
  setTimeout(() => {
    window.location.href = `${window.location.origin}/CreateProject.jsp?templateId=${templateId}`
  }, 1200)
}

function createNewBoard() {
  const modal = document.getElementById("createBoardModal")
  if (modal) {
    modal.style.display = "block"
    document.body.style.overflow = "hidden"

    // Focus first input after modal animation
    const firstInput = modal.querySelector("#boardName")
    if (firstInput) {
      setTimeout(() => {
        firstInput.focus()
      }, 150)
    }
  }
}

function closeModal() {
  if (window.templateGallery) {
    window.templateGallery.closeModal()
  }
}

function submitCreateBoard() {
  const form = document.getElementById("createBoardForm")
  const formData = new FormData(form)

  const boardName = formData.get("boardName")?.trim()
  const boardDescription = formData.get("boardDescription")?.trim()
  const boardCategory = formData.get("boardCategory")

  // Validation
  if (!boardName) {
    if (window.templateGallery) {
      window.templateGallery.showNotification("Vui lòng nhập tên bảng", "error")
    }
    return
  }

  if (boardName.length < 3) {
    if (window.templateGallery) {
      window.templateGallery.showNotification("Tên bảng phải có ít nhất 3 ký tự", "error")
    }
    return
  }

  // Show loading state
  const submitBtn = document.querySelector(".btn.primary")
  const originalText = submitBtn.innerHTML
  submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tạo...'
  submitBtn.disabled = true

  // Show notification
  if (window.templateGallery) {
    window.templateGallery.showNotification("Đang tạo bảng mới...", "info")
  }

  // Simulate API call
  setTimeout(() => {
    // Reset button
    submitBtn.innerHTML = originalText
    submitBtn.disabled = false

    // Close modal
    closeModal()

    // Show success notification
    if (window.templateGallery) {
      window.templateGallery.showNotification("Tạo bảng thành công!", "success")
    }

    // Redirect to new board
    setTimeout(() => {
      const encodedName = encodeURIComponent(boardName)
      const encodedCategory = encodeURIComponent(boardCategory)
      window.location.href = `${window.location.origin}/Board.jsp?boardId=new&name=${encodedName}&category=${encodedCategory}`
    }, 1000)
  }, 1800)
}

// Initialize when DOM is loaded
document.addEventListener("DOMContentLoaded", () => {
  window.templateGallery = new TemplateGalleryManager()

  // Add some polish effects
  setTimeout(() => {
    // Add stagger animation to category items
    const categoryItems = document.querySelectorAll(".category-item")
    categoryItems.forEach((item, index) => {
      item.style.animationDelay = `${index * 0.1}s`
      item.classList.add("animate-fade-in")
    })

    // Add stagger animation to template cards
    const templateCards = document.querySelectorAll(".featured-card, .business-card")
    templateCards.forEach((card, index) => {
      card.style.animationDelay = `${index * 0.15}s`
      card.classList.add("animate-fade-in")
    })
  }, 100)
})

// Add some utility functions
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

// Performance optimization for search
const debouncedSearch = debounce((query) => {
  if (window.templateGallery) {
    window.templateGallery.searchQuery = query
    window.templateGallery.filterTemplates()
  }
}, 300)

// Enhanced search input handling
document.addEventListener("DOMContentLoaded", () => {
  const searchInput = document.getElementById("templateSearch")
  if (searchInput) {
    searchInput.addEventListener("input", (e) => {
      debouncedSearch(e.target.value.toLowerCase().trim())
    })
  }
})

// Add CSS for loading spinner and animations
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
    from { opacity: 0; }
    to { opacity: 1; }
  }

  .loading {
    opacity: 0.6;
    pointer-events: none;
  }
`
document.head.appendChild(style)
