class NoteManager {
  constructor() {
    this.currentNoteId = null;
    this.noteToDelete = null;
    this.customLabels = JSON.parse(localStorage.getItem("customLabels") || "[]");
    this.selectedColor = "#3182ce"; // Default color
    this.init();
  }

  init() {
    this.bindEvents();
    this.checkEmptyState();
    this.makeAllEditable();
  }

  bindEvents() {
    document.getElementById("add-note-btn")?.addEventListener("click", () => this.addNewNote());

    document.addEventListener("click", (e) => {
      if (e.target.closest(".menu-btn")) {
        this.showContextMenu(e);
      } else {
        this.hideContextMenu(e);
      }
    });

    document.querySelectorAll(".context-menu-item").forEach(item =>
      item.addEventListener("click", (e) => this.handleNoteActions(e))
    );

    document.getElementById("close-label-modal")?.addEventListener("click", () => this.closeModal("label"));
    document.getElementById("close-deadline-modal")?.addEventListener("click", () => this.closeModal("deadline"));
    document.getElementById("close-delete-modal")?.addEventListener("click", () => this.closeModal("delete"));
    document.getElementById("create-label-btn")?.addEventListener("click", () => this.createNewLabel());
    
    document.querySelectorAll(".color-option").forEach(opt =>
      opt.addEventListener("click", () => this.selectColor(opt))
    );

    document.getElementById("save-deadline")?.addEventListener("click", () => this.saveDeadline());
    document.getElementById("remove-deadline")?.addEventListener("click", () => this.removeDeadline());
    document.querySelectorAll(".quick-option").forEach(opt =>
      opt.addEventListener("click", () => this.setQuickDeadline(opt))
    );

    document.getElementById("cancel-delete")?.addEventListener("click", () => this.closeModal("delete"));
    document.getElementById("confirm-delete")?.addEventListener("click", () => this.confirmDelete());
  }

  showContextMenu(e) {
    const menuBtn = e.target.closest(".menu-btn");
    const contextMenu = document.getElementById("context-menu");

    if (menuBtn && contextMenu) {
      e.preventDefault();
      this.currentNoteId = menuBtn.dataset.noteId;

      const rect = menuBtn.getBoundingClientRect();
      contextMenu.classList.add("active");
      contextMenu.style.top = `${rect.bottom + window.scrollY + 6}px`;
      contextMenu.style.left = `${Math.min(rect.left + window.scrollX, window.innerWidth - contextMenu.offsetWidth - 10)}px`;
    }
  }

  hideContextMenu(e) {
    const contextMenu = document.getElementById("context-menu");
    if (contextMenu && (!e || !contextMenu.contains(e.target))) {
      contextMenu.classList.remove("active");
    }
  }

  handleNoteActions(e) {
    const actionItem = e.target.closest(".context-menu-item");
    if (!actionItem || !this.currentNoteId) return;

    const action = actionItem.dataset.action;
    switch (action) {
      case "setLabel": this.openModal("label"); break;
      case "setDeadline": this.openModal("deadline"); break;
      case "delete": this.openModal("delete"); break;
      default: this.showNotification("❗ Tính năng chưa hỗ trợ", "error");
    }
    this.hideContextMenu();
  }

  openModal(type) {
    const modal = document.getElementById(`${type}-modal`);
    if (modal) {
      modal.classList.add("active");
      if (type === "label") this.loadLabels();
      if (type === "delete") {
        this.noteToDelete = document.querySelector(`.note-item[data-id="${this.currentNoteId}"]`);
      }
    }
  }

  closeModal(type) {
    document.getElementById(`${type}-modal`)?.classList.remove("active");
  }

