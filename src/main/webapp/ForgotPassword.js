document.addEventListener("DOMContentLoaded", () => {
  const forgotForm = document.getElementById("forgotForm");
  const emailInput = document.getElementById("email");
  const sendBtn = document.getElementById("sendBtn");
  const loadingSpinner = document.getElementById("loadingSpinner");
  const btnText = document.querySelector(".btn-text");

  // Form validation
  function validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  function showError(inputId, message) {
    const errorElement = document.getElementById(inputId + "Error");
    errorElement.textContent = message;
    errorElement.classList.add("show");
  }

  function hideError(inputId) {
    const errorElement = document.getElementById(inputId + "Error");
    errorElement.classList.remove("show");
  }

  function showLoading() {
    sendBtn.disabled = true;
    btnText.style.display = "none";
    loadingSpinner.style.display = "block";
  }

  function hideLoading() {
    sendBtn.disabled = false;
    btnText.style.display = "inline-block";
    loadingSpinner.style.display = "none";
  }

  // Form submission
  forgotForm.addEventListener("submit", (e) => {
    e.preventDefault(); // Chặn mặc định tạm thời để xử lý

    const email = emailInput.value.trim();
    let isValid = true;

    if (!email) {
      showError("email", "Email is required");
      isValid = false;
    } else if (!validateEmail(email)) {
      showError("email", "Please enter a valid email address");
      isValid = false;
    } else {
      hideError("email");
    }

    if (isValid) {
      showLoading();

      setTimeout(() => {
        hideLoading();
        forgotForm.submit(); // ✅ Gửi form thật đến servlet sau xử lý xong
      }, 500); // delay nhẹ để thấy loading, hoặc dùng 0 nếu muốn nhanh
    }
  });

  // Real-time validation
  emailInput.addEventListener("blur", function () {
    const email = this.value.trim();
    if (email && !validateEmail(email)) {
      showError("email", "Please enter a valid email address");
    } else {
      hideError("email");
    }
  });

  emailInput.addEventListener("input", () => {
    hideError("email");
  });

  // Enter key support
  emailInput.addEventListener("keypress", (e) => {
    if (e.key === "Enter") {
      forgotForm.dispatchEvent(new Event("submit"));
    }
  });

  // Auto focus
  emailInput.focus();
});
