class BeeTaskManager {
    constructor() {
        this.currentTheme = localStorage.getItem("theme") || "light";
        this.draggedTask = null;
        this.init();
    }

    init() {
        this.applyTheme(this.currentTheme);
        this.searchInput = document.getElementById("searchInput");
        this.themeToggle = document.getElementById("themeToggle");

        this.bindEvents();
        this.updateStats();
        this.initDragAndDrop();
    }

    bindEvents() {
        if (this.themeToggle) {
            this.themeToggle.addEventListener("click", () => this.toggleTheme());
        }

        if (this.searchInput) {
            this.searchInput.addEventListener("input", (e) => this.handleSearch(e.target.value));
        }

        document.querySelectorAll(".filter-btn").forEach((btn) => {
            btn.addEventListener("click", (e) => this.handleFilter(e.target));
        });

        // AJAX submit for board forms
        document.querySelectorAll('form[action="tasklist"]').forEach((form) => {
            form.addEventListener("submit", (e) => this.handleTaskListFormSubmit(e, form));
        });
    }

    toggleTheme() {
        this.currentTheme = this.currentTheme === "light" ? "dark" : "light";
        this.applyTheme(this.currentTheme);
        localStorage.setItem("theme", this.currentTheme);
    }

    applyTheme(theme) {
        document.body.classList.remove("theme-light", "theme-dark", "dark-mode");
        document.body.classList.add(`theme-${theme}`);
        if (theme === "dark") document.body.classList.add("dark-mode");
    }

    handleSearch(query) {
        const searchTerm = query.toLowerCase().trim();

        document.querySelectorAll(".task-card").forEach((card) => {
            const title = card.querySelector(".task-title")?.textContent.toLowerCase() || "";
            const description = card.querySelector(".task-description")?.textContent.toLowerCase() || "";
            const isMatch = searchTerm === "" || title.includes(searchTerm) || description.includes(searchTerm);
            card.style.display = isMatch ? "block" : "none";
        });

        this.updateBoardCounters();
    }

    handleFilter(button) {
        document.querySelectorAll(".filter-btn").forEach((btn) => {
            btn.classList.remove("active");
        });
        button.classList.add("active");

        const filter = button.dataset.filter;
        document.querySelectorAll(".task-card").forEach((card) => {
            const status = card.dataset.status || "todo";
            const shouldShow = filter === "all" || status === filter;
            card.style.display = shouldShow ? "block" : "none";
        });
    }

    updateStats() {
        const totalTasks = document.querySelectorAll(".task-card").length;
        const totalTasksEl = document.getElementById("totalTasks");
        if (totalTasksEl) totalTasksEl.textContent = totalTasks;

        this.updateBoardCounters();
    }

    updateBoardCounters() {
        document.querySelectorAll(".task-column").forEach((column) => {
            const visibleTasks = column.querySelectorAll('.task-card:not([style*="display: none"])');
            const counter = column.querySelector(".task-count");
            if (counter) {
                counter.textContent = visibleTasks.length;
            }
        });
    }

    async handleTaskListFormSubmit(e, form) {
        e.preventDefault();
        const formData = new FormData(form);
        const action = formData.get("action");

        if (action === "delete" && !confirm("Are you sure you want to delete this list?")) return;

        try {
            const response = await fetch(form.action, {
                method: "POST",
                body: formData,
            });

            if (response.ok) {
                alert(`${action.charAt(0).toUpperCase() + action.slice(1)} successful`);
                setTimeout(() => window.location.reload(), 500);
            } else {
                throw new Error("Server error");
            }
        } catch (err) {
            console.error(err);
            alert("Something went wrong.");
        }
    }

    initDragAndDrop() {
        document.querySelectorAll(".task-card").forEach((task) => {
            task.setAttribute("draggable", true);

            task.addEventListener("dragstart", (e) => {
                this.draggedTask = task;
                task.classList.add("dragging");
            });

            task.addEventListener("dragend", (e) => {
                task.classList.remove("dragging");
                this.draggedTask = null;
            });
        });

        document.querySelectorAll(".task-column").forEach((column) => {
            column.addEventListener("dragover", (e) => {
                e.preventDefault();
                const afterElement = this.getDragAfterElement(column, e.clientY);
                const container = column.querySelector(".task-list-body") || column;
                if (afterElement == null) {
                    container.appendChild(this.draggedTask);
                } else {
                    container.insertBefore(this.draggedTask, afterElement);
                }
            });

            column.addEventListener("drop", async (e) => {
                const boardId = column.dataset.boardId;
                const taskId = this.draggedTask.dataset.taskId;
                const newPosition = [...column.querySelectorAll(".task-card")].indexOf(this.draggedTask);

                try {
                    await fetch("task", {
                        method: "POST",
                        headers: { "Content-Type": "application/x-www-form-urlencoded" },
                        body: `action=move&taskId=${taskId}&boardId=${boardId}&position=${newPosition}`,
                    });
                } catch (error) {
                    console.error("Move failed", error);
                }
            });
        });
    }

    getDragAfterElement(container, y) {
        const draggableElements = [...container.querySelectorAll(".task-card:not(.dragging)")];

        return draggableElements.reduce((closest, child) => {
            const box = child.getBoundingClientRect();
            const offset = y - box.top - box.height / 2;
            if (offset < 0 && offset > closest.offset) {
                return { offset: offset, element: child };
            } else {
                return closest;
            }
        }, { offset: Number.NEGATIVE_INFINITY }).element;
    }
}

document.addEventListener("DOMContentLoaded", () => {
    new BeeTaskManager();
});