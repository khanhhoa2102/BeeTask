class TemplateDetailManager {
    constructor() {
        this.currentTheme = localStorage.getItem("theme") || "light"
        this.init()
    }

    init() {
        this.applyTheme(this.currentTheme)
        this.searchInput = document.getElementById("searchInput")
        this.themeToggle = document.getElementById("themeToggle")
        this.bindEvents()
        this.updateStats()
    }

    bindEvents() {
        // Theme toggle
        if (this.themeToggle) {
            this.themeToggle.addEventListener("click", () => this.toggleTheme())
        }

        // Search
        if (this.searchInput) {
            this.searchInput.addEventListener("input", (e) => this.handleSearch(e.target.value))
        }

        // Filter buttons
        document.querySelectorAll(".filter-btn").forEach((btn) => {
            btn.addEventListener("click", (e) => this.handleFilter(e.target))
        })

        // AJAX form for board (tasklist)
        document.querySelectorAll('form[action="tasklist"]').forEach(form => {
            form.addEventListener("submit", (e) => this.handleTaskListFormSubmit(e, form))
        })
    }

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

    handleSearch(query) {
        const searchTerm = query.toLowerCase().trim()
        document.querySelectorAll(".task-card").forEach((card) => {
            const title = card.querySelector(".task-title")?.textContent.toLowerCase() || ""
            const description = card.querySelector(".task-description")?.textContent.toLowerCase() || ""
            const isMatch = searchTerm === "" || title.includes(searchTerm) || description.includes(searchTerm)
            card.style.display = isMatch ? "block" : "none"
        })

        document.querySelectorAll(".table-row").forEach((row) => {
            const title = row.querySelector(".task-details h4")?.textContent.toLowerCase() || ""
            const description = row.querySelector(".task-details p")?.textContent.toLowerCase() || ""
            const isMatch = searchTerm === "" || title.includes(searchTerm) || description.includes(searchTerm)
            row.style.display = isMatch ? "grid" : "none"
        })

        this.updateBoardCounters()
    }

    handleFilter(button) {
        document.querySelectorAll(".filter-btn").forEach((btn) => btn.classList.remove("active"))
        button.classList.add("active")

        const filter = button.dataset.filter
        document.querySelectorAll(".table-row").forEach((row) => {
            const status = row.dataset.status || "todo"
            row.style.display = (filter === "all" || status === filter) ? "grid" : "none"
        })
    }

    updateStats() {
        const totalTasks = document.querySelectorAll(".task-card").length
        const pendingTasks = totalTasks // Simplified

        const totalTasksEl = document.getElementById("totalTasks")
        const pendingTasksEl = document.getElementById("pendingTasks")

        if (totalTasksEl) totalTasksEl.textContent = totalTasks
        if (pendingTasksEl) pendingTasksEl.textContent = pendingTasks
    }

    updateBoardCounters() {
        document.querySelectorAll(".board-card").forEach((board) => {
            const visibleTasks = board.querySelectorAll('.task-card:not([style*="display: none"])')
            const counter = board.querySelector(".task-count")
            if (counter) {
                counter.textContent = visibleTasks.length
            }
        })
    }

    async handleTaskListFormSubmit(e, form) {
        e.preventDefault()
        const formData = new FormData(form)
        const action = formData.get("action")

        if (action === "delete" && !confirm("Are you sure you want to delete this list?")) {
            return
        }

        try {
            const response = await fetch("tasklist", {
                method: "POST",
                body: formData
            })

            if (response.ok) {
                alert(`${action.charAt(0).toUpperCase() + action.slice(1)} successful`)
                setTimeout(() => window.location.reload(), 500)
            } else {
                throw new Error("Server error");
            }
        } catch (err) {
            console.error(err)
            alert("Something went wrong.");
        }
    }
}

// Run after DOM loaded
document.addEventListener("DOMContentLoaded", () => {
    new TemplateDetailManager()
}