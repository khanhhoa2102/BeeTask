document.addEventListener('DOMContentLoaded', () => {
  // Giả lập dữ liệu
  const lockedUsers = [
    { email: "user1@example.com", status: "Đã khóa" },
    { email: "user2@example.com", status: "Đã khóa" },
    { email: "user3@example.com", status: "Đã khóa" }
  ];

  const totalUsers = 100;
  const visits = 120000;

  // Cập nhật thống kê
  document.getElementById("total-users").textContent = totalUsers;
  document.getElementById("locked-users").textContent = lockedUsers.length;
  document.getElementById("visits").textContent = visits.toLocaleString();

  // Render danh sách người dùng bị khóa
  const tableBody = document.getElementById("locked-user-list");

  lockedUsers.forEach(user => {
    const row = document.createElement("tr");

    row.innerHTML = `
      <td>${user.email}</td>
      <td>${user.status}</td>
      <td><button class="unlock-btn">Mở khóa</button></td>
    `;

    row.querySelector(".unlock-btn").addEventListener("click", () => {
      alert(`Đã mở khóa ${user.email}`);
      row.remove(); // Giả lập xoá khỏi danh sách
    });

    tableBody.appendChild(row);
  });
});
