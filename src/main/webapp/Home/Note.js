class NoteManager {
  constructor() {
    this.currentNoteId = null;
    this.noteToDelete = null;
    this.customLabels = JSON.parse(localStorage.getItem("customLabels") || "[]");
    this.selectedColor = "blue";
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

    // Bổ sung: gán hành động cho từng context menu item
    document.querySelectorAll(".context-menu-item").forEach(item =>
      item.addEventListener("click", (e) => this.handleNoteActions(e))
    );

    // Modal buttons
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

  checkEmptyState() {
    const notesList = document.getElementById("notes-list");
    const emptyState = document.getElementById("empty-state");
    if (notesList && emptyState) {
      emptyState.style.display = notesList.children.length > 0 ? "none" : "block";
    }
  }

  addNewNote() {
    const notesList = document.getElementById("notes-list");
    const userId = document.getElementById("userId")?.value;
    if (!userId) return this.showNotification("❌ Không tìm thấy userId", "error");

    const noteId = Date.now();
    const title = "Ghi chú mới";
    const content = "Nội dung mô tả...";
    const labelId = 0;
    const now = new Date();
    const formattedTime = now.toLocaleString("vi-VN", { day: "2-digit", month: "2-digit", year: "numeric", hour: "2-digit", minute: "2-digit" });

    fetch("notes", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({ action: "create", userId, title, content, labelId })
    })
      .then(res => res.ok ? res.text() : Promise.reject("❌ Không thể tạo ghi chú"))
      .then(() => {
        const noteItem = document.createElement("div");
        noteItem.className = "note-item";
        noteItem.dataset.id = noteId;
        noteItem.innerHTML = `
          <div class="note-checkbox-wrapper">
            <input type="checkbox" class="note-checkbox" id="note-${noteId}">
            <label for="note-${noteId}" class="checkbox-label"></label>
          </div>
          <div class="note-content" data-editable="true">
            <span class="note-text">${title}</span>
            <p class="note-description">${content}</p>
            <div class="note-meta">
              <div class="note-labels">
                <span class="note-label" data-color="blue">
                  <span class="label-dot" style="background-color: blue"></span> Mặc định
                </span>
              </div>
              <div class="note-dates">
                <span class="note-created"><i class="fas fa-calendar-plus"></i> ${formattedTime}</span>
              </div>
            </div>
          </div>
          <div class="note-actions">
            <button class="menu-btn" data-note-id="${noteId}">
              <i class="fas fa-ellipsis-h"></i>
            </button>
          </div>`;
        notesList.prepend(noteItem);
        this.makeAllEditable();
        this.showNotification("✅ Ghi chú đã tạo", "success");
        this.checkEmptyState();
      })
      .catch(err => {
        console.error(err);
        this.showNotification(err, "error");
      });
  }

  makeEditable(element) {
    if (!element) return;
    element.addEventListener("click", () => {
      const oldText = element.textContent;
      const input = document.createElement("input");
      input.type = "text";
      input.value = oldText;
      input.className = "note-input";
      element.replaceWith(input);
      input.focus();

      input.addEventListener("blur", () => {
        const newText = input.value.trim() || oldText;
        const noteItem = input.closest(".note-item");
        const noteId = noteItem.dataset.id;
        const isTitle = element.classList.contains("note-text");
        const title = isTitle ? newText : noteItem.querySelector(".note-text").textContent;
        const content = !isTitle ? newText : noteItem.querySelector(".note-description").textContent;

        fetch("notes", {
          method: "POST",
          headers: { "Content-Type": "application/x-www-form-urlencoded" },
          body: new URLSearchParams({ action: "update", noteId, title, content, deadline: "" })
        })
          .then(res => res.ok ? res.text() : Promise.reject("❌ Cập nhật thất bại"))
          .then(() => this.showNotification("✅ Đã cập nhật", "success"))
          .catch(err => this.showNotification(err, "error"));

        const newEl = document.createElement(element.tagName.toLowerCase());
        newEl.className = element.className;
        newEl.textContent = newText;
        input.replaceWith(newEl);
        this.makeEditable(newEl);
      });

      input.addEventListener("keydown", e => {
        if (e.key === "Enter") input.blur();
      });
    });
  }

  makeAllEditable() {
    document.querySelectorAll(".note-text, .note-description").forEach(el =>
      this.makeEditable(el)
    );
  }

  loadLabels() {
    const container = document.querySelector(".label-options");
    container.innerHTML = "";
    this.customLabels.forEach(label => {
      const div = document.createElement("div");
      div.className = "label-option";
      div.dataset.name = label.name;
      div.dataset.color = label.color;
      div.innerHTML = `<span class="label-dot" style="background-color:${label.color}"></span> ${label.name}`;
      div.addEventListener("click", () => this.applyLabel(label.name, label.color));
      container.appendChild(div);
    });
  }

  applyLabel(name, color) {
    const noteItem = document.querySelector(`.note-item[data-id="${this.currentNoteId}"]`);
    if (!noteItem) return;
    const labelContainer = noteItem.querySelector(".note-labels");
    labelContainer.innerHTML = `
      <span class="note-label" data-color="${color}">
        <span class="label-dot" style="background-color:${color}"></span> ${name}
      </span>`;
    this.closeModal("label");
  }

  createNewLabel() {
    const nameInput = document.getElementById("new-label-name");
    const name = nameInput.value.trim();
    if (!name) return this.showNotification("⚠️ Tên nhãn không được để trống", "error");

    const label = { name, color: this.selectedColor };
    this.customLabels.push(label);
    localStorage.setItem("customLabels", JSON.stringify(this.customLabels));
    this.applyLabel(name, this.selectedColor);
    nameInput.value = "";
  }

  selectColor(option) {
    this.selectedColor = option.dataset.color;
    document.querySelectorAll(".color-option").forEach(opt => opt.classList.remove("selected"));
    option.classList.add("selected");
  }

  saveDeadline() {
    const date = document.getElementById("deadline-date").value;
    const time = document.getElementById("deadline-time").value;
    if (!date || !time || !this.currentNoteId) return;
    const deadline = `${date} ${time}:00`;

    const noteItem = document.querySelector(`.note-item[data-id="${this.currentNoteId}"]`);
    const display = noteItem.querySelector(".note-dates");

    let span = display.querySelector(".note-deadline");
    if (!span) {
      span = document.createElement("span");
      span.className = "note-deadline";
      display.appendChild(span);
    }
    span.innerHTML = `<i class="fas fa-clock"></i> ${new Date(deadline).toLocaleString("vi-VN")}`;
    this.closeModal("deadline");
  }

  removeDeadline() {
    const span = document.querySelector(`.note-item[data-id="${this.currentNoteId}"] .note-deadline`);
    span?.remove();
    this.closeModal("deadline");
  }

  setQuickDeadline(option) {
    const hours = parseInt(option.dataset.hours || 0);
    const days = parseInt(option.dataset.days || 0);
    const now = new Date();
    if (hours) now.setHours(now.getHours() + hours);
    if (days) now.setDate(now.getDate() + days);
    document.getElementById("deadline-date").value = now.toISOString().split("T")[0];
    document.getElementById("deadline-time").value = now.toTimeString().slice(0, 5);
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
      .catch(err => this.showNotification(err, "error"));

    this.closeModal("delete");
  }

  showNotification(message, type) {
    const toast = document.createElement("div");
    toast.className = `notification ${type}`;
    toast.textContent = message;
    document.body.appendChild(toast);
    setTimeout(() => toast.remove(), 3000);
  }
}

document.addEventListener("DOMContentLoaded", () => {
  new NoteManager();
});
