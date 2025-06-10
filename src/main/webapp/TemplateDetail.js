// Toggle dark mode
document.getElementById('darkModeToggle').addEventListener('change', function () {
    document.body.classList.toggle('dark-mode');
});


// Toggle sidebar collapse
document.querySelector('.toggle-btn').addEventListener('click', function () {
    document.querySelector('.sidebar').classList.toggle('collapsed');
});

// Toggle board collapse
document.querySelectorAll('.collapse-btn').forEach(btn => {
    btn.addEventListener('click', function () {
        const column = this.closest('.task-column');
        column.classList.toggle('collapsed');
    });
});

// Popup handling for List actions
const listActionsPopup = document.getElementById('taskPopup');
const addTaskPopup = document.getElementById('addTaskPopup');
const taskDetailPopup = document.getElementById('taskDetailPopup');

// Mở popup List actions khi nhấn nút 3 chấm
document.querySelectorAll('.menu-btn').forEach(btn => {
    btn.addEventListener('click', function (e) {
        e.preventDefault();
        listActionsPopup.style.display = 'block';
        const rect = btn.getBoundingClientRect();
        const popupWidth = 200;
        const windowWidth = window.innerWidth;
        let left = rect.left + window.scrollX;
        if (left + popupWidth > windowWidth) {
            left = rect.left + window.scrollX - popupWidth + btn.offsetWidth;
        }
        listActionsPopup.style.top = `${rect.bottom + window.scrollY + 5}px`;
        listActionsPopup.style.left = `${left}px`;
    });
});

// Đóng popup List actions khi nhấn nút close
document.querySelector('#taskPopup .popup-close').addEventListener('click', function () {
    listActionsPopup.style.display = 'none';
});

// Đóng popup List actions khi nhấn bên ngoài menu
document.addEventListener('click', function (e) {
    if (!listActionsPopup.contains(e.target) && !e.target.closest('.menu-btn')) {
        listActionsPopup.style.display = 'none';
    }
});

// Mở popup Add Task khi nhấn "Add Tasks"
document.querySelector('#taskPopup .dropdown-item[data-action="add-tasks"]').addEventListener('click', function () {
    listActionsPopup.style.display = 'none';
    addTaskPopup.style.display = 'block';
});

// Đóng popup Add Task khi nhấn nút close
document.querySelector('#addTaskPopup .popup-close').addEventListener('click', function () {
    addTaskPopup.style.display = 'none';
});

// Đóng popup Add Task khi nhấn Cancel
document.querySelector('#addTaskPopup .cancel-btn').addEventListener('click', function () {
    addTaskPopup.style.display = 'none';
});

// Đóng popup Add Task khi nhấn Add Task (tạm thời)
document.querySelector('#addTaskPopup .add-btn').addEventListener('click', function () {
    addTaskPopup.style.display = 'none';
});

// Tạo bảng trống "Title" khi nhấn "Add Board"
document.querySelector('#addBoardBtn').addEventListener('click', function () {
    const taskStatusContainer = document.querySelector('.task-status-container');
    const newBoard = document.createElement('div');
    newBoard.className = 'task-column';
    newBoard.innerHTML = `
        <h3>
            <div class="board-detail">
                <span class="board-title" contenteditable="false">Title</span>
                <span class="task-count">(0)</span>
            </div>
            <span>
                <button class="collapse-btn"><i class="fas fa-chevron-up"></i></button>
                <button class="menu-btn"><i class="fas fa-ellipsis-v"></i></button>
            </span>
        </h3>
    `;
    taskStatusContainer.appendChild(newBoard);
    newBoard.querySelector('.collapse-btn').addEventListener('click', function () {
        const column = this.closest('.task-column');
        column.classList.toggle('collapsed');
    });
    newBoard.querySelector('.menu-btn').addEventListener('click', function (e) {
        e.preventDefault();
        listActionsPopup.style.display = 'block';
        const rect = this.getBoundingClientRect();
        const popupWidth = 200;
        const windowWidth = window.innerWidth;
        let left = rect.left + window.scrollX;
        if (left + popupWidth > windowWidth) {
            left = rect.left + window.scrollX - popupWidth + this.offsetWidth;
        }
        listActionsPopup.style.top = `${rect.bottom + window.scrollY + 5}px`;
        listActionsPopup.style.left = `${left}px`;
    });
    const newBoardTitle = newBoard.querySelector('.board-title');
    newBoardTitle.addEventListener('click', enableBoardTitleEdit);
    newBoardTitle.addEventListener('blur', saveBoardTitle);
    newBoardTitle.addEventListener('keypress', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            this.blur();
        }
    });
    taskStatusContainer.scrollLeft = taskStatusContainer.scrollWidth;
});

