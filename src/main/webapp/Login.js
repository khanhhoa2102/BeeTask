document.addEventListener("DOMContentLoaded", () => {
  const loginForm = document.getElementById("loginForm")
  const emailInput = document.getElementById("email")
  const passwordInput = document.getElementById("password")
  const loginBtn = document.getElementById("loginBtn")
  const googleBtn = document.getElementById("googleBtn")
  const loadingSpinner = document.getElementById("loadingSpinner")
  const btnText = document.querySelector(".btn-text")

  // Show server-side error if exists
  if (typeof errorMessage !== "undefined" && errorMessage.trim() !== "") {
    const errorDiv = document.createElement("div")
    errorDiv.className = "alert-error"
    errorDiv.textContent = errorMessage

    const container = document.querySelector(".login-card")
    container.insertBefore(errorDiv, loginForm)

    // Auto-hide after 5 seconds
    setTimeout(() => {
      errorDiv.style.transition = "opacity 0.5s ease"
      errorDiv.style.opacity = "0"
      setTimeout(() => errorDiv.remove(), 500)
    }, 5000)
  }

  function validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return emailRegex.test(email)
  }

  function validatePassword(password) {
    return password.length >= 6
  }

  function showError(inputId, message) {
    const errorElement = document.getElementById(inputId + "Error")
    errorElement.textContent = message
    errorElement.classList.add("show")
  }

  function hideError(inputId) {
    const errorElement = document.getElementById(inputId + "Error")
    errorElement.classList.remove("show")
  }

  function showLoading() {
    loginBtn.disabled = true
    btnText.style.display = "none"
    loadingSpinner.style.display = "block"
  }

  function hideLoading() {
    loginBtn.disabled = false
    btnText.style.display = "inline-block"
    loadingSpinner.style.display = "none"
  }

  // Real-time validation
  emailInput.addEventListener("blur", function () {
    const email = this.value.trim()
    if (email && !validateEmail(email)) {
      showError("email", "Please enter a valid email address")
    } else {
      hideError("email")
    }
  })

  passwordInput.addEventListener("blur", function () {
    const password = this.value
    if (password && !validatePassword(password)) {
      showError("password", "Password must be at least 6 characters long")
    } else {
      hideError("password")
    }
  })

  // Clear errors on input
  emailInput.addEventListener("input", () => {
    hideError("email")
  })

  passwordInput.addEventListener("input", () => {
    hideError("password")
  })

  // Form submission
  loginForm.addEventListener("submit", function (e) {
    e.preventDefault()

    const email = emailInput.value.trim()
    const password = passwordInput.value
    let isValid = true

    if (!email) {
      showError("email", "Email is required")
      isValid = false
    } else if (!validateEmail(email)) {
      showError("email", "Please enter a valid email address")
      isValid = false
    } else {
      hideError("email")
    }

    if (!password) {
      showError("password", "Password is required")
      isValid = false
    } else if (!validatePassword(password)) {
      showError("password", "Password must be at least 6 characters long")
      isValid = false
    } else {
      hideError("password")
    }

    if (isValid) {
      showLoading()
      setTimeout(() => {
        hideLoading()
        this.submit()
      }, 1000)
    }
  })

  // Google sign-in button
  googleBtn.addEventListener("click", () => {
    // You can replace this with actual redirect to Google login
    alert("Google sign-in functionality would be implemented here")
  })

  // Enter key support
  document.addEventListener("keypress", (e) => {
    if (e.key === "Enter" && (emailInput === document.activeElement || passwordInput === document.activeElement)) {
      loginForm.dispatchEvent(new Event("submit"))
    }
  })
})
