document.addEventListener("DOMContentLoaded", () => {
  const verifyForm = document.getElementById("verifyForm");
  const codeInputs = document.querySelectorAll(".code-input");
  const verifyBtn = document.getElementById("verifyBtn");
  const resendBtn = document.getElementById("resendBtn");
  const loadingSpinner = document.getElementById("loadingSpinner");
  const btnText = document.querySelector(".btn-text");
  const successMessage = document.getElementById("successMessage");
  const errorMessage = document.getElementById("errorMessage");
  const errorText = document.getElementById("errorText");
  const resendTimer = document.getElementById("resendTimer");
  const countdown = document.getElementById("countdown");
  const verificationCodeInput = document.getElementById("verificationCode");

  let resendCountdown = 0;
  let countdownInterval = null;

  // Auto-focus and input handling
  codeInputs.forEach((input, index) => {
    input.addEventListener("input", (e) => {
      const value = e.target.value.replace(/[^0-9]/g, "");
      e.target.value = value;

      if (value) {
        input.classList.add("filled");
        if (index < codeInputs.length - 1) {
          codeInputs[index + 1].focus();
        }
      } else {
        input.classList.remove("filled");
      }

      updateVerifyButton();
      hideError();
    });

    input.addEventListener("keydown", (e) => {
      if (e.key === "Backspace" && !input.value && index > 0) {
        codeInputs[index - 1].focus();
        codeInputs[index - 1].value = "";
        codeInputs[index - 1].classList.remove("filled");
        updateVerifyButton();
      }

      if (e.key === "ArrowLeft" && index > 0) {
        codeInputs[index - 1].focus();
      }
      if (e.key === "ArrowRight" && index < codeInputs.length - 1) {
        codeInputs[index + 1].focus();
      }

      if (e.key === "Enter") {
        verifyForm.dispatchEvent(new Event("submit"));
      }
    });

    input.addEventListener("paste", (e) => {
      e.preventDefault();
      const pastedData = e.clipboardData.getData("text").replace(/[^0-9]/g, "");

      if (pastedData.length === 6) {
        codeInputs.forEach((inp, idx) => {
          inp.value = pastedData[idx] || "";
          if (inp.value) {
            inp.classList.add("filled");
          }
        });
        updateVerifyButton();
        codeInputs[5].focus();
      }
    });
  });

  function updateVerifyButton() {
    const allFilled = Array.from(codeInputs).every((input) => input.value.length === 1);
    verifyBtn.disabled = !allFilled;

    const code = Array.from(codeInputs).map((input) => input.value).join("");
    verificationCodeInput.value = code;
  }

  function showError(message) {
    errorText.textContent = message;
    errorMessage.classList.add("show");
    errorMessage.style.display = "block";

    codeInputs.forEach((input) => {
      input.classList.add("error");
    });

    setTimeout(() => {
      codeInputs.forEach((input) => {
        input.classList.remove("error");
      });
    }, 500);
  }

  function hideError() {
    errorMessage.classList.remove("show");
    errorMessage.style.display = "none";
  }

  function showLoading() {
    verifyBtn.disabled = true;
    btnText.style.display = "none";
    loadingSpinner.style.display = "block";
  }

  function hideLoading() {
    updateVerifyButton();
    btnText.style.display = "inline-block";
    loadingSpinner.style.display = "none";
  }

  function showSuccess() {
    successMessage.classList.add("show");
    successMessage.style.display = "block";
    verifyForm.style.opacity = "0.5";
    verifyBtn.disabled = true;

    setTimeout(() => {
      window.location.href = verifyForm.action.replace("/verify-code", "/change-password");
    }, 3000);
  }

  function startResendTimer() {
    resendCountdown = 60;
    resendBtn.disabled = true;
    resendTimer.classList.add("show");
    resendTimer.style.display = "block";

    countdownInterval = setInterval(() => {
      resendCountdown--;
      countdown.textContent = resendCountdown;

      if (resendCountdown <= 0) {
        clearInterval(countdownInterval);
        resendBtn.disabled = false;
        resendTimer.classList.remove("show");
        resendTimer.style.display = "none";
      }
    }, 1000);
  }

  // Form submission
  verifyForm.addEventListener("submit", (e) => {
    e.preventDefault();

    const code = Array.from(codeInputs).map((input) => input.value).join("");
    verificationCodeInput.value = code; // ✅ Đảm bảo cập nhật

    if (code.length !== 6) {
      showError("Please enter the complete 6-digit code");
      return;
    }

    showLoading();

    setTimeout(() => {
      hideLoading();
      verifyForm.submit(); // ✅ Thực hiện submit thực sự sau khi xử lý xong
    }, 100);
  });

  // Resend email
  resendBtn.addEventListener("click", () => {
    hideError();

    fetch("resend-otp", {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
    })
      .then((res) => res.json())
      .then((data) => {
        if (data.success) {
          resendBtn.textContent = "Sent!";
          resendBtn.style.color = "#10b981";
          setTimeout(() => {
            resendBtn.textContent = "Resend Email";
            resendBtn.style.color = "#3b82f6";
            startResendTimer();
          }, 1000);
        } else {
          showError(data.message);
        }
      })
      .catch(() => {
        showError("Error while resending code. Try again.");
      });
  });

  codeInputs[0].focus();
  startResendTimer();
});
