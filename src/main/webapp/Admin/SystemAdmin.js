import Chart from "https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.js";


document.addEventListener('DOMContentLoaded', () => {
    const lockedUsers = [
        {email: "user1@example.com", status: "Đã khóa"},
        {email: "user2@example.com", status: "Đã khóa"},
        {email: "user3@example.com", status: "Đã khóa"}
    ];

    const totalUsers = 100;
    const visits = 120000;

    document.getElementById("total-users").textContent = totalUsers;
    document.getElementById("locked-users").textContent = lockedUsers.length;
    document.getElementById("visits").textContent = visits.toLocaleString();

    const weeklyCtx = document.getElementById("weeklyUsersChart").getContext("2d");
    if (!weeklyCtx) {
    console.error("Không tìm thấy phần tử weeklyUsersChart");
}
    new Chart(weeklyCtx, {
        type: 'line',
        data: {
            labels: ["Tuần 1", "Tuần 2", "Tuần 3", "Tuần 4"],
            datasets: [{
                    label: "Người dùng mới",
                    data: [10, 25, 18, 35],
                    borderColor: "#3b82f6",
                    backgroundColor: "rgba(59, 130, 246, 0.1)",
                    tension: 0.4,
                    fill: true
                }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {display: false}
            }
        }
    });

    const hourlyCtx = document.getElementById("hourlyVisitsChart").getContext("2d");
    new Chart(hourlyCtx, {
        type: 'bar',
        data: {
            labels: ["0h", "3h", "6h", "9h", "12h", "15h", "18h", "21h"],
            datasets: [{
                    label: "Lượt truy cập",
                    data: [120, 80, 50, 150, 300, 200, 220, 160],
                    backgroundColor: "#10b981"
                }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {display: false}
            }
        }
    });
});
