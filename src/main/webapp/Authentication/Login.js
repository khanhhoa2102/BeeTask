document.addEventListener("DOMContentLoaded", () => {
  const contextPath = document.body.getAttribute("data-context-path") || ""
  const loginForm = document.getElementById("loginForm")
  const emailInput = document.getElementById("email")
  const passwordInput = document.getElementById("password")
  const loginBtn = document.getElementById("loginBtn")
  const googleBtn = document.getElementById("googleBtn")
  const loadingSpinner = document.getElementById("loadingSpinner")
  const btnText = document.querySelector(".btn-text")
  const togglePasswordBtn = document.getElementById("togglePassword")

  // Enhanced password visibility toggle
  if (togglePasswordBtn) {
    togglePasswordBtn.addEventListener("click", function () {
      const type = passwordInput.getAttribute("type") === "password" ? "text" : "password"
      passwordInput.setAttribute("type", type)

      // Update icon
      const eyeIcon = this.querySelector(".eye-icon")
      if (type === "text") {
        eyeIcon.innerHTML = `
                    <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/>
                    <line x1="1" y1="1" x2="23" y2="23"/>
                `
      } else {
        eyeIcon.innerHTML = `
                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                    <circle cx="12" cy="12" r="3"/>
                `
      }
    })
  }

  // Auto-fill email from localStorage
  const selectedAccount = JSON.parse(localStorage.getItem("selectedAccount"))
  if (selectedAccount && selectedAccount.email && emailInput) {
    emailInput.value = selectedAccount.email
    emailInput.focus()
  }

  // Enhanced auto-login functionality
  const switching = sessionStorage.getItem("switchingInProgress")
  if (switching) {
    sessionStorage.removeItem("switchingInProgress")
    const refreshToken = localStorage.getItem("switchGoogleRefreshToken")
    const googleEmail = localStorage.getItem("switchGoogleEmail")
    const localEmail = localStorage.getItem("switchEmail")
    const localPassword = localStorage.getItem("switchPassword")

    if (refreshToken && googleEmail) {
      handleGoogleAutoLogin(refreshToken, googleEmail)
    } else if (localEmail && localPassword) {
      handleLocalAutoLogin(localEmail, localPassword)
    }
  }

  // Enhanced validation functions
  function validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return emailRegex.test(email)
  }

  function validatePassword(password) {
    return password.length >= 6
  }

  function showError(inputId, message) {
    const errorElement = document.getElementById(inputId + "Error")
    if (errorElement) {
      errorElement.textContent = message
      errorElement.classList.add("show")

      // Add error styling to input
      const input = document.getElementById(inputId)
      if (input) {
        input.style.borderColor = "var(--error-color)"
        input.style.boxShadow = "0 0 0 3px rgba(239, 68, 68, 0.1)"
      }
    }
  }

  function hideError(inputId) {
    const errorElement = document.getElementById(inputId + "Error")
    if (errorElement) {
      errorElement.classList.remove("show")

      // Remove error styling from input
      const input = document.getElementById(inputId)
      if (input) {
        input.style.borderColor = ""
        input.style.boxShadow = ""
      }
    }
  }

  function showLoading() {
    loginBtn.disabled = true
    loginBtn.classList.add("loading")
  }

  function hideLoading() {
    loginBtn.disabled = false
    loginBtn.classList.remove("loading")
  }

  // Enhanced real-time validation
  emailInput.addEventListener("blur", () => {
    const email = emailInput.value.trim()
    if (email && !validateEmail(email)) {
      showError("email", "Please enter a valid email address")
    } else {
      hideError("email")
    }
  })

  emailInput.addEventListener("input", () => {
    hideError("email")
    // Add visual feedback for valid email
    const email = emailInput.value.trim()
    if (email && validateEmail(email)) {
      emailInput.style.borderColor = "var(--success-color)"
    }
  })

  passwordInput.addEventListener("blur", () => {
    const password = passwordInput.value
    if (password && !validatePassword(password)) {
      showError("password", "Password must be at least 6 characters long")
    } else {
      hideError("password")
    }
  })

  passwordInput.addEventListener("input", () => {
    hideError("password")
    // Add visual feedback for valid password
    const password = passwordInput.value
    if (password && validatePassword(password)) {
      passwordInput.style.borderColor = "var(--success-color)"
    }
  })

  // Enhanced form submission
  loginForm.addEventListener("submit", (e) => {
    e.preventDefault()

    const email = emailInput.value.trim()
    const password = passwordInput.value
    let isValid = true

    // Reset previous errors
    hideError("email")
    hideError("password")

    // Validate email
    if (!email) {
      showError("email", "Email is required")
      isValid = false
    } else if (!validateEmail(email)) {
      showError("email", "Please enter a valid email address")
      isValid = false
    }

    // Validate password
    if (!password) {
      showError("password", "Password is required")
      isValid = false
    } else if (!validatePassword(password)) {
      showError("password", "Password must be at least 6 characters long")
      isValid = false
    }

    if (isValid) {
      showLoading()
      // Add a small delay for better UX
      setTimeout(() => {
        loginForm.submit()
      }, 800)
    } else {
      // Focus on first error field
      const firstError = document.querySelector(".error-text.show")
      if (firstError) {
        const fieldId = firstError.id.replace("Error", "")
        const field = document.getElementById(fieldId)
        if (field) {
          field.focus()
        }
      }
    }
  })

  // Enhanced Google login with loading state
  googleBtn.addEventListener("click", (e) => {
    e.preventDefault()
    googleBtn.style.opacity = "0.7"
    googleBtn.style.cursor = "not-allowed"

    // Add loading text
    const originalText = googleBtn.innerHTML
    googleBtn.innerHTML = `
            <div class="loader-spinner" style="width: 1rem; height: 1rem; border-width: 2px; border-color: #6b7280 transparent #6b7280 transparent;"></div>
            <span>Connecting to Google...</span>
        `

    // Proceed with Google OAuth
    setTimeout(() => {
      window.location.href = googleBtn.getAttribute("onclick").match(/'([^']+)'/)[1]
    }, 1000)
  })

  // Enhanced keyboard navigation
  document.addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      if (emailInput === document.activeElement) {
        passwordInput.focus()
      } else if (passwordInput === document.activeElement) {
        loginForm.dispatchEvent(new Event("submit"))
      }
    }
  })

  // Auto-login helper functions
  function handleGoogleAutoLogin(refreshToken, googleEmail) {
    showLoading()
    fetch(contextPath + "/refresh-token-login", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: `refreshToken=${encodeURIComponent(refreshToken)}&email=${encodeURIComponent(googleEmail)}`,
    })
      .then((res) => {
        if (res.ok) {
          console.log("✅ Google auto-login successful")
          localStorage.removeItem("switchGoogleRefreshToken")
          localStorage.removeItem("switchGoogleEmail")
          window.location.href = contextPath + "/Home/Home.jsp"
        } else {
          console.warn("❌ Google auto-login failed", res.status)
          localStorage.removeItem("switchGoogleRefreshToken")
          localStorage.removeItem("switchGoogleEmail")
          hideLoading()
        }
      })
      .catch((err) => {
        console.error("❌ Google auto-login error:", err)
        hideLoading()
      })
  }

  function handleLocalAutoLogin(localEmail, localPassword) {
    if (emailInput && passwordInput && loginForm) {
      emailInput.value = localEmail
      passwordInput.value = localPassword
      localStorage.removeItem("switchEmail")
      localStorage.removeItem("switchPassword")

      setTimeout(() => {
        showLoading()
        loginForm.submit()
      }, 500)
    }
  }

  // Add smooth animations for form interactions
  const formInputs = document.querySelectorAll(".form-input")
  formInputs.forEach((input) => {
    input.addEventListener("focus", function () {
      this.parentElement.style.transform = "translateY(-2px)"
      this.parentElement.style.transition = "transform 0.2s ease"
    })

    input.addEventListener("blur", function () {
      this.parentElement.style.transform = "translateY(0)"
    })
  })

  // Add floating animation to background elements
  function addFloatingAnimation() {
    const floatingCards = document.querySelectorAll(".floating-card")
    floatingCards.forEach((card, index) => {
      card.style.animationDelay = `${index * 2}s`
      card.style.animationDuration = `${8 + index * 2}s`
    })
  }

  addFloatingAnimation()

  // Add intersection observer for animations
  const observerOptions = {
    threshold: 0.1,
    rootMargin: "0px 0px -50px 0px",
  }

  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.style.opacity = "1"
        entry.target.style.transform = "translateY(0)"
      }
    })
  }, observerOptions)

  // Observe form elements for entrance animations
  const formElements = document.querySelectorAll(".form-group, .primary-btn, .google-btn")
  formElements.forEach((el, index) => {
    el.style.opacity = "0"
    el.style.transform = "translateY(20px)"
    el.style.transition = `opacity 0.6s ease ${index * 0.1}s, transform 0.6s ease ${index * 0.1}s`
    observer.observe(el)
  })
})
