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
            // Dark mode toggle (from Header.js, but ensure TaskScript also reacts)
            const themeToggle = document.getElementById("darkModeToggle")
            if (themeToggle) {
                // Initial sync
                this.applyTheme(localStorage.getItem("theme") || "light-mode")
                themeToggle.addEventListener("change", () => {
                    const newTheme = themeToggle.checked ? "dark-mode" : "light-mode"
                    this.applyTheme(newTheme)
                    // localStorage.setItem("theme", newTheme); // Header.js already handles this
                })
            }
            // Listen for storage changes (if dark mode is changed in another tab/window)
            window.addEventListener("storage", (e) => {
                if (e.key === "theme") {
                    this.applyTheme(e.newValue || "light-mode")
                }
            })
            // Search functionality
            const boardSearch = document.getElementById("boardSearch")
            if (boardSearch) {
                boardSearch.addEventListener("input", (e) => this.handleBoardSearch(e.target.value))
            }
            const searchInput = document.getElementById("searchInput") // Assuming this exists elsewhere
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
            // AI Suggestion Buttons in table
            document.querySelectorAll(".ai-suggest-btn").forEach((button) => {
                button.addEventListener("click", (e) => {
                    e.stopPropagation() // Prevent task detail popup from opening
                    const taskId = button.dataset.taskId
                    const taskTitle = button.dataset.taskTitle
                    const taskDesc = button.dataset.taskDesc
                    const taskDue = button.dataset.taskDue
                    const taskPriority = button.dataset.taskPriority
                    window.openAISuggestionModal(taskId, taskTitle, taskDesc, taskDue, taskPriority)
                })
            })
            // Apply AI Suggestion Button in modal
            const applyAISuggestionBtn = document.getElementById("applyAISuggestionBtn")
            if (applyAISuggestionBtn) {
                applyAISuggestionBtn.addEventListener("click", (e) => {
                    const taskId = e.target.dataset.taskId
                    const start = e.target.dataset.start
                    const end = e.target.dataset.end
                    const priority = e.target.dataset.priority
                    const difficulty = e.target.dataset.difficulty
                    const confidence = e.target.dataset.confidence
                    const shortdesc = e.target.dataset.shortdesc
                    this.applyAISuggestion(taskId, start, end, priority, difficulty, confidence, shortdesc)
                })
            }
            const addTaskForm = document.getElementById("addTaskForm")
            if (addTaskForm) {
                addTaskForm.addEventListener("submit", (e) => {
                    e.preventDefault() // 🚫 Ngăn reload
                    this.handleAddTask()
                })
            }
            const editTaskForm = document.getElementById("editTaskForm")
            if (editTaskForm) {
                editTaskForm.addEventListener("submit", (e) => {
                    e.preventDefault()
                    this.handleEditTask()
                })
            }
            const addBoardForm = document.querySelector("#addBoardModal form")
            if (addBoardForm) {
                addBoardForm.addEventListener("submit", (e) => {
                    e.preventDefault()
                    this.handleAddBoard(addBoardForm)
                })
            }
            document.getElementById("rejectAISuggestionBtn")?.addEventListener("click", () => {
                const taskId = document.getElementById("rejectAISuggestionBtn").dataset.taskId;
                if (!taskId || !confirm("Are you sure you want to reject this AI suggestion?"))
                    return;

                fetch(`${window.contextPath}/ai-suggest-apply?action=reject`, {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: `taskId=${taskId}`
                })
                        .then(res => res.json())
                        .then(result => {
                            window.closeAISuggestionModal();
                            taskManager.showNotification("❌ AI suggestion rejected", "info");

                            const col = document.querySelector(`.table-row[data-task-id="${taskId}"] .ai-suggestion-col`);
                            if (col)
                                col.innerHTML = `<span class="ai-no-suggestion text-muted">Rejected</span>`;
                        })
                        .catch(err => {
                            console.error("Failed to reject AI suggestion", err);
                            taskManager.showNotification("❌ Failed to reject AI suggestion", "error");
                        });
            });
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
            if (totalEl)
                totalEl.textContent = totalTasks
            if (pendingEl)
                pendingEl.textContent = pendingTasks
            if (completedEl)
                completedEl.textContent = completedTasks
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
                            headers: {"Content-Type": "application/x-www-form-urlencoded"},
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
                            headers: {"Content-Type": "application/x-www-form-urlencoded"},
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
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: `boardId=${boardId}&name=${encodeURIComponent(newName.trim())}`,
                })
                        .then((response) => {
                            if (response.ok) {
                                // ✅ Cập nhật tên trong DOM
                                const titleEl = document.querySelector(`.board-card[data-board-id="${boardId}"] .board-title`)
                                if (titleEl)
                                    titleEl.textContent = newName.trim()
                                const boardNameInTable = document.querySelectorAll(`.table-row[data-task-id] .board-name`)
                                boardNameInTable.forEach((span) => {
                                    if (span.innerText === currentName)
                                        span.innerText = newName.trim()
                                })
                                this.showNotification("Board renamed successfully", "success")
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
            if (!confirm("Duplicate this board and all its tasks?")) return;


            fetch("board?action=duplicate", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded",
                },
                body: `boardId=${boardId}`,
            })
                .then((response) => {
                    if (!response.ok) throw new Error("Failed to duplicate board");
                    return response.text(); // Bạn có thể dùng JSON nếu muốn trả thêm thông tin
                })
                .then(() => {
                    this.showNotification("✅ Board duplicated successfully", "success");
                    location.reload(); // Load lại để thấy board mới
                })
                .catch((err) => {
                    console.error("❌ Error duplicating board:", err);
                    this.showNotification("❌ Failed to duplicate board", "error");
                });
        }
        
        sortBoardTasks(boardId, sortBy) {
            const boardContainer = document.querySelector(`.board-card[data-board-id="${boardId}"] .board-tasks`);
            if (!boardContainer) return;
            const tasks = Array.from(boardContainer.querySelectorAll(".task-card"));

            tasks.sort((a, b) => {
                if (sortBy === "dueDate") {
                    const dateA = new Date(a.dataset.taskDuedate || "9999-12-31");
                    const dateB = new Date(b.dataset.taskDuedate || "9999-12-31");
                    return dateA - dateB;
                } else if (sortBy === "priority") {
                    const priorityMap = { "High": 1, "Medium": 2, "Low": 3 };
                    const aPriority = priorityMap[a.dataset.taskPriority] || 4;
                    const bPriority = priorityMap[b.dataset.taskPriority] || 4;
                    return aPriority - bPriority;
                }
                return 0;
            });

            tasks.forEach(task => boardContainer.appendChild(task)); // Reorder DOM
            this.showNotification(`🔃 Sorted tasks by ${sortBy}`, "info");
        }
