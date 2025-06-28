document.addEventListener("DOMContentLoaded", () => {
    const changeForm = document.getElementById("changeForm")
    const newPasswordInput = document.getElementById("newPassword")
    const confirmPasswordInput = document.getElementById("confirmPassword")
    const changeBtn = document.getElementById("changeBtn")
    const loadingSpinner = document.getElementById("loadingSpinner")
    const btnText = document.querySelector(".btn-text")
    const successMessage = document.getElementById("successMessage")

    // Add after the variable declarations
    const toggleNew = document.getElementById("toggleNew")
    const toggleConfirm = document.getElementById("toggleConfirm")

    // Password visibility toggle function
    function togglePasswordVisibility(input, button) {
        const type = input.getAttribute("type") === "password" ? "text" : "password"
        input.setAttribute("type", type)

        const eyeIcon = button.querySelector(".eye-icon")
        if (type === "text") {
            // Show "eye-off" icon when password is visible
            eyeIcon.innerHTML = `
      <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/>
      <line x1="1" y1="1" x2="23" y2="23"/>
    `
        } else {
            // Show "eye" icon when password is hidden
            eyeIcon.innerHTML = `
      <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
      <circle cx="12" cy="12" r="3"/>
    `
        }
    }

    // Add event listeners for toggle buttons
    toggleNew.addEventListener("click", () => {
        togglePasswordVisibility(newPasswordInput, toggleNew)
    })

    toggleConfirm.addEventListener("click", () => {
        togglePasswordVisibility(confirmPasswordInput, toggleConfirm)
    })

    // Form validation functions
    function validatePassword(password) {
        return password.length >= 6
    }

    function passwordsMatch(password1, password2) {
        return password1 === password2
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
        changeBtn.disabled = true
        btnText.style.display = "none"
        loadingSpinner.style.display = "block"
    }

    function hideLoading() {
        changeBtn.disabled = false
        btnText.style.display = "inline-block"
        loadingSpinner.style.display = "none"
    }

    function showSuccess() {
        successMessage.classList.add("show")
        successMessage.style.display = "block"

        // Hide the form
        changeForm.style.opacity = "0.5"
        changeBtn.disabled = true

        // Auto redirect after 3 seconds
        setTimeout(() => {
            window.location.href = newPasswordInput.closest("form").action.replace("/change-password", "/login")
        }, 3000)
    }

    // Real-time validation
    newPasswordInput.addEventListener("blur", function () {
        const password = this.value
        if (password && !validatePassword(password)) {
            showError("newPassword", "Password must be at least 6 characters long")
        } else {
            hideError("newPassword")
        }
    })

    confirmPasswordInput.addEventListener("input", function () {
        const confirmPassword = this.value
        const newPassword = newPasswordInput.value

        if (confirmPassword && newPassword) {
            if (!passwordsMatch(newPassword, confirmPassword)) {
                showError("confirmPassword", "Passwords do not match")
            } else {
                hideError("confirmPassword")
            }
        } else {
            hideError("confirmPassword")
        }
    })

    // Clear errors on input
    newPasswordInput.addEventListener("input", () => {
        hideError("newPassword")
    })

    confirmPasswordInput.addEventListener("input", () => {
        hideError("confirmPassword")
    })

    // Form submission
    changeForm.addEventListener("submit", (e) => {
        e.preventDefault()

        const newPassword = newPasswordInput.value
        const confirmPassword = confirmPasswordInput.value
        let isValid = true

        // Validate new password
        if (!newPassword) {
            showError("newPassword", "New password is required")
            isValid = false
        } else if (!validatePassword(newPassword)) {
            showError("newPassword", "Password must be at least 6 characters long")
            isValid = false
        } else {
            hideError("newPassword")
        }

        // Validate confirm password
        if (!confirmPassword) {
            showError("confirmPassword", "Please confirm your password")
            isValid = false
        } else if (!passwordsMatch(newPassword, confirmPassword)) {
            showError("confirmPassword", "Passwords do not match")
            isValid = false
        } else {
            hideError("confirmPassword")
        }

        if (isValid) {
            showLoading()

            // Simulate API call
            setTimeout(() => {
                changeForm.submit()
            }, 100) 
        }
    })

    // Enter key support
    document.addEventListener("keypress", (e) => {
        if (
                e.key === "Enter" &&
                (newPasswordInput === document.activeElement || confirmPasswordInput === document.activeElement)
                ) {
            changeForm.dispatchEvent(new Event("submit"))
        }
    })

    // Focus on first input when page loads
    newPasswordInput.focus()
})
