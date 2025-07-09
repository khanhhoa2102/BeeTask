document.addEventListener("DOMContentLoaded", () => {
  const contextPath = document.body.getAttribute("data-context-path") || "";

  const loginForm = document.getElementById("loginForm");
  const emailInput = document.getElementById("email");
  const passwordInput = document.getElementById("password");
  const loginBtn = document.getElementById("loginBtn");
  const googleBtn = document.getElementById("googleBtn");
  const loadingSpinner = document.getElementById("loadingSpinner");
  const btnText = document.querySelector(".btn-text");
  const togglePasswordBtn = document.getElementById("togglePassword");

  // Toggle password visibility
  if (togglePasswordBtn) {
    togglePasswordBtn.addEventListener("click", function () {
      const type = passwordInput.getAttribute("type") === "password" ? "text" : "password";
      passwordInput.setAttribute("type", type);
      this.querySelector("svg").style.opacity = type === "text" ? 0.6 : 1;
    });
  }

  // Auto-fill email
  const selectedAccount = JSON.parse(localStorage.getItem("selectedAccount"));
  if (selectedAccount && selectedAccount.email && emailInput) {
    emailInput.value = selectedAccount.email;
  }

  // ✅ Auto-login when switching account (Google or Local)
  const switching = sessionStorage.getItem("switchingInProgress");
  if (switching) {
    sessionStorage.removeItem("switchingInProgress");

    const refreshToken = localStorage.getItem("switchGoogleRefreshToken");
    const googleEmail = localStorage.getItem("switchGoogleEmail");
    const localEmail = localStorage.getItem("switchEmail");
    const localPassword = localStorage.getItem("switchPassword");

    if (refreshToken && googleEmail) {
      // Auto-login via refresh token (Google)
      fetch(contextPath + "/refresh-token-login", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body:
          "refreshToken=" + encodeURIComponent(refreshToken) +
          "&email=" + encodeURIComponent(googleEmail)
      })
        .then((res) => {
          if (res.ok) {
            console.log("✅ Switch account auto-login success");
            localStorage.removeItem("switchGoogleRefreshToken");
            localStorage.removeItem("switchGoogleEmail");
            window.location.href = contextPath + "/Home/Home.jsp";
          } else {
            console.warn("❌ Failed to login with refresh token", res.status);
            localStorage.removeItem("switchGoogleRefreshToken");
            localStorage.removeItem("switchGoogleEmail");
          }
        })
        .catch((err) => {
          console.error("❌ Auto-login error:", err);
        });
    } else if (localEmail && localPassword) {
      // ✅ FIX: Auto-login for local account (bằng form.submit)
      if (emailInput && passwordInput && loginForm) {
        emailInput.value = localEmail;
        passwordInput.value = localPassword;
        localStorage.removeItem("switchEmail");
        localStorage.removeItem("switchPassword");

        setTimeout(() => {
          showLoading();
          loginForm.submit(); // 🔥 submit trực tiếp form
        }, 500);
      }
    }
  }

  // Validation
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

  // Realtime validation
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

  // ✅ Form submission
  loginForm.addEventListener("submit", function (e) {
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

    if (!isValid) {
      e.preventDefault(); // Prevent form submit only if invalid
    } else {
      e.preventDefault(); // Always prevent default first
      showLoading();
      setTimeout(() => loginForm.submit(), 1000); // Delay optional
    }
  });

  // Dummy Google login
  googleBtn.addEventListener("click", () => {
    alert("Google sign-in functionality would be implemented here");
  });

  // Press Enter to submit
  document.addEventListener("keypress", (e) => {
    if (
      e.key === "Enter" &&
      (emailInput === document.activeElement || passwordInput === document.activeElement)
    ) {
      loginForm.dispatchEvent(new Event("submit"));
    }
  });
});
