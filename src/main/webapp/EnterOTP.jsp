<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BeeTask - Verify Code</title>
    <link rel="stylesheet" href="EnterOTP.css">
</head>
<body>
    <div class="decorative-shapes">
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
    </div>
    
    <div class="container">
        <div class="verify-card">
            <!-- Logo Section -->
            <div class="logo-section">
                <div class="logo-container">
                    <img src="${pageContext.request.contextPath}/Asset/Longlogo.png" alt="BeeTask Logo" class="logo">
                </div>
                <h2 class="verify-title">We have sent you a code</h2>
                <p class="verify-subtitle">Enter the code to verify your account, to change password</p>
            </div>

            <!-- Email Display -->
            <div class="email-section">
                <span class="email-address" id="emailAddress">Nguyenkanhhoa@gmail.com</span>
                <button type="button" class="resend-btn" id="resendBtn">Resend Email</button>
            </div>

            <!-- Verify Code Form -->
            <form class="verify-form" id="verifyForm" action="${pageContext.request.contextPath}/verify-code" method="post">
                <!-- Code Input Boxes -->
                <div class="code-inputs">
                    <input type="text" class="code-input" id="code1" name="code1" maxlength="1" autocomplete="off">
                    <input type="text" class="code-input" id="code2" name="code2" maxlength="1" autocomplete="off">
                    <input type="text" class="code-input" id="code3" name="code3" maxlength="1" autocomplete="off">
                    <input type="text" class="code-input" id="code4" name="code4" maxlength="1" autocomplete="off">
                    <input type="text" class="code-input" id="code5" name="code5" maxlength="1" autocomplete="off">
                    <input type="text" class="code-input" id="code6" name="code6" maxlength="1" autocomplete="off">
                </div>

                <!-- Hidden input for complete code -->
                <input type="hidden" id="verificationCode" name="verificationCode">
                <input type="hidden" id="userEmail" name="email" value="Nguyenkanhhoa@gmail.com">

                <!-- Error Message -->
                <div class="error-message" id="errorMessage" style="display: none;">
                    <span id="errorText"></span>
                </div>

                <!-- Verify Button -->
                <button type="submit" class="verify-btn" id="verifyBtn" disabled>
                    <span class="btn-text">Verify</span>
                    <span class="loading-spinner" id="loadingSpinner" style="display: none;">
                        <div class="spinner"></div>
                    </span>
                </button>

                <!-- Success Message -->
                <div class="success-message" id="successMessage" style="display: none;">
                    <div class="success-icon">✓</div>
                    <p>Code verified successfully!</p>
                    <small>Redirecting to change password...</small>
                </div>

                <!-- Resend Timer -->
                <div class="resend-timer" id="resendTimer" style="display: none;">
                    <span>Resend code in <span id="countdown">60</span> seconds</span>
                </div>
            </form>
        </div>
    </div>

    <script src="EnterOTP.js"></script>
</body>
</html>
