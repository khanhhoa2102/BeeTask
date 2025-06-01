// DashboardProjectScript.js

// Khởi tạo các sự kiện khi DOM được tải
document.addEventListener('DOMContentLoaded', () => {
    initializeSidebarToggle();
    initializeCharts();
});

// Bật/tắt thu nhỏ sidebar
function initializeSidebarToggle() {
    const toggleButtons = document.querySelectorAll('.toggle-btn, .sidebar-toggle');
    const sidebar = document.querySelector('.sidebar');

    if (!sidebar) {
        console.warn('Phần tử .sidebar không tồn tại.');
        return;
    }

    toggleButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            sidebar.classList.toggle('collapsed');
            console.log('Sidebar toggled. Collapsed:', sidebar.classList.contains('collapsed'));
        });
    });
}

// Lấy màu sắc biểu đồ dựa trên chế độ
function getChartColors() {
    const isDarkMode = document.body.classList.contains('dark-mode');
    console.log('Chế độ hiện tại:', isDarkMode ? 'Dark Mode' : 'Light Mode');
    return {
        userChart: {
            // Màu riêng cho từng cột trong userChart
            backgroundColors: isDarkMode 
                ? ['#60a5fa', '#34d399', '#f87171'] // Xanh dương, xanh lá, đỏ cho dark mode
                : ['#3b82f6', '#10b981', '#ef4444'], // Đậm hơn cho light mode
        },
        timeChart: {
            teamA: isDarkMode ? '#facc15' : '#eab308', // Vàng
            teamB: isDarkMode ? '#22c55e' : '#16a34a', // Xanh lá
            teamC: isDarkMode ? '#ef4444' : '#dc2626', // Đỏ
        },
        taskChart: {
            // Màu riêng cho từng cột trong taskChart
            backgroundColors: isDarkMode 
                ? ['#a78bfa', '#f472b6', '#4ade80'] // Tím, hồng, xanh lá cho dark mode
                : ['#8b5cf6', '#ec4899', '#22c55e'], // Đậm hơn cho light mode
        },
    };
}

// Khởi tạo hoặc cập nhật các biểu đồ
function updateCharts() {
    const colors = getChartColors();
    console.log('Cập nhật biểu đồ với màu:', colors);

    // Biểu đồ tham gia người dùng
    const userChart = new Chart(document.getElementById('userChart'), {
        type: 'bar',
        data: {
            labels: ['Hoa Chúc', 'Hữu Sơn', 'Xuân Sen'],
            datasets: [
                {
                    label: 'Tham gia',
                    data: [4, 2, 6],
                    backgroundColor: colors.userChart.backgroundColors, // Màu riêng cho từng cột
                },
            ],
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true } },
        },
    });

    // Biểu đồ động lực thời gian
    const timeChart = new Chart(document.getElementById('timeChart'), {
        type: 'line',
        data: {
            labels: ['Tuần 1', 'Tuần 2', 'Tuần 3', 'Tuần 4'],
            datasets: [
                {
                    label: 'Đội A',
                    data: [2, 4, 3, 5],
                    borderColor: colors.timeChart.teamA,
                    tension: 0.3,
                },
                {
                    label: 'Đội B',
                    data: [1, 2, 5, 6],
                    borderColor: colors.timeChart.teamB,
                    tension: 0.3,
                },
                {
                    label: 'Đội C',
                    data: [1, 3, 4, 2],
                    borderColor: colors.timeChart.teamC,
                    tension: 0.3,
                },
            ],
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true } },
        },
    });

    // Biểu đồ số lượng nhiệm vụ
    const taskChart = new Chart(document.getElementById('taskChart'), {
        type: 'bar',
        data: {
            labels: ['Nhiệm vụ 1', 'Nhiệm vụ 2', 'Nhiệm vụ 3'],
            datasets: [
                {
                    label: 'Số lượng nhiệm vụ',
                    data: [3, 2, 5],
                    backgroundColor: colors.taskChart.backgroundColors, // Màu riêng cho từng cột
                },
            ],
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true } },
        },
    });

    return { userChart, timeChart, taskChart };
}

// Khởi tạo và xử lý thay đổi chế độ cho biểu đồ
function initializeCharts() {
    // Khởi tạo biểu đồ ban đầu
    let charts = updateCharts();

    // Kiểm tra trạng thái ban đầu của dark mode
    const darkModeToggle = document.getElementById('darkModeToggle');
    if (darkModeToggle) {
        // Đặt trạng thái ban đầu dựa trên checkbox
        if (darkModeToggle.checked) {
            document.body.classList.add('dark-mode');
        } else {
            document.body.classList.remove('dark-mode');
        }
        console.log('Trạng thái ban đầu darkModeToggle:', darkModeToggle.checked);

        // Lắng nghe sự kiện change của darkModeToggle
        darkModeToggle.addEventListener('change', () => {
            document.body.classList.toggle('dark-mode');
            console.log('darkModeToggle changed. Dark Mode:', document.body.classList.contains('dark-mode'));
            // Hủy và cập nhật biểu đồ
            charts.userChart.destroy();
            charts.timeChart.destroy();
            charts.taskChart.destroy();
            charts = updateCharts();
        });
    } else {
        console.warn('Phần tử #darkModeToggle không tồn tại. Light mode/dark mode toggle sẽ không hoạt động.');
    }

    // Theo dõi thay đổi lớp dark-mode trên body
    const observer = new MutationObserver(() => {
        console.log('Lớp dark-mode trên body thay đổi:', document.body.classList.contains('dark-mode'));
        charts.userChart.destroy();
        charts.timeChart.destroy();
        charts.taskChart.destroy();
        charts = updateCharts();
    });
    observer.observe(document.body, { attributes: true, attributeFilter: ['class'] });
}