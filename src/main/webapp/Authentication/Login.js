document.addEventListener("DOMContentLoaded", () => {
  const contextPath = document.body.getAttribute("data-context-path") || "";

  const loginForm = document.getElementById("loginForm");
  const emailInput = document.getElementById("email");
  const passwordInput = document.getElementById("password");
  const loginBtn = document.getElementById("loginBtn");
  const googleBtn = document.getElementById("googleBtn");
  const loadingSpinner = document.getElementById("loadingSpinner");
  const btnText = document.querySelector(".btn-text");

  // 🆕 Tự động điền email nếu có selectedAccount từ localStorage (Switch Account)
  const selectedAccount = JSON.parse(localStorage.getItem("selectedAccount"));
  if (selectedAccount && selectedAccount.email && emailInput) {
    emailInput.value = selectedAccount.email;
    // Nếu chỉ muốn dùng 1 lần, hãy bỏ comment dòng dưới
    // localStorage.removeItem("selectedAccount");
  }

  // ✅ Auto-login bằng refresh token nếu có
if (sessionStorage.getItem("switchingInProgress")) {
  sessionStorage.removeItem("switchingInProgress");

  const refreshToken = localStorage.getItem("switchGoogleRefreshToken");
  const email = localStorage.getItem("switchGoogleEmail");

  if (refreshToken && email) {
    fetch(contextPath + "/refresh-token-login", {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body:
        "refreshToken=" + encodeURIComponent(refreshToken) +
        "&email=" + encodeURIComponent(email)
    })
      .then((res) => {
        if (res.ok) {
          console.log("✅ Switch account auto-login success");
          localStorage.removeItem("switchGoogleRefreshToken");
          localStorage.removeItem("switchGoogleEmail");
          window.location.href = contextPath + "/Home/Home.jsp";
        } else {
          console.warn("❌ Failed to login with refresh token (status)", res.status);
          localStorage.removeItem("switchGoogleRefreshToken");
          localStorage.removeItem("switchGoogleEmail");
        }
      })
      .catch((err) => {
        console.error("❌ Auto-login error:", err);
      });
  }
}


  // --- Validate ---
  function validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  function validatePassword(password) {
    return password.length >= 6;
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
    loginBtn.disabled = true;
    btnText.style.display = "none";
    loadingSpinner.style.display = "block";
  }

  function hideLoading() {
    loginBtn.disabled = false;
    btnText.style.display = "inline-block";
    loadingSpinner.style.display = "none";
  }

  // Real-time validation
  emailInput.addEventListener("blur", () => {
    const email = emailInput.value.trim();
    if (email && !validateEmail(email)) {
      showError("email", "Please enter a valid email address");
    } else {
      hideError("email");
    }
  });

  passwordInput.addEventListener("blur", () => {
    const password = passwordInput.value;
    if (password && !validatePassword(password)) {
      showError("password", "Password must be at least 6 characters long");
    } else {
      hideError("password");
    }
  });

  emailInput.addEventListener("input", () => hideError("email"));
  passwordInput.addEventListener("input", () => hideError("password"));

  // Form submission
  loginForm.addEventListener("submit", function (e) {
    e.preventDefault();

    const email = emailInput.value.trim();
    const password = passwordInput.value;
    let isValid = true;

    if (!email) {
      showError("email", "Email is required");
      isValid = false;
    } else if (!validateEmail(email)) {
      showError("email", "Please enter a valid email address");
      isValid = false;
    }

    if (!password) {
      showError("password", "Password is required");
      isValid = false;
    } else if (!validatePassword(password)) {
      showError("password", "Password must be at least 6 characters long");
      isValid = false;
    }

    if (isValid) {
      showLoading();
      setTimeout(() => {
        hideLoading();
        loginForm.submit();
      }, 1000);
    }
  });

  // Google sign-in
  googleBtn.addEventListener("click", () => {
    alert("Google sign-in functionality would be implemented here");
  });

  // Enter key triggers form submit
  document.addEventListener("keypress", (e) => {
    if (
      e.key === "Enter" &&
      (emailInput === document.activeElement || passwordInput === document.activeElement)
    ) {
      loginForm.dispatchEvent(new Event("submit"));
    }
  });
});
