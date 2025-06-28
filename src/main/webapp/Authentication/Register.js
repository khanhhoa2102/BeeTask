document.addEventListener("DOMContentLoaded", () => {
    const registerForm = document.getElementById("registerForm")
    const nameInput = document.getElementById("name")
    const emailInput = document.getElementById("email")
    const passwordInput = document.getElementById("password")
    const registerBtn = document.getElementById("registerBtn")
    const googleBtn = document.getElementById("googleBtn")
    const loadingSpinner = document.getElementById("loadingSpinner")
    const btnText = document.querySelector(".btn-text")
    const passwordStrength = document.getElementById("passwordStrength")
    const strengthFill = document.getElementById("strengthFill")
    const strengthText = document.getElementById("strengthText")

    const topError = document.getElementById("topErrorMessage")
    if (topError) {
        setTimeout(() => {
            topError.style.display = "none"
        }, 5000)
    }

    // Form validation functions
    function validateName(name) {
        return name.trim().length >= 2
    }

    function validateEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
        return emailRegex.test(email)
    }

    function validatePassword(password) {
        return password.length >= 6
    }

    function getPasswordStrength(password) {
        let score = 0
        if (password.length >= 8)
            score++
        if (/[a-z]/.test(password))
            score++
        if (/[A-Z]/.test(password))
            score++
        if (/[0-9]/.test(password))
            score++
        if (/[^A-Za-z0-9]/.test(password))
            score++

        if (score < 2)
            return {strength: "weak", text: "Weak password"}
        if (score < 4)
            return {strength: "medium", text: "Medium password"}
        return {strength: "strong", text: "Strong password"}
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
        registerBtn.disabled = true
        btnText.style.display = "none"
        loadingSpinner.style.display = "block"
    }

    function hideLoading() {
        registerBtn.disabled = false
        btnText.style.display = "inline-block"
        loadingSpinner.style.display = "none"
    }

    // Real-time validation
    nameInput.addEventListener("blur", function () {
        const name = this.value.trim()
        if (name && !validateName(name)) {
            showError("name", "Name must be at least 2 characters long")
        } else {
            hideError("name")
        }
    })

    emailInput.addEventListener("blur", function () {
        const email = this.value.trim()
        if (email && !validateEmail(email)) {
            showError("email", "Please enter a valid email address")
        } else {
            hideError("email")
        }
    })

    passwordInput.addEventListener("input", function () {
        const password = this.value

        if (password.length > 0) {
            passwordStrength.classList.add("show")
            const {strength, text} = getPasswordStrength(password)

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

        hideError("password")
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
    nameInput.addEventListener("input", () => {
        hideError("name")
    })

    emailInput.addEventListener("input", () => {
        hideError("email")
    })

    // Form submission
    registerForm.addEventListener("submit", function (e) {
        e.preventDefault()

        const name = nameInput.value.trim()
        const email = emailInput.value.trim()
        const password = passwordInput.value
        let isValid = true

        // Validate name
        if (!name) {
            showError("name", "Name is required")
            isValid = false
        } else if (!validateName(name)) {
            showError("name", "Name must be at least 2 characters long")
            isValid = false
        } else {
            hideError("name")
        }

        // Validate email
        if (!email) {
            showError("email", "Email is required")
            isValid = false
        } else if (!validateEmail(email)) {
            showError("email", "Please enter a valid email address")
            isValid = false
        } else {
            hideError("email")
        }

        // Validate password
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

            // Simulate API call
            setTimeout(() => {
                // Here you would normally submit the form to your server
                // For now, we'll just submit the form normally
                hideLoading()
                console.log("✅ Submitting form...");
                registerForm.submit()
            }, 1000)
        }
    })

    // Google sign-up button
    googleBtn.addEventListener("click", () => {
        // Implement Google OAuth logic here
        alert("Google sign-up functionality would be implemented here")
        // Example: window.location.href = '/auth/google';
    })

    // Enter key support
    document.addEventListener("keypress", (e) => {
        if (
                e.key === "Enter" &&
                (nameInput === document.activeElement ||
                        emailInput === document.activeElement ||
                        passwordInput === document.activeElement)
                ) {
            registerForm.dispatchEvent(new Event("submit"))
        }
    })
})
