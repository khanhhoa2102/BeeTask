document.addEventListener("DOMContentLoaded", () => {
  const contextPath = document.body.getAttribute("data-context-path") || ""
  const forgotForm = document.getElementById("forgotForm")
  const emailInput = document.getElementById("email")
  const sendBtn = document.getElementById("sendBtn")
  const loadingSpinner = document.getElementById("loadingSpinner")
  const btnText = document.querySelector(".btn-text")

  // Enhanced validation functions
  function validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return emailRegex.test(email)
  }

  function showError(inputId, message) {
    const errorElement = document.getElementById(inputId + "Error")
    if (errorElement) {
      errorElement.textContent = message
      errorElement.classList.add("show")

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

      const input = document.getElementById(inputId)
      if (input) {
        input.style.borderColor = ""
        input.style.boxShadow = ""
      }
    }
  }

  function showLoading() {
    sendBtn.disabled = true
    sendBtn.classList.add("loading")
  }

  function hideLoading() {
    sendBtn.disabled = false
    sendBtn.classList.remove("loading")
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
    const email = emailInput.value.trim()
    if (email && validateEmail(email)) {
      emailInput.style.borderColor = "var(--success-color)"
    }
  })

  // Enhanced form submission
  forgotForm.addEventListener("submit", (e) => {
    e.preventDefault()

    const email = emailInput.value.trim()
    let isValid = true

    // Reset previous errors
    hideError("email")

    // Validate email
    if (!email) {
      showError("email", "Email address is required")
      isValid = false
    } else if (!validateEmail(email)) {
      showError("email", "Please enter a valid email address")
      isValid = false
    }

    if (isValid) {
      showLoading()

      // Add a delay to show loading state, then submit
      setTimeout(() => {
        forgotForm.submit()
      }, 800)
    } else {
      // Focus on email field if there's an error
      emailInput.focus()
    }
  })

  // Enhanced keyboard navigation
  emailInput.addEventListener("keypress", (e) => {
    if (e.key === "Enter") {
      forgotForm.dispatchEvent(new Event("submit"))
    }
  })

  // Auto focus on email input
  emailInput.focus()

  // Add smooth animations for form interactions
  emailInput.addEventListener("focus", function () {
    this.parentElement.style.transform = "translateY(-2px)"
    this.parentElement.style.transition = "transform 0.2s ease"
  })

  emailInput.addEventListener("blur", function () {
    this.parentElement.style.transform = "translateY(0)"
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
  const formElements = document.querySelectorAll(".form-group, .primary-btn, .help-section")
  formElements.forEach((el, index) => {
    el.style.opacity = "0"
    el.style.transform = "translateY(20px)"
    el.style.transition = `opacity 0.6s ease ${index * 0.1}s, transform 0.6s ease ${index * 0.1}s`
    observer.observe(el)
  })

  // Success state handler (if needed for future enhancement)
  function showSuccessState(email) {
    const authCard = document.querySelector(".auth-card")
    authCard.innerHTML = `
      <div class="success-state">
        <div class="success-icon-large">📧</div>
        <h2 class="success-title">Check Your Email</h2>
        <p class="success-description">
          We've sent a password reset link to <strong>${email}</strong>. 
          Please check your inbox and follow the instructions to reset your password.
        </p>
        <div class="help-section">
          <div class="help-info">
            <div class="help-icon">💡</div>
            <div class="help-text">
              <p><strong>Didn't receive the email?</strong></p>
              <p>Check your spam folder or try again in a few minutes.</p>
            </div>
          </div>
        </div>
        <div class="auth-footer">
          <p><a href="${contextPath}/login" class="login-link">← Back to Sign In</a></p>
        </div>
      </div>
    `
  }
})
