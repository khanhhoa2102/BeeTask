document.addEventListener('DOMContentLoaded', function () {
    const sidebar = document.querySelector('.sidebar');
    const toggleBtn = document.querySelector('.toggle-btn');
    const mainContent = document.querySelector('.main-content');
    const dragHandle = document.querySelector('.drag-handle');
    const darkModeToggle = document.querySelector('#darkModeToggle');
    const darkLabel = document.querySelector('.dark-label');

    // Kiểm tra trạng thái Dark Mode từ localStorage
    const isDarkMode = localStorage.getItem('darkMode') === 'enabled';
    if (isDarkMode) {
        document.body.classList.add('dark-mode');
        darkModeToggle.checked = true;
        darkLabel.textContent = 'Light Mode';
    } else {
        darkLabel.textContent = 'Dark Mode';
    }

    // Toggle button functionality for sidebar
    toggleBtn.addEventListener('click', function () {
        sidebar.classList.toggle('collapsed');
        const isCollapsed = sidebar.classList.contains('collapsed');
        toggleBtn.classList.toggle('collapsed', isCollapsed);
        toggleBtn.querySelector('i').classList.toggle('fa-bars', !isCollapsed);
        toggleBtn.querySelector('i').classList.toggle('fa-angle-left', isCollapsed);

        sidebar.style.width = isCollapsed ? '60px' : '180px';
        mainContent.style.marginLeft = isCollapsed ? '80px' : '200px';
        mainContent.style.width = isCollapsed ? 'calc(100% - 80px)' : 'calc(100% - 200px)';
    });

    // Drag functionality for sidebar
    let isDragging = false;

    dragHandle.addEventListener('mousedown', function (e) {
        isDragging = true;
        e.preventDefault();
    });

    document.addEventListener('mousemove', function (e) {
        if (!isDragging) return;

        const newWidth = e.clientX;
        if (newWidth >= 60 && newWidth <= 300) {
            sidebar.style.width = newWidth + 'px';
            mainContent.style.marginLeft = newWidth + 20 + 'px';
            mainContent.style.width = `calc(100% - ${newWidth + 20}px)`;

            if (newWidth <= 100) {
                sidebar.classList.add('collapsed');
                toggleBtn.classList.add('collapsed');
                toggleBtn.querySelector('i').classList.remove('fa-bars');
                toggleBtn.querySelector('i').classList.add('fa-angle-left');
            } else {
                sidebar.classList.remove('collapsed');
                toggleBtn.classList.remove('collapsed');
                toggleBtn.querySelector('i').classList.add('fa-bars');
                toggleBtn.querySelector('i').classList.remove('fa-angle-left');
            }
        }
    });

    document.addEventListener('mouseup', function () {
        isDragging = false;
    });

    // Dark Mode toggle functionality
    darkModeToggle.addEventListener('change', function () {
        if (this.checked) {
            document.body.classList.add('dark-mode');
            localStorage.setItem('darkMode', 'enabled');
            darkLabel.textContent = 'Light Mode';
        } else {
            document.body.classList.remove('dark-mode');
            localStorage.setItem('darkMode', 'disabled');
            darkLabel.textContent = 'Dark Mode';
        }
    });

    // Collapse button functionality for task columns
    document.querySelectorAll('.collapse-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            btn.closest('.task-column').classList.toggle('collapsed');
        });
    });

    // Ensure sidebar is collapsed on small screens by default
    if (window.innerWidth <= 600) {
        sidebar.classList.add('collapsed');
        toggleBtn.classList.add('collapsed');
        toggleBtn.querySelector('i').classList.remove('fa-bars');
        toggleBtn.querySelector('i').classList.add('fa-angle-left');
        sidebar.style.width = '60px';
        mainContent.style.marginLeft = '80px';
        mainContent.style.width = 'calc(100% - 80px)';
    }
});