// Dark Mode Toggle
document.getElementById('darkModeToggle').addEventListener('change', function () {
    document.body.classList.toggle('dark-mode');
});

// Sidebar Collapse Toggle
document.querySelector('.toggle-btn').addEventListener('click', function () {
    document.querySelector('.sidebar').classList.toggle('collapsed');
});

// Sidebar Resizing Functionality
const sidebar = document.querySelector('.sidebar');
const dragHandle = document.querySelector('.drag-handle');
let isResizing = false;

dragHandle.addEventListener('mousedown', function (e) {
    isResizing = true;
    document.addEventListener('mousemove', resizeSidebar);
    document.addEventListener('mouseup', stopResize);
});

function resizeSidebar(e) {
    if (isResizing) {
        let newWidth = e.clientX;
        if (newWidth >= 60 && newWidth <= 300) {
            sidebar.style.width = `${newWidth}px`;
            const mainContent = document.querySelector('.main-content');
            mainContent.style.marginLeft = `${newWidth + 20}px`;
            mainContent.style.width = `calc(100% - ${newWidth + 20}px)`;
        }
    }
}

function stopResize() {
    isResizing = false;
    document.removeEventListener('mousemove', resizeSidebar);
    document.removeEventListener('mouseup', stopResize);
}