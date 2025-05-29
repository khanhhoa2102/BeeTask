document.addEventListener('DOMContentLoaded', function () {
    const sidebar = document.querySelector('.sidebar');
    const toggleBtn = document.querySelector('.toggle-btn');
    const mainContent = document.querySelector('.main-content');
    const dragHandle = document.querySelector('.drag-handle');
    const darkModeToggle = document.querySelector('#darkModeToggle');
    const darkLabel = document.querySelector('.dark-label');
    const contentWrapper = document.querySelector('.content-wrapper');

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

        // Cập nhật width và margin-left cho sidebar và content-wrapper
        if (isCollapsed) {
            sidebar.style.width = '60px';
            contentWrapper.style.marginLeft = '60px';
            contentWrapper.style.width = 'calc(100% - 60px)';
            mainContent.style.marginLeft = '80px';
            mainContent.style.width = 'calc(100% - 80px)';
        } else {
            sidebar.style.width = '180px';
            contentWrapper.style.marginLeft = '180px';
            contentWrapper.style.width = 'calc(100% - 180px)';
            mainContent.style.marginLeft = '200px';
            mainContent.style.width = 'calc(100% - 200px)';
        }
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
            contentWrapper.style.marginLeft = newWidth + 'px';
            contentWrapper.style.width = `calc(100% - ${newWidth}px)`;
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

    // Collapse button functionality for task columns (nếu có)
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
        contentWrapper.style.marginLeft = '60px';
        contentWrapper.style.width = 'calc(100% - 60px)';
        mainContent.style.marginLeft = '80px';
        mainContent.style.width = 'calc(100% - 80px)';
    }

    // Loại bỏ đoạn fetch header-sidebar.html vì nó không cần thiết trong trường hợp này
    // (Nếu bạn cần load header-sidebar.html, hãy thêm lại và điều chỉnh đường dẫn)
});