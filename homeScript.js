// ========= DARK MODE TOGGLE ========= //
const darkToggle = document.getElementById('darkModeToggle');

if (darkToggle) {
  // Khôi phục trạng thái lưu trữ
  const savedTheme = localStorage.getItem('theme');
  if (savedTheme === 'light') {
    document.body.classList.remove('dark-mode');
    darkToggle.checked = false;
  } else {
    document.body.classList.add('dark-mode');
    darkToggle.checked = true;
  }

  // Khi người dùng thay đổi trạng thái
  darkToggle.addEventListener('change', () => {
    if (darkToggle.checked) {
      document.body.classList.add('dark-mode');
      localStorage.setItem('theme', 'dark');
    } else {
      document.body.classList.remove('dark-mode');
      localStorage.setItem('theme', 'light');
    }
  });
}

// ========= SIDEBAR COLLAPSE ========= //
const toggleSidebarBtn = document.querySelector('.toggle-btn');
const sidebar = document.querySelector('.sidebar');
if (toggleSidebarBtn && sidebar) {
  toggleSidebarBtn.addEventListener('click', () => {
    sidebar.classList.toggle('collapsed');

    const mainContent = document.querySelector('.main-content');
    const contentWrapper = document.querySelector('.content-wrapper');
    if (sidebar.classList.contains('collapsed')) {
      if (mainContent) {
        mainContent.style.marginLeft = '80px';
        mainContent.style.width = 'calc(100% - 80px)';
      }
      if (contentWrapper) {
        contentWrapper.style.marginLeft = '80px';
      }
    } else {
      if (mainContent) {
        mainContent.style.marginLeft = '200px';
        mainContent.style.width = 'calc(100% - 200px)';
      }
      if (contentWrapper) {
        contentWrapper.style.marginLeft = '200px';
      }
    }
  });
}

// ========= NÚT 3 CHẤM ========= //
document.querySelectorAll('.menu-dot').forEach(btn => {
  btn.addEventListener('click', function (e) {
    e.stopPropagation();
    alert("Menu actions chưa được cài đặt.");
  });
});

// ========= GO / MOVE / DISMISS ========= //
document.querySelectorAll('.go-btn, .move-btn').forEach(btn => {
  btn.addEventListener('click', function () {
    alert("Tính năng chuyển dự án chưa được triển khai.");
  });
});

document.querySelectorAll('.dismiss-btn').forEach(btn => {
  btn.addEventListener('click', function () {
    const card = this.closest('.task-card');
    if (card) {
      card.remove();
    }
  });
});