function enableBoardTitleEdit() {
    this.setAttribute('contenteditable', 'true');
    this.focus();
}

function saveBoardTitle() {
    this.setAttribute('contenteditable', 'false');
    let newTitle = this.textContent.trim();
    if (!newTitle) this.textContent = 'Untitled';
}

document.querySelectorAll('.board-title').forEach(title => {
    title.addEventListener('click', enableBoardTitleEdit);
    title.addEventListener('blur', saveBoardTitle);
    title.addEventListener('keypress', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            this.blur();
        }
    });
});

// Mở popup Task Detail khi nhấp vào task card hoặc task row
document.querySelectorAll('.task-card, .task-row').forEach(element => {
    element.addEventListener('click', function (e) {
        e.preventDefault();
        taskDetailPopup.style.display = 'block';

        let taskTitle, taskDescription, taskDate, priority, assignee, deadline, labels;

        if (element.classList.contains('task-card')) {
            taskTitle = element.querySelector('.task-title')?.textContent || 'Untitled Task';
            taskDescription = element.getAttribute('data-description') || 'Add detailed description ...';
            taskDate = element.querySelector('.task-date')?.textContent || 'No Date';
            deadline = element.getAttribute('data-deadline') || 'May 11, 2025 7:30 PM';
            assignee = element.getAttribute('data-assignee') || 'Nguyenhuongsa62@gmail';
            priority = element.getAttribute('data-priority') || 'High';
            labels = element.getAttribute('data-labels') || '#FF4500'; // Lưu màu thay vì tên
        } else if (element.classList.contains('task-row')) {
            const cells = element.querySelectorAll('.task-cell');
            taskTitle = cells[0]?.textContent || 'Untitled Task';
            priority = cells[1]?.querySelector('.priority')?.textContent || 'Low';
            taskDate = cells[2]?.textContent || 'No Date';
            taskDescription = element.getAttribute('data-description') || 'Add detailed description ...';
            deadline = element.getAttribute('data-deadline') || 'May 11, 2025 7:30 PM';
            assignee = element.getAttribute('data-assignee') || 'Nguyenhuongsa62@gmail';
            labels = element.getAttribute('data-labels') || '#FF4500'; // Lưu màu thay vì tên
        }

        const titleInput = document.querySelector('.task-title-input');
        const descriptionInput = document.querySelector('.task-description-input');
        const labelsValue = document.querySelector('#taskDetailPopup .task-detail-values [data-type="labels"] .value');
        const deadlineValue = document.querySelector('#taskDetailPopup .task-detail-values [data-type="deadline"] .value');
        const assigneeValue = document.querySelector('#taskDetailPopup .task-detail-values [data-type="assignee"] .value');
        const priorityValue = document.querySelector('#taskDetailPopup .task-detail-values [data-type="priority"] .value');

        titleInput.value = taskTitle;
        descriptionInput.value = taskDescription;

        const dueDate = new Date(deadline);
        const currentDate = new Date('May 28, 2025 22:44:00 +07'); // 10:44 PM +07

        // Đảm bảo chỉ hiển thị một ô màu duy nhất trong .value
        labelsValue.innerHTML = ''; // Xóa toàn bộ nội dung cũ
        const selectedLabel = document.createElement('span');
        selectedLabel.className = 'selected-label';
        selectedLabel.style.backgroundColor = labels;
        selectedLabel.setAttribute('data-color', labels);
        labelsValue.appendChild(selectedLabel);
        selectedLabel.addEventListener('click', function () {
            document.querySelector('.labels-dropdown').style.display = 'block';
        });

        // Cập nhật các giá trị khác, không có icon
        deadlineValue.textContent = dueDate.toLocaleString('en-US', { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit', hour12: true }) + (dueDate < currentDate ? ' (Overdue)' : '');
        assigneeValue.textContent = assignee;
        priorityValue.textContent = priority;
    });
});

// Xử lý hiển thị/ẩn dropdown khi nhấn nút Labels
document.querySelector('.labels-btn').addEventListener('click', function (e) {
    e.preventDefault();
    const dropdown = document.querySelector('.labels-dropdown');
    dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
});

// Đóng dropdown khi nhấn nút close
document.querySelector('.labels-dropdown .dropdown-close').addEventListener('click', function () {
    const dropdown = document.querySelector('.labels-dropdown');
    dropdown.style.display = 'none';
});

// Xử lý chọn nhãn
document.querySelectorAll('.label-checkbox').forEach(checkbox => {
    checkbox.addEventListener('change', function () {
        const color = this.getAttribute('data-color');
        const labelsValue = document.querySelector('#taskDetailPopup .task-detail-values [data-type="labels"] .value');
        if (this.checked) {
            // Xóa tất cả checkbox khác và chỉ giữ một màu
            document.querySelectorAll('.label-checkbox').forEach(cb => {
                if (cb !== this) cb.checked = false;
            });
            labelsValue.innerHTML = ''; // Xóa toàn bộ nội dung cũ
            const selectedLabel = document.createElement('span');
            selectedLabel.className = 'selected-label';
            selectedLabel.style.backgroundColor = color;
            selectedLabel.setAttribute('data-color', color);
            labelsValue.appendChild(selectedLabel);
        } else {
            labelsValue.innerHTML = ''; // Nếu không chọn, xóa ô màu
        }
        document.querySelector('.labels-dropdown').style.display = 'none';
    });
});

// Xử lý thêm nhãn mới
document.querySelector('.add-label-btn').addEventListener('click', function () {
    const input = document.querySelector('.add-label-input');
    const color = input.value;
    if (color) {
        const dropdownContent = document.querySelector('.labels-dropdown .dropdown-content');
        const newLabel = document.createElement('label');
        newLabel.className = 'dropdown-item';
        newLabel.innerHTML = `<input type="checkbox" class="label-checkbox" data-color="${color}"><span class="color-box" style="background-color: ${color};"></span>`;
        dropdownContent.insertBefore(newLabel, document.querySelector('.add-label'));

        // Thêm sự kiện cho nhãn mới
        newLabel.querySelector('.label-checkbox').addEventListener('change', function () {
            const selectedColor = this.getAttribute('data-color');
            const labelsValue = document.querySelector('#taskDetailPopup .task-detail-values [data-type="labels"] .value');
            if (this.checked) {
                document.querySelectorAll('.label-checkbox').forEach(cb => {
                    if (cb !== this) cb.checked = false;
                });
                labelsValue.innerHTML = ''; // Xóa toàn bộ nội dung cũ
                const selectedLabel = document.createElement('span');
                selectedLabel.className = 'selected-label';
                selectedLabel.style.backgroundColor = selectedColor;
                selectedLabel.setAttribute('data-color', selectedColor);
                labelsValue.appendChild(selectedLabel);
            } else {
                labelsValue.innerHTML = ''; // Nếu không chọn, xóa ô màu
            }
            document.querySelector('.labels-dropdown').style.display = 'none';
        });
        input.value = '#FF4500'; // Reset về màu mặc định
    }
});

// Đóng dropdown khi nhấn bên ngoài
document.addEventListener('click', function (e) {
    const dropdown = document.querySelector('.labels-dropdown');
    const labelsBtn = document.querySelector('.labels-btn');
    if (!dropdown.contains(e.target) && !labelsBtn.contains(e.target)) {
        dropdown.style.display = 'none';
    }
});

// Đóng popup Task Detail khi nhấn nút close
document.querySelector('#taskDetailPopup .popup-close').addEventListener('click', function () {
    taskDetailPopup.style.display = 'none';
});

// Đóng popup khi nhấn bên ngoài
document.addEventListener('click', function (e) {
    if (!taskDetailPopup.contains(e.target) && !e.target.closest('.task-card') && !e.target.closest('.task-row')) {
        taskDetailPopup.style.display = 'none';
    }
    if (!addTaskPopup.contains(e.target) && !e.target.closest('.dropdown-item[data-action="add-tasks"]')) {
        addTaskPopup.style.display = 'none';
    }
});