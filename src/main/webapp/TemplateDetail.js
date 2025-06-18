// Simple Template Detail Manager - Basic functionality only
class TemplateDetailManager {
    constructor() {
        this.currentTheme = localStorage.getItem("theme") || "light"
        this.init()
    }

    init() {
        // Apply saved theme
        this.applyTheme(this.currentTheme)

        // Get elements
        this.searchInput = document.getElementById("searchInput")
        this.themeToggle = document.getElementById("themeToggle")

        // Bind events
        this.bindEvents()

        // Update stats
        this.updateStats()
    }

    bindEvents() {
        // Theme toggle
        if (this.themeToggle) {
            this.themeToggle.addEventListener("click", () => this.toggleTheme())
        }

        // Search functionality
        if (this.searchInput) {
            this.searchInput.addEventListener("input", (e) => this.handleSearch(e.target.value))
        }

        // Filter buttons
        document.querySelectorAll(".filter-btn").forEach((btn) => {
            btn.addEventListener("click", (e) => this.handleFilter(e.target))
        })
    }

    // Theme Management
    toggleTheme() {
        this.currentTheme = this.currentTheme === "light" ? "dark" : "light"
        this.applyTheme(this.currentTheme)
        localStorage.setItem("theme", this.currentTheme)
    }

    applyTheme(theme) {
        document.body.classList.remove("theme-light", "theme-dark")
        document.body.classList.add(`theme-${theme}`)
        if (theme === "dark") {
            document.body.classList.add("dark-mode")
        } else {
            document.body.classList.remove("dark-mode")
        }
    }

    // Search Functionality
    handleSearch(query) {
        const searchTerm = query.toLowerCase().trim()

        // Search in task cards
        document.querySelectorAll(".task-card").forEach((card) => {
            const title = card.querySelector(".task-title")?.textContent.toLowerCase() || ""
            const description = card.querySelector(".task-description")?.textContent.toLowerCase() || ""
            const isMatch = searchTerm === "" || title.includes(searchTerm) || description.includes(searchTerm)

            card.style.display = isMatch ? "block" : "none"
        })

        // Search in overview rows
        document.querySelectorAll(".table-row").forEach((row) => {
            const title = row.querySelector(".task-details h4")?.textContent.toLowerCase() || ""
            const description = row.querySelector(".task-details p")?.textContent.toLowerCase() || ""
            const isMatch = searchTerm === "" || title.includes(searchTerm) || description.includes(searchTerm)

            row.style.display = isMatch ? "grid" : "none"
        })

        // Update board counters
        this.updateBoardCounters()
    }

    // Filter Functionality
    handleFilter(button) {
        // Update active state
        document.querySelectorAll(".filter-btn").forEach((btn) => {
            btn.classList.remove("active")
        })
        button.classList.add("active")

        // Apply filter (basic implementation)
        const filter = button.dataset.filter
        document.querySelectorAll(".table-row").forEach((row) => {
            const status = row.dataset.status || "todo"
            const shouldShow = filter === "all" || status === filter
            row.style.display = shouldShow ? "grid" : "none"
        })
    }

    // Update Stats
    updateStats() {
        const totalTasks = document.querySelectorAll(".task-card").length
        const pendingTasks = document.querySelectorAll(".task-card").length // Simplified

        const totalTasksEl = document.getElementById("totalTasks")
        const pendingTasksEl = document.getElementById("pendingTasks")

        if (totalTasksEl)
            totalTasksEl.textContent = totalTasks
        if (pendingTasksEl)
            pendingTasksEl.textContent = pendingTasks
    }

    // Update Board Counters
    updateBoardCounters() {
        document.querySelectorAll(".board-card").forEach((board) => {
            const visibleTasks = board.querySelectorAll('.task-card:not([style*="display: none"])')
            const counter = board.querySelector(".task-count")
            if (counter) {
                counter.textContent = visibleTasks.length
            }
        })
    }
}

// Initialize when DOM is loaded
document.addEventListener("DOMContentLoaded", () => {
    new TemplateDetailManager()
})