  addNewNote() {
    const userId = document.getElementById("userId")?.value;
    if (!userId) {
        this.showNotification("❌ Không tìm thấy userId", "error");
        return;
    }

    const formData = new URLSearchParams();
    formData.append("action", "create");
    formData.append("userId", userId);
    formData.append("title", "Ghi chú mới");
    formData.append("content", "Nội dung mô tả...");
    formData.append("labelId", "0"); // Thêm labelId mặc định

    fetch("notes", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: formData
    })
    .then(response => {
        if (!response.ok) {
            return response.text().then(text => { throw new Error(text) });
        }
        return response.text();
    })
    .then(message => {
        // Xử lý khi tạo thành công
        console.log("Tạo note thành công:", message);
        this.showNotification("✅ Ghi chú đã tạo", "success");
        location.reload(); // Tải lại trang để hiển thị note mới
    })
    .catch(error => {
        console.error("Lỗi khi tạo note:", error);
        this.showNotification(`❌ ${error.message}`, "error");
    });
}

  makeEditable(element) {
    if (!element) return;

    element.addEventListener("click", (e) => {
      if (e.target !== element) return;

      const oldText = element.textContent;
      const input = document.createElement("input");
      input.type = "text";
      input.value = oldText;
      input.className = "note-input";

      input.style.width = "100%";
      input.style.padding = "2px 4px";
      input.style.fontSize = window.getComputedStyle(element).fontSize;
      input.style.border = "1px solid #3182ce";
      input.style.borderRadius = "4px";

      element.replaceWith(input);
      input.focus();

      const saveEdit = () => {
        const newText = input.value.trim() || oldText;
        const noteItem = input.closest(".note-item");
        const noteId = noteItem.dataset.id;
        const isTitle = element.classList.contains("note-text");

        const data = {
          action: "update",
          noteId,
          title: isTitle ? newText : noteItem.querySelector(".note-text").textContent,
          content: !isTitle ? newText : noteItem.querySelector(".note-description").textContent,
          deadline: ""
        };

        fetch("notes", {
          method: "POST",
          headers: { "Content-Type": "application/x-www-form-urlencoded" },
          body: new URLSearchParams(data)
        })
        .then(res => res.ok ? res.text() : Promise.reject("❌ Cập nhật thất bại"))
        .then(() => {
          const newEl = document.createElement(element.tagName.toLowerCase());
          newEl.className = element.className;
          newEl.textContent = newText;
          input.replaceWith(newEl);
          this.makeEditable(newEl);
          this.showNotification("✅ Đã cập nhật", "success");
        })
        .catch(err => {
          const newEl = document.createElement(element.tagName.toLowerCase());
          newEl.className = element.className;
          newEl.textContent = oldText;
          input.replaceWith(newEl);
          this.makeEditable(newEl);
          this.showNotification(err, "error");
        });
      };

      input.addEventListener("blur", saveEdit);
      input.addEventListener("keydown", (e) => {
        if (e.key === "Enter") saveEdit();
        if (e.key === "Escape") {
          const newEl = document.createElement(element.tagName.toLowerCase());
          newEl.className = element.className;
          newEl.textContent = oldText;
          input.replaceWith(newEl);
          this.makeEditable(newEl);
        }
      });
    });
  }

  makeAllEditable() {
    document.querySelectorAll(".note-text, .note-description").forEach(el => {
      this.makeEditable(el);
    });
  }

  loadLabels() {
    const container = document.querySelector(".label-options");
    container.innerHTML = "<div class='loading'>Loading labels...</div>";

    fetch("labels")
      .then(res => res.json())
      .then(dbLabels => {
        container.innerHTML = "";
        dbLabels.forEach(label => {
          const div = this.createLabelElement(label);
          container.appendChild(div);
        });

        const divider = document.createElement("div");
        divider.className = "section-divider";
        container.appendChild(divider);

        this.customLabels.forEach(label => {
          const div = this.createLabelElement(label);
          container.appendChild(div);
        });
      })
      .catch(err => {
        console.error("Error loading labels:", err);
        container.innerHTML = "<div class='error'>Failed to load labels</div>";
      });
  }

  createLabelElement(label) {
    const div = document.createElement("div");
    div.className = "label-option";
    div.dataset.id = label.labelId || Date.now();
    div.innerHTML = `
      <span class="label-dot" style="background-color:${label.color}"></span>
      ${label.name}
    `;
    div.addEventListener("click", () => this.applyLabel(label));
    return div;
  }

  applyLabel(label) {
    const noteItem = document.querySelector(`.note-item[data-id="${this.currentNoteId}"]`);
    if (!noteItem) return;

    const labelContainer = noteItem.querySelector(".note-labels");
    labelContainer.innerHTML = `
      <span class="note-label" data-id="${label.labelId || label.id}" data-color="${label.color}">
        <span class="label-dot" style="background-color:${label.color}"></span>
        ${label.name}
      </span>`;
    this.updateNoteLabel(label.labelId || label.id);
    this.closeModal("label");
  }

  updateNoteLabel(labelId) {
    fetch("notes", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({ action: "updateLabel", noteId: this.currentNoteId, labelId })
    }).catch(err => console.error("Error updating label:", err));
  }

  createNewLabel() {
    const nameInput = document.getElementById("new-label-name");
    const name = nameInput.value.trim();
    if (!name) return this.showNotification("⚠️ Tên nhãn không được để trống", "error");

    const newLabel = { id: Date.now(), name, color: this.selectedColor };
    this.customLabels.push(newLabel);
    localStorage.setItem("customLabels", JSON.stringify(this.customLabels));
    this.applyLabel(newLabel);
    nameInput.value = "";
  }

  selectColor(opt) {
    this.selectedColor = opt.dataset.color;
    document.querySelectorAll(".color-option").forEach(opt => opt.classList.remove("selected"));
    opt.classList.add("selected");
  }

  saveDeadline() {
    const date = document.getElementById("deadline-date").value;
    const time = document.getElementById("deadline-time").value;
    if (!date || !time || !this.currentNoteId) return;

    const deadline = `${date}T${time}`;
    const formatted = new Date(deadline).toLocaleString("vi-VN", {
      day: "2-digit", month: "2-digit", year: "numeric",
      hour: "2-digit", minute: "2-digit"
    });

    const noteItem = document.querySelector(`.note-item[data-id="${this.currentNoteId}"]`);
    let deadlineEl = noteItem.querySelector(".note-deadline");
    if (!deadlineEl) {
      deadlineEl = document.createElement("span");
      deadlineEl.className = "note-deadline";
      noteItem.querySelector(".note-dates").appendChild(deadlineEl);
    }

    deadlineEl.innerHTML = `<i class="fas fa-clock"></i> ${formatted}`;
    deadlineEl.dataset.deadline = deadline;
    this.updateNoteDeadline(deadline);
    this.closeModal("deadline");
  }

  updateNoteDeadline(deadline) {
    fetch("notes", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({ action: "updateDeadline", noteId: this.currentNoteId, deadline })
    }).catch(err => console.error("Error updating deadline:", err));
  }

  removeDeadline() {
    const noteItem = document.querySelector(`.note-item[data-id="${this.currentNoteId}"]`);
    const deadlineEl = noteItem?.querySelector(".note-deadline");
    if (deadlineEl) {
      deadlineEl.remove();
      this.updateNoteDeadline("");
    }
    this.closeModal("deadline");
  }

  setQuickDeadline(opt) {
    const hours = parseInt(opt.dataset.hours || 0);
    const days = parseInt(opt.dataset.days || 0);
    const now = new Date();
    if (hours) now.setHours(now.getHours() + hours);
    if (days) now.setDate(now.getDate() + days);
    document.getElementById("deadline-date").value = now.toISOString().split("T")[0];
    document.getElementById("deadline-time").value = now.toTimeString().substring(0, 5);
  }

  confirmDelete() {
    if (!this.noteToDelete || !this.currentNoteId) return;

    fetch("notes", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({ action: "delete", noteId: this.currentNoteId })
    })
    .then(res => res.ok ? res.text() : Promise.reject("❌ Không thể xóa"))
    .then(() => {
      this.noteToDelete.remove();
      this.showNotification("🗑️ Đã xóa ghi chú", "success");
      this.checkEmptyState();
    })
    .catch(err => {
      console.error(err);
      this.showNotification(err, "error");
    });

    this.closeModal("delete");
  }

  checkEmptyState() {
    const notesList = document.getElementById("notes-list");
    const emptyState = document.getElementById("empty-state");
    if (notesList && emptyState) {
      emptyState.style.display = notesList.children.length > 0 ? "none" : "block";
    }
  }

  showNotification(msg, type) {
    const toast = document.createElement("div");
    toast.className = `notification ${type}`;
    toast.textContent = msg;
    document.body.appendChild(toast);
    setTimeout(() => {
      toast.style.opacity = "0";
      setTimeout(() => toast.remove(), 300);
    }, 3000);
  }
}

document.addEventListener("DOMContentLoaded", () => new NoteManager());
