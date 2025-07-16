document.addEventListener("DOMContentLoaded", () => {
  const contextPath = document.body.getAttribute("data-context-path") || ""
  const registerForm = document.getElementById("registerForm")
  const nameInput = document.getElementById("name")
  const emailInput = document.getElementById("email")
  const passwordInput = document.getElementById("password")
  const confirmPasswordInput = document.getElementById("confirmPassword")
  const registerBtn = document.getElementById("registerBtn")
  const googleBtn = document.getElementById("googleBtn")
  const termsCheckbox = document.getElementById("terms")
  const togglePasswordBtn = document.getElementById("togglePassword")
  const toggleConfirmPasswordBtn = document.getElementById("toggleConfirmPassword")

  // Password strength elements
  const passwordStrength = document.getElementById("passwordStrength")
  const strengthFill = document.getElementById("strengthFill")
  const strengthText = document.getElementById("strengthText")
  const lengthReq = document.getElementById("lengthReq")
  const upperReq = document.getElementById("upperReq")
  const numberReq = document.getElementById("numberReq")

  // Password match elements
  const passwordMatch = document.getElementById("passwordMatch")
  const matchIndicator = document.getElementById("matchIndicator")

  // Enhanced password visibility toggle
  function setupPasswordToggle(toggleBtn, passwordField) {
    if (toggleBtn && passwordField) {
      toggleBtn.addEventListener("click", function () {
        const type = passwordField.getAttribute("type") === "password" ? "text" : "password"
        passwordField.setAttribute("type", type)

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
  }

  setupPasswordToggle(togglePasswordBtn, passwordInput)
  setupPasswordToggle(toggleConfirmPasswordBtn, confirmPasswordInput)

  // Enhanced validation functions
  function validateName(name) {
    return name.trim().length >= 2 && name.trim().length <= 50
  }

  function validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return emailRegex.test(email)
  }

  function validatePassword(password) {
    return password.length >= 6
  }

  function validatePasswordMatch(password, confirmPassword) {
    return password === confirmPassword && password.length > 0
  }

  // Enhanced password strength checker
  function getPasswordStrength(password) {
    let score = 0
    const requirements = {
      length: password.length >= 6,
      upper: /[A-Z]/.test(password),
      number: /[0-9]/.test(password),
    }

    // Don't show individual requirements to save space
    // Just calculate score
    Object.values(requirements).forEach((met) => {
      if (met) score++
    })

    if (score < 2) return { strength: "weak", text: "Weak" }
    if (score < 3) return { strength: "medium", text: "Good" }
    return { strength: "strong", text: "Strong" }
  }

  function updateRequirement(element, met) {
    if (met) {
      element.classList.add("met")
      element.querySelector(".req-icon").textContent = "✓"
    } else {
      element.classList.remove("met")
      element.querySelector(".req-icon").textContent = "○"
    }
  }

  function updatePasswordMatch(password, confirmPassword) {
    if (confirmPassword.length === 0) {
      passwordMatch.classList.remove("show")
      return
    }

    passwordMatch.classList.add("show")
    const isMatch = validatePasswordMatch(password, confirmPassword)

    matchIndicator.classList.remove("match", "no-match")
    if (isMatch) {
      matchIndicator.classList.add("match")
      matchIndicator.querySelector(".match-text").textContent = "Passwords match"
    } else {
      matchIndicator.classList.add("no-match")
      matchIndicator.querySelector(".match-text").textContent = "Passwords don't match"
      
    }
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
    registerBtn.disabled = true
    registerBtn.classList.add("loading")
  }

  function hideLoading() {
    registerBtn.disabled = false
    registerBtn.classList.remove("loading")
  }

  // Enhanced real-time validation
  nameInput.addEventListener("blur", () => {
    const name = nameInput.value.trim()
    if (name && !validateName(name)) {
      if (name.length < 2) {
        showError("name", "Name must be at least 2 characters long")
      } else if (name.length > 50) {
        showError("name", "Name must be less than 50 characters")
      }
    } else {
      hideError("name")
    }
  })

  nameInput.addEventListener("input", () => {
    hideError("name")
    const name = nameInput.value.trim()
    if (name && validateName(name)) {
      nameInput.style.borderColor = "var(--success-color)"
    }
  })

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

  passwordInput.addEventListener("input", () => {
    const password = passwordInput.value
    const confirmPassword = confirmPasswordInput.value

    if (password.length > 0) {
      passwordStrength.classList.add("show")
      const { strength, text } = getPasswordStrength(password)

      // Reset classes
      strengthFill.className = "strength-fill"
      strengthText.className = "strength-text"

      // Add strength classes
      strengthFill.classList.add(strength)
      strengthText.classList.add(strength)
      strengthText.textContent = text
    } else {
      passwordStrength.classList.remove("show")
    }

    // Update password match if confirm password has value
    if (confirmPassword.length > 0) {
      updatePasswordMatch(password, confirmPassword)
    }

    hideError("password")
  })

  passwordInput.addEventListener("blur", () => {
    const password = passwordInput.value
    if (password && !validatePassword(password)) {
      showError("password", "Password must be at least 6 characters long")
    } else {
      hideError("password")
    }
  })

  confirmPasswordInput.addEventListener("input", () => {
    const password = passwordInput.value
    const confirmPassword = confirmPasswordInput.value

    updatePasswordMatch(password, confirmPassword)
    hideError("confirmPassword")
  })

  confirmPasswordInput.addEventListener("blur", () => {
    const password = passwordInput.value
    const confirmPassword = confirmPasswordInput.value

    if (confirmPassword && !validatePasswordMatch(password, confirmPassword)) {
      showError("confirmPassword", "Passwords do not match")
    } else {
      hideError("confirmPassword")
    }
  })

  // Enhanced form submission
  registerForm.addEventListener("submit", (e) => {
    e.preventDefault()

    const name = nameInput.value.trim()
    const email = emailInput.value.trim()
    const password = passwordInput.value
    const confirmPassword = confirmPasswordInput.value
    const termsAccepted = termsCheckbox.checked
    let isValid = true

    // Reset previous errors
    hideError("name")
    hideError("email")
    hideError("password")
    hideError("confirmPassword")

    // Validate name
    if (!name) {
      showError("name", "Full name is required")
      isValid = false
    } else if (!validateName(name)) {
      if (name.length < 2) {
        showError("name", "Name must be at least 2 characters long")
      } else {
        showError("name", "Name must be less than 50 characters")
      }
      isValid = false
    }

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

    // Validate confirm password
    if (!confirmPassword) {
      showError("confirmPassword", "Please confirm your password")
      isValid = false
    } else if (!validatePasswordMatch(password, confirmPassword)) {
      showError("confirmPassword", "Passwords do not match")
      isValid = false
    }

    // Validate terms
    if (!termsAccepted) {
      alert("Please accept the Terms of Service and Privacy Policy to continue")
      isValid = false
    }

    if (isValid) {
      showLoading()
      setTimeout(() => {
        registerForm.submit()
      }, 1000)
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

  // Enhanced Google registration
  googleBtn.addEventListener("click", (e) => {
    e.preventDefault()
    googleBtn.style.opacity = "0.7"
    googleBtn.style.cursor = "not-allowed"

    const originalText = googleBtn.innerHTML
    googleBtn.innerHTML = `
            <div class="loader-spinner" style="width: 1rem; height: 1rem; border-width: 2px; border-color: #6b7280 transparent #6b7280 transparent;"></div>
            <span>Connecting to Google...</span>
        `

    setTimeout(() => {
      // Implement Google OAuth here
      alert("Google sign-up functionality would be implemented here")
      googleBtn.innerHTML = originalText
      googleBtn.style.opacity = "1"
      googleBtn.style.cursor = "pointer"
    }, 2000)
  })

  // Enhanced keyboard navigation
  document.addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      const activeElement = document.activeElement
      if (activeElement === nameInput) {
        emailInput.focus()
      } else if (activeElement === emailInput) {
        passwordInput.focus()
      } else if (activeElement === passwordInput) {
        confirmPasswordInput.focus()
      } else if (activeElement === confirmPasswordInput) {
        if (!termsCheckbox.checked) {
          termsCheckbox.focus()
        } else {
          registerForm.dispatchEvent(new Event("submit"))
        }
      }
    }
  })

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
