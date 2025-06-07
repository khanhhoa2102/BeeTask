document.addEventListener('DOMContentLoaded', () => {
    initializeDarkMode();
    initializeSidebarToggle();
    initializeSidebarResize();
});

function initializeDarkMode() {
    const darkModeToggle = document.getElementById('darkModeToggle');
    if (!darkModeToggle) {
        console.warn('Phần tử #darkModeToggle không tồn tại.');
        return;
    }

    // Áp dụng theme từ localStorage
    const savedTheme = localStorage.getItem('theme') || 'dark-mode';
    if (savedTheme === 'dark-mode') {
        document.body.classList.add('dark-mode');
        darkModeToggle.checked = true;
    } else {
        document.body.classList.remove('dark-mode');
        darkModeToggle.checked = false;
    }

    darkModeToggle.addEventListener('change', () => {
        const isDarkMode = darkModeToggle.checked;
        document.body.classList.toggle('dark-mode', isDarkMode);
        localStorage.setItem('theme', isDarkMode ? 'dark-mode' : 'light-mode');
        console.log('Dark Mode:', isDarkMode);
    });
}

function initializeSidebarToggle() {
    const toggleButton = document.querySelector('.toggle-btn');
    const sidebar = document.querySelector('.sidebar');

    if (!sidebar || !toggleButton) {
        console.warn('Phần tử .sidebar hoặc .toggle-btn không tồn tại.');
        return;
    }

    // Áp dụng trạng thái sidebar từ localStorage
    const savedSidebarState = localStorage.getItem('sidebarState') || 'expanded';
    if (savedSidebarState === 'collapsed') {
        sidebar.classList.add('collapsed');
    } else {
        sidebar.classList.remove('collapsed');
    }

    toggleButton.addEventListener('click', () => {
        sidebar.classList.toggle('collapsed');
        const isCollapsed = sidebar.classList.contains('collapsed');
        localStorage.setItem('sidebarState', isCollapsed ? 'collapsed' : 'expanded');
        console.log('Sidebar toggled. Collapsed:', isCollapsed);
    });
}

function initializeSidebarResize() {
    const sidebar = document.querySelector('.sidebar');
    const dragHandle = document.querySelector('.drag-handle');
    let isResizing = false;

    if (!sidebar || !dragHandle) {
        console.warn('Phần tử .sidebar hoặc .drag-handle không tồn tại.');
        return;
    }

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
}