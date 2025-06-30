// TaskScript.js - Full Version for BeeTask

class TaskManager {
    constructor() {
        this.currentTheme = localStorage.getItem("theme") || "light-mode"
        this.init()
    }

    init() {
        this.applyTheme(this.currentTheme)

        // Elements
        this.searchInput = document.getElementById("searchInput")
        this.themeToggle = document.getElementById("darkModeToggle")

        this.bindEvents()
        this.updateStats()
        this.updateBoardCounters()
    }

    bindEvents() {
        // Dark mode toggle
        if (this.themeToggle) {
            this.themeToggle.checked = this.currentTheme === "dark-mode"
            this.themeToggle.addEventListener("change", () => {
                const isDark = this.themeToggle.checked
                const newTheme = isDark ? "dark-mode" : "light-mode"
                this.applyTheme(newTheme)
                localStorage.setItem("theme", newTheme)
            })
        }

        // Search
        if (this.searchInput) {
            this.searchInput.addEventListener("input", (e) => this.handleSearch(e.target.value))
        }

        // Filter
        document.querySelectorAll(".filter-btn").forEach(btn => {
            btn.addEventListener("click", (e) => this.handleFilter(e.target))
        })
    }

    applyTheme(theme) {
        document.body.classList.toggle("dark-mode", theme === "dark-mode")
    }

    handleSearch(query) {
        const searchTerm = query.toLowerCase().trim()

        // Task cards
        document.querySelectorAll(".task-card").forEach(card => {
            const title = card.querySelector("h4")?.textContent.toLowerCase() || ""
            const desc = card.querySelector("p")?.textContent.toLowerCase() || ""
            const match = !searchTerm || title.includes(searchTerm) || desc.includes(searchTerm)
            card.style.display = match ? "block" : "none"
        })

        // Table rows
        document.querySelectorAll(".table-row").forEach(row => {
            const title = row.querySelector("div:first-child")?.textContent.toLowerCase() || ""
            const match = !searchTerm || title.includes(searchTerm)
            row.style.display = match ? "grid" : "none"
        })

        this.updateBoardCounters()
    }

    handleFilter(btn) {
        // UI highlight
        document.querySelectorAll(".filter-btn").forEach(b => b.classList.remove("active"))
        btn.classList.add("active")

        const filter = btn.dataset.filter
        document.querySelectorAll(".table-row").forEach(row => {
            const status = (row.dataset.status || "").toLowerCase()
            row.style.display = filter === "all" || status === filter ? "grid" : "none"
        })
    }

    updateStats() {
        const totalTasks = document.querySelectorAll(".task-card").length
        const pendingTasks = document.querySelectorAll('.task-card[data-status="To Do"], .task-card[data-status="In Progress"]').length

        const totalEl = document.getElementById("totalTasks")
        const pendingEl = document.getElementById("pendingTasks")

        if (totalEl) totalEl.textContent = totalTasks
        if (pendingEl) pendingEl.textContent = pendingTasks
    }

    updateBoardCounters() {
        document.querySelectorAll(".board-card").forEach(board => {
            const visibleTasks = board.querySelectorAll('.task-card:not([style*="display: none"])').length
            const counter = board.querySelector(".task-count")
            if (counter) {
                counter.textContent = visibleTasks
            }
        })
    }
}

// Initialize after DOM load
document.addEventListener("DOMContentLoaded", () => {
    new TaskManager()
    console.log("✅ TaskScript.js initialized.")
}

import Sortable from 'https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js';

document.addEventListener('DOMContentLoaded', function () {
  // Drag tasks between boards
  document.querySelectorAll('.board-tasks').forEach(board => {
    Sortable.create(board, {
      group: 'shared',
      animation: 150,
      onEnd: function (evt) {
        const taskId = evt.item.getAttribute('data-task-id');
        const newBoardId = evt.to.closest('.board-card').getAttribute('data-board-id');
        const newIndex = evt.newIndex;

        fetch('task?action=move', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: `taskId=${taskId}&newBoardId=${newBoardId}&newIndex=${newIndex}`
        }).catch(err => alert('Error moving task: ' + err));
      }
    });
  });

  // Drag boards
  Sortable.create(document.getElementById('boardsContainer'), {
    animation: 200,
    onEnd: function (evt) {
      const boardCards = document.querySelectorAll('.boards-container .board-card');
      const updates = [];

      boardCards.forEach((card, index) => {
        const boardId = card.getAttribute('data-board-id');
        updates.push(`boardIds[]=${boardId}&positions[]=${index}`);
      });

      fetch('board?action=moveBoardPosition', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: updates.join('&')
      }).catch(err => alert('Error moving board: ' + err));
    }
  });

  // Toggle board options menu
  window.toggleBoardMenu = function (button) {
    const menu = button.nextElementSibling;
    menu.style.display = menu.style.display === 'block' ? 'none' : 'block';
  };

  // Close dropdown menus when clicking outside
  document.addEventListener('click', function (event) {
    if (!event.target.closest('.board-options')) {
      document.querySelectorAll('.board-dropdown-menu').forEach(menu => {
        menu.style.display = 'none';
      });
    }
  });
});

)