0
        deleteBoard(boardId) {
            console.log("🧪 deleteBoard called with ID:", boardId) // ✅ Thêm dòng này
            if (!confirm("Are you sure you want to delete this board?"))
                return
            fetch("board", {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: `action=delete&listId=${boardId}`,
            })
                    .then((response) => {
                        if (response.ok) {
                            this.showNotification("Board deleted successfully", "success")
                            // Xóa board khỏi UI:
                            const card = document.querySelector(`.board-card[data-board-id="${boardId}"]`)
                            if (card)
                                card.remove()
                            this.updateBoardCounters()
                        } else {
                            this.showNotification("Failed to delete board", "error")
                        }
                    })
                    .catch((error) => {
                        console.error("Delete board error:", error)
                        this.showNotification("Error deleting board", "error")
                    })
        }
        applyAISuggestion(taskId, start, end, priority, difficulty, confidence, shortdesc) {
            if (!confirm("Are you sure you want to apply this AI suggestion?"))
                return;

            const suggestion = {
                taskId: parseInt(taskId),
                title: "",
                start: start,
                end: end,
                priority: priority,
                difficulty: parseInt(difficulty),
                confidence: parseFloat(confidence),
                shortDescription: shortdesc,
                event: false
            };


            fetch(`${window.contextPath}/ai-suggest-apply`, {
                method: "POST",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify({schedules: [suggestion]})
            })
                    .then(res => res.json())
                    .then(result => {
                        this.showNotification("✅ AI suggestion applied!", "success");
                        window.closeAISuggestionModal();

                        // Tìm ô AI Suggestion trong bảng
                        const row = document.querySelector(`.table-row[data-task-id="${taskId}"]`);
                        const col = row?.querySelector(".ai-suggestion-col");

                        if (col) {
                            col.innerHTML = `
                <div class="ai-time">
                    <i class="fas fa-clock"></i>
                    ${start} → ${end}
                </div>
            `;
                        }
                    })
                    .catch(err => {
                        console.error("❌ Failed to apply suggestion:", err);
                        this.showNotification("❌ Failed to apply AI suggestion", "error");
                    });
        }

        handleAddTask() {
            const form = document.getElementById("addTaskForm")
            const formData = new FormData(form)
            const boardId = formData.get("boardId")
            const title = formData.get("title")
            const description = formData.get("description")
            const dueDate = formData.get("dueDate")
            const priority = formData.get("priority")
            const status = formData.get("status")
            if (!title.trim()) {
                this.showNotification("Task title is required", "error")
                return
            }
            fetch("task", {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: `action=create&boardId=${boardId}&title=${encodeURIComponent(title)}&description=${encodeURIComponent(description)}&dueDate=${dueDate}&priority=${priority}&status=${encodeURIComponent(status)}`,
            })
                    .then((response) => {
                        if (!response.ok)
                            throw new Error("Failed to create task")
                        return response.json() // EXPECT JSON return from servlet
                    })
                    .then((data) => {
                        this.showNotification("Task created successfully", "success")
                        window.closeAddTaskModal()
                        // 🆕 Tạo task mới và chèn vào UI
                        const boardTaskContainer = document.querySelector(`.board-card[data-board-id="${boardId}"] .board-tasks`)
                        if (boardTaskContainer) {
                            const taskEl = document.createElement("div")
                            taskEl.className = "task-card"
                            taskEl.setAttribute("data-task-id", data.taskId)
                            taskEl.innerHTML = `
                    <div class="task-title">${title}</div>
                    <div class="task-description">${description}</div>
                    <span class="status-badge ${status.toLowerCase().replace(/\s+/g, "")}">${status}</span>
                    <span class="priority">${priority}</span>
                `
                            boardTaskContainer.appendChild(taskEl)
                            this.updateBoardCounters()
                        }
                        form.reset()
                    })
                    .catch((error) => {
                        console.error("Create task error:", error)
                        this.showNotification("❌ Error creating task", "error")
                    })
        }
        handleEditTask() {
            const form = document.getElementById("editTaskForm")
            const formData = new FormData(form)
            const taskId = formData.get("taskId")
            const title = formData.get("title")
            const description = formData.get("description")
            const dueDate = formData.get("dueDate")
            const priority = formData.get("priority")
            const status = formData.get("status")
            if (!title.trim()) {
                this.showNotification("Task title is required", "error")
                return
            }
            fetch("task", {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: `action=edit&taskId=${taskId}&title=${encodeURIComponent(title)}&description=${encodeURIComponent(description)}&dueDate=${dueDate}&priority=${priority}&status=${encodeURIComponent(status)}`,
            })
                    .then((response) => {
                        if (response.ok) {
                            this.showNotification("Task updated", "success")
                            window.closeEditTaskModal()
                            // Update task card in board view
                            const card = document.querySelector(`.task-card[data-task-id="${taskId}"]`)
                            if (card) {
                                const titleEl = card.querySelector(".task-title")
                                const descEl = card.querySelector(".task-description")
                                const dateEl = card.querySelector(".task-date")
                                const priorityBadge = card.querySelector(".priority-badge")
                                const statusBadge = card.querySelector(".status-badge")
                                if (titleEl)
                                    titleEl.textContent = title
                                if (descEl)
                                    descEl.textContent = description
                                if (dateEl)
                                    dateEl.innerHTML = `<i class="fas fa-calendar-alt"></i> ${dueDate || "No due date"}`
                                if (priorityBadge) {
                                    priorityBadge.textContent = priority
                                    priorityBadge.className = `priority-badge ${priority.toLowerCase()}`
                                }
                                if (statusBadge) {
                                    statusBadge.textContent = status
                                    statusBadge.className = `status-badge ${status.toLowerCase().replace(/\s+/g, "")}`
                                }
                                // update task attributes for popup
                                card.setAttribute("data-task-title", title)
                                card.setAttribute("data-task-description", description)
                                card.setAttribute("data-task-duedate", dueDate)
                                card.setAttribute("data-task-priority", priority)
                                card.setAttribute("data-task-status", status)
                            }
                            // Update task row in overview table
                            const row = document.querySelector(`.table-row[data-task-id="${taskId}"]`)
                            if (row) {
                                const titleEl = row.querySelector("h4")
                                const descEl = row.querySelector(".task-details p")
                                const dateEl = row.querySelector(".date-info span")
                                const priorityBadge = row.querySelector(".priority-badge")
                                const statusBadge = row.querySelector(".status-badge")
                                if (titleEl)
                                    titleEl.textContent = title
                                if (descEl)
                                    descEl.textContent = description
                                if (dateEl)
                                    dateEl.textContent = dueDate || "No due date"
                                if (priorityBadge) {
                                    priorityBadge.textContent = priority
                                    priorityBadge.className = `priority-badge ${priority.toLowerCase()}`
                                }
                                if (statusBadge) {
                                    statusBadge.textContent = status
                                    statusBadge.className = `status-badge ${status.toLowerCase().replace(/\s+/g, "")}`
                                }
                                // Update data attributes
                                row.dataset.taskTitle = title
                                row.dataset.taskDescription = description
                                row.dataset.taskDuedate = dueDate
                                row.dataset.taskPriority = priority
                                row.dataset.taskStatus = status
                                row.dataset.status = status.toLowerCase().replace(/\s+/g, "")
                            }
                            this.updateBoardCounters()
                        } else {
                            this.showNotification("❌ Failed to update task", "error")
                        }
                    })
                    .catch((err) => {
                        console.error("Edit task error:", err)
                        this.showNotification("❌ Error updating task", "error")
                    })
        }
        
        deleteTask(taskId) {
            if (!confirm("Are you sure you want to delete this task?"))
                return
            fetch("task", {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: `action=delete&taskId=${taskId}`,
            })
                    .then((response) => {
                        if (response.ok) {
                            this.showNotification("Task deleted", "success")
                            window.closeTaskDetailModal()
                            const row = document.querySelector(`.table-row[data-task-id="${taskId}"]`)
                            const card = document.querySelector(`.task-card[data-task-id="${taskId}"]`)
                            if (row)
                                row.remove()
                            if (card)
                                card.remove()
                            this.updateBoardCounters()
                        } else {
                            this.showNotification("❌ Failed to delete task", "error")
                        }
                    })
                    .catch((err) => {
                        console.error("Delete task error:", err)
                        this.showNotification("❌ Error deleting task", "error")
                    })
        }
        handleAddBoard(form) {
            const formData = new FormData(form)
            const projectId = formData.get("projectId")
            const name = formData.get("name")
            const position = formData.get("position")
            fetch("board", {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: `action=add&projectId=${projectId}&name=${encodeURIComponent(name)}&position=${position}`,
            })
                    .then((res) => res.json())
                    .then((data) => {
                        if (data.success) {
                            this.showNotification("Board added!", "success")
                            window.closeAddBoardModal()
                            // 👉 Tạo phần tử DOM cho board mới
                            const newCard = document.createElement("div")
                            newCard.className = "board-card"
                            newCard.setAttribute("data-board-id", data.boardId)
                            newCard.innerHTML = `
                <div class="board-header">
                    <div class="board-title-section">
                        <h3 class="board-title">${data.name}</h3>
                        <div class="board-stats">
                            <span class="task-count">0</span>
                            <div class="progress-indicator">
                                <div class="progress-bar">
                                    <div class="progress-fill" style="width: 0%"></div>
                                </div>
                                <span class="progress-text">0/0</span>
                            </div>
                        </div>
                    </div>
                    <div class="board-actions">
                        <button onclick="openAddTaskModal(${data.boardId})" class="action-btn add-task-btn" title="Add Task">
                            <i class="fas fa-plus"></i>
                        </button>
                        <div class="board-menu">
                            <button class="action-btn menu-btn" onclick="toggleBoardMenu(this)" title="More Options">
                                <i class="fas fa-ellipsis-v"></i>
                            </button>
                            <div class="board-dropdown">
                                <button onclick="editBoard(${data.boardId}, '${data.name}')">
                                    <i class="fas fa-edit"></i> Edit Board
                                </button>
                                <button onclick="duplicateBoard(${data.boardId})">
                                    <i class="fas fa-copy"></i> Duplicate Board
                                </button>
                                <hr>
                                <button onclick="sortBoardTasks(${data.boardId}, 'dueDate')">
                                    <i class="fas fa-calendar-alt"></i> Sort by Due Date
                                </button>
                                <button onclick="sortBoardTasks(${data.boardId}, 'priority')">
                                    <i class="fas fa-flag"></i> Sort by Priority
                                </button>
                                <hr>
                                <button class="delete-btn" onclick="taskManager.deleteBoard(${data.boardId})">
                                    <i class="fas fa-trash"></i> Delete Board
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="board-content">
                    <div class="board-tasks" data-board-id="${data.boardId}"></div>
                    <button onclick="openAddTaskModal(${data.boardId})" class="add-task-button">
                        <i class="fas fa-plus"></i>
                        <span>Add a task</span>
                    </button>
                </div>
            `
                            // Gắn thẻ mới trước "add-board-card"
                            const addBoardCard = document.querySelector(".add-board-card")
                            addBoardCard.parentNode.insertBefore(newCard, addBoardCard)
                            this.initializeSortable()
                            this.updateBoardCounters()
                        } else {
                            this.showNotification("❌ Failed to add board", "error")
                        }
                    })
                    .catch((err) => {
                        console.error("Add board error:", err)
                        this.showNotification("❌ Error adding board", "error")
                    })
        }

        // Project Members functions
        displayProjectMembers() {
            const projectId = new URLSearchParams(window.location.search).get("projectId")
            if (!projectId)
                return

            fetch(`${window.contextPath}/project?action=getMembers&projectId=${projectId}`)
                    .then((res) => res.json())
                    .then((members) => {
                        // Save globally
                        window.projectMembers = members;
                        
                        const list = document.getElementById("projectMemberList")
                        list.innerHTML = "" // Clear existing members

                        if (members.length === 0) {
                            list.innerHTML = '<div class="empty-members"><i class="fas fa-users-slash"></i><p>No members yet.</p></div>'
                            return
                        }

                        members.forEach((member) => {
                            const memberItem = document.createElement("div")
                            memberItem.className = "member-item"
                            memberItem.innerHTML = `
                            ${this.getMemberAvatarHtml(member.username, member.avatarUrl)}
                            <div class="member-info">
                                <span class="member-name">${member.username}</span>
                                <span class="member-role">${member.role}</span>
                            </div>
                        `
                            list.appendChild(memberItem)
                        })
                    })
                    .catch((err) => {
                        console.error("Error fetching project members:", err)
                        document.getElementById("projectMemberList").innerHTML =
                                '<div class="empty-members"><i class="fas fa-exclamation-circle"></i><p>Error loading members.</p></div>'
                    })
        }

        getMemberAvatarHtml(username, avatarUrl) {
            if (avatarUrl) {
                return `<div class="member-avatar"><img src="${avatarUrl}" alt="${username}'s avatar"></div>`
            } else {
                const initials = username ? username.charAt(0).toUpperCase() : "?"
                return `<div class="member-avatar">${initials}</div>`
            }
        }

        sendInvitation() {
            const inviteEmailInput = document.getElementById("inviteEmail");
            const email = inviteEmailInput?.value?.trim();
            const projectId = new URLSearchParams(window.location.search).get("projectId");

            if (!email || !projectId) {
                this.showNotification("❗ Please enter a valid email and ensure project ID is present.", "error");
                return;
            }

            // Basic email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                this.showNotification("❗ Please enter a valid email address.", "error");
                return;
            }

            const body = `projectId=${encodeURIComponent(projectId)}&email=${encodeURIComponent(email)}`;

            fetch(`${window.contextPath}/invite`, {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body
            })
                    .then(res => res.text())
                    .then(result => {
                        console.log("📩 Server response:", result);

                        const responseMap = {
                            SUCCESS: () => {
                                this.showNotification(`✅ Invitation sent to ${email}!`, "success");
                                inviteEmailInput.value = "";
                                this.displayProjectMembers();
                            },
                            ALREADY_INVITED: () => this.showNotification("⚠️ This user has already been invited.", "warning"),
                            ALREADY_MEMBER: () => this.showNotification("⚠️ This user is already a project member.", "info"),
                            INVALID_EMAIL: () => this.showNotification("❌ Invalid or undeliverable email address.", "error")
                        };

                        (responseMap[result] || (() => this.showNotification("⚠️ Unknown server response: " + result, "error")))();
                    })
                    .catch(error => {
                        console.error("❌ Error sending invitation:", error);
                        this.showNotification("❌ Failed to send invitation. Please try again.", "error");
                    });
        }

    }

    // Initialize TaskManager
    const taskManager = new TaskManager()
    window.taskManager = taskManager

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
        loadAttachmentsForTask(taskId);
        
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
    .notification-info {
        border-left-color: #3b82f6;
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
    }`
// Inject notification styles
const styleSheet = document.createElement("style")
styleSheet.textContent = notificationStyles
document.head.appendChild(styleSheet)
window.openAISuggestionModal = (taskId, taskTitle, taskDesc, taskDue, taskPriority) => {
    console.log("🧪 AI Suggest Clicked:", {taskId, taskTitle, taskDesc, taskDue, taskPriority});

    fetch(`${window.contextPath}/ai-suggest-preview`, {
        method: "POST",
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: `taskId=${taskId}`,
        credentials: "include",
    })
            .then((res) => {
                if (!res.ok)
                    throw new Error("Server returned error");
                return res.json();
            })
            .then((suggestion) => {
                if (!suggestion || !suggestion.start || !suggestion.end) {
                    alert("No suggestion received.");
                    return;
                }

                // Thông tin task hiện tại
                document.getElementById("aiCurrentTaskTitle").innerText = taskTitle;
                document.getElementById("aiCurrentTaskDescription").innerText = taskDesc;
                document.getElementById("aiCurrentTaskDueDate").innerText = taskDue || "N/A";
                document.getElementById("aiCurrentTaskPriority").innerText = taskPriority || "N/A";

                // Thông tin gợi ý từ AI
                document.getElementById("aiSuggestedStart").innerText = suggestion.start || "N/A";
                document.getElementById("aiSuggestedEnd").innerText = suggestion.end || "N/A";
                document.getElementById("aiSuggestedPriority").innerText = suggestion.priority || "N/A";
                document.getElementById("aiSuggestedDifficulty").innerText = suggestion.difficulty || "N/A";
                document.getElementById("aiSuggestedConfidence").innerText = Math.round(suggestion.confidence * 100) + "%";
                document.getElementById("aiSuggestedShortDesc").innerText = suggestion.shortDescription || "N/A";

                // Gán dữ liệu để apply
                const btn = document.getElementById("applyAISuggestionBtn");
                btn.dataset.taskId = taskId;
                btn.dataset.start = suggestion.start;
                btn.dataset.end = suggestion.end;
                btn.dataset.priority = suggestion.priority;
                btn.dataset.difficulty = suggestion.difficulty;
                btn.dataset.confidence = suggestion.confidence;
                btn.dataset.shortdesc = suggestion.shortDescription;
                document.getElementById("rejectAISuggestionBtn").dataset.taskId = taskId;
                document.getElementById("aiSuggestionModal").style.display = "block";
            })
            .catch((err) => {
                console.error("AI fetch failed", err);
                alert("AI suggestion failed.");
            });
};

window.closeAddTaskModal = () => {
    document.getElementById("addTaskModal").style.display = "none"
}
window.closeEditTaskModal = () => {
    document.getElementById("editTaskModal").style.display = "none"
}
window.closeTaskDetailModal = () => {
    document.getElementById("taskDetailModal").style.display = "none"
}

function assignTask(taskId, selectedUserIds) {
    fetch('/BeeTask/assign', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            taskId: taskId,
            userIds: selectedUserIds
        })
    })
    .then(res => {
        if (res.ok) {
            alert('Task assigned successfully');
        } else {
            alert('Failed to assign task');
        }
    });
}

function openAssignModal(taskId, assignedUserIds = []) {
    console.log(">>> openAssignModal() called with taskId =", taskId);

    const projectId = new URLSearchParams(window.location.search).get("projectId");
    if (!projectId) {
        console.error("No projectId found in URL");
        return;
    }

    const assignTaskIdInput = document.getElementById("assignTaskId");
    const assignModal = document.getElementById("assignModal");
    const checkboxesContainer = document.getElementById("userCheckboxes");

    // Gán taskId vào hidden input
    assignTaskIdInput.value = taskId;

    // Xóa các checkbox cũ
    checkboxesContainer.innerHTML = "<p>Loading members...</p>";

    // Gọi API để lấy danh sách thành viên của project
    fetch(`${window.contextPath}/project?action=getMembers&projectId=${projectId}`)
        .then(response => response.json())
        .then(members => {
            if (!members || members.length === 0) {
                checkboxesContainer.innerHTML = "<p>No members found in this project.</p>";
                return;
            }

            // Xóa nội dung loading
            checkboxesContainer.innerHTML = "";

            // Hiển thị checkbox cho từng thành viên
            members.forEach(member => {
                const isChecked = assignedUserIds.includes(member.userId);
                const checkboxWrapper = document.createElement("div");
                checkboxWrapper.classList.add("form-check", "mb-2");
                checkboxWrapper.innerHTML = `
                    <input class="form-check-input" type="checkbox" name="assignees" value="${member.userId}" id="member-${member.userId}" ${isChecked ? 'checked' : ''}>
                    <label class="form-check-label" for="member-${member.userId}">
                        ${member.username || member.name}
                    </label>
                `;
                checkboxesContainer.appendChild(checkboxWrapper);
            });

            assignModal.style.display = "block";
        })
        .catch(error => {
            console.error("Error fetching project members:", error);
            checkboxesContainer.innerHTML = "<p>Error loading members.</p>";
        });
}

function closeAssignModal() {
    document.getElementById("assignModal").style.display = "none";
}

function submitAssignForm(event) {
    event.preventDefault(); // Ngăn reload

    const taskId = document.getElementById("assignTaskId").value;
    const checkboxes = document.querySelectorAll('input[name="assignees"]:checked');
    const userIds = Array.from(checkboxes).map(cb => parseInt(cb.value));

    if (!taskId || isNaN(taskId)) {
        alert("Task ID is invalid.");
        return;
    }

    if (userIds.length === 0) {
        alert("Please select at least one user to assign.");
        return;
    }

    fetch('/BeeTask/assign', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ taskId: parseInt(taskId), userIds })
    })
    .then(response => response.json())
    .then(data => {
        alert("Users assigned successfully!");
        closeAssignModal();
        // Optionally refresh or update UI
    })
    .catch(error => {
        console.error("Assignment error:", error);
        alert("Failed to assign users.");
    });
}

document.getElementById("uploadForm").addEventListener("submit", async function (e) {
  e.preventDefault();

  const form = e.target;
  const formData = new FormData(form);
  const messageDiv = document.getElementById("uploadMessage");

  // Xoá nội dung thông báo trước đó
  messageDiv.textContent = "";
  messageDiv.style.color = "";

  try {
    const response = await fetch("/BeeTask/uploadAttachments", {
      method: "POST",
      body: formData,
    });

    const resultText = await response.text();

    if (!response.ok) {
      throw new Error("Upload failed: " + resultText);
    }

    let result;
    try {
      result = JSON.parse(resultText); // tránh lỗi JSON parse nếu backend trả HTML
    } catch (parseErr) {
      throw new Error("Invalid server response");
    }

    if (result.success && result.fileName) {
      messageDiv.textContent = "File uploaded successfully.";
      messageDiv.style.color = "green";

      // Reset form
      form.reset();

      // Load lại danh sách file
      const taskId = document.getElementById("uploadTaskId").value;
      loadAttachmentsForTask(taskId);

      // Đóng modal sau 1.5s
      setTimeout(() => {
        closeUploadModal();
        messageDiv.textContent = "";
      }, 1500);
    } else {
      messageDiv.textContent = "Upload failed. Please try again.";
      messageDiv.style.color = "red";
    }

  } catch (error) {
    console.error("Upload Error:", error);
    messageDiv.textContent = "An error occurred: " + error.message;
    messageDiv.style.color = "red";
  }
});

function loadAttachmentsForTask(taskId) {
  fetch(`/BeeTask/uploadAttachments?taskId=${taskId}`)
    .then(response => {
      if (!response.ok) throw new Error("Failed to fetch attachments.");
      return response.json();
    })
    .then(data => {
      const list = document.getElementById("attachmentFileList");
      list.innerHTML = "";

      if (data.length === 0) {
        list.innerHTML = "<li>No attachments</li>";
        return;
      }

    data.forEach(file => {
      const li = document.createElement("li");
      li.innerHTML = `
        <span>${file.fileName}</span>
        <button onclick="downloadAttachment('${file.fileUrl}')">Download</button>
        <button onclick="deleteAttachment(${taskId}, '${file.fileName}')">Delete</button>
      `;
      list.appendChild(li);
    });
    })
    .catch(error => {
      console.error("Error loading attachments:", error);
    });
}

function deleteAttachment(taskId, filename) {
    if (confirm("Are you sure you want to delete this attachment?")) {
        fetch(`file?taskId=${taskId}&filename=${encodeURIComponent(filename)}`, {
            method: 'DELETE'
        })
        .then(response => response.text())
        .then(message => {
            alert(message);
            loadAttachmentsForTask(taskId);
        })
        .catch(err => {
            console.error("Error deleting file:", err);
            alert("Failed to delete file.");
        });
    }
}

function downloadAttachment(fileUrl) {
  const a = document.createElement("a");
  a.href = fileUrl;
  a.download = ""; // Hỗ trợ tải trực tiếp nếu server set header đúng
  a.style.display = "none";
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
}


function openUploadModal(taskId) {
  document.getElementById("uploadTaskId").value = taskId;
  document.getElementById("uploadModal").style.display = "block";
}

function closeUploadModal() {
  document.getElementById("uploadModal").style.display = "none";
}