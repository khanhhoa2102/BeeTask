document.addEventListener('DOMContentLoaded', function () {
    initializeAccountSettings();
});

function initializeAccountSettings() {
    const form = document.getElementById('settingsForm');
    const avatarUrlInput = document.getElementById('avatarUrl');
    const avatarPreview = document.getElementById('avatarPreview');
    const submitBtn = document.getElementById('submitBtn');
    const phoneNumberInput = document.getElementById('phoneNumber');
    const usernameInput = document.getElementById('username');

    if (avatarUrlInput && avatarPreview) {
        avatarUrlInput.addEventListener('input', function () {
            const url = this.value.trim();
            const testImg = new Image();
            testImg.onload = function () {
                avatarPreview.src = url;
                avatarPreview.style.display = 'block';
                avatarPreview.nextElementSibling.style.opacity = '0';
            };
            testImg.onerror = function () {
                avatarPreview.src = 'https://via.placeholder.com/100';
                avatarPreview.nextElementSibling.style.opacity = '1';
            };
            testImg.src = url;
        });
    }

    if (phoneNumberInput) {
        phoneNumberInput.addEventListener('input', function () {
            let value = this.value.replace(/\D/g, '');
            if (value.length > 10)
                value = value.substring(0, 10);
            if (value.length >= 7) {
                value = value.replace(/(\d{4})(\d{3})(\d{3})/, '$1 $2 $3');
            } else if (value.length >= 4) {
                value = value.replace(/(\d{4})(\d{0,3})/, '$1 $2');
            }
            this.value = value;
            const phoneDisplay = document.getElementById('phoneDisplay');
            if (phoneDisplay)
                phoneDisplay.textContent = value || 'Chưa cập nhật';
        });
    }

    if (usernameInput) {
        usernameInput.addEventListener('input', function () {
            const profileName = document.querySelector('.profile-header h3');
            if (profileName)
                profileName.textContent = this.value || 'Tên người dùng';
        });
    }

    const addressInput = document.getElementById('address');
    if (addressInput) {
        addressInput.addEventListener('input', function () {
            const addressDisplay = document.getElementById('addressDisplay');
            if (addressDisplay)
                addressDisplay.textContent = this.value || 'Chưa cập nhật';
        });
    }

    if (form) {
        form.addEventListener('submit', function (e) {
            e.preventDefault();
            if (!validateForm()) return;
            showLoadingState(true);
            submitForm();
        });
    }

    addValidationListeners();
}

function validateForm() {
    const username = document.getElementById('username').value.trim();
    const phoneNumber = document.getElementById('phoneNumber').value.trim();
    const avatarUrl = document.getElementById('avatarUrl').value.trim();
    const address = document.getElementById('address').value.trim();

    if (!username || username.length < 3 || username.length > 100) {
        showToast('Tên đăng nhập phải từ 3 đến 100 ký tự', 'error');
        document.getElementById('username').focus();
        return false;
    }

    if (phoneNumber && phoneNumber.length > 20) {
        showToast('Số điện thoại không được vượt quá 20 ký tự', 'error');
        document.getElementById('phoneNumber').focus();
        return false;
    }

    if (avatarUrl && avatarUrl.length > 255) {
        showToast('URL avatar không được vượt quá 255 ký tự', 'error');
        document.getElementById('avatarUrl').focus();
        return false;
    }

    if (address && address.length > 255) {
        showToast('Địa chỉ không được vượt quá 255 ký tự', 'error');
        document.getElementById('address').focus();
        return false;
    }

    if (phoneNumber && !isValidPhoneNumber(phoneNumber)) {
        showToast('Số điện thoại không hợp lệ', 'error');
        document.getElementById('phoneNumber').focus();
        return false;
    }

    if (avatarUrl && !isValidUrl(avatarUrl)) {
        showToast('URL avatar không hợp lệ', 'error');
        document.getElementById('avatarUrl').focus();
        return false;
    }

    return true;
}

function isValidPhoneNumber(phone) {
    const cleanPhone = phone.replace(/\s/g, '');
    const phoneRegex = /^(0[3|5|7|8|9])+([0-9]{8})$/;
    return phoneRegex.test(cleanPhone);
}

function isValidUrl(url) {
    try {
        new URL(url);
        return true;
    } catch {
        return false;
    }
}

function submitForm() {
    const form = document.getElementById('settingsForm');
    const formData = new FormData(form);
    const contextPath = document.body.getAttribute('data-context-path') || '';
    const endpoint = `${contextPath}/account/settings`;

    const encodedData = new URLSearchParams(formData);

    console.log('🔵 Đang gửi dữ liệu đến:', endpoint);
    console.log('📦 Dữ liệu gửi đi:');
    for (let [key, value] of encodedData.entries()) {
        console.log(`  - ${key}: ${value}`);
    }

    fetch(endpoint, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: encodedData
    })
    .then(response => {
        console.log('✅ Phản hồi từ server:', response);
        return response.json();
    })
    .then(data => {
        console.log('🟢 JSON nhận được từ server:', data);
        if (data.log) {
            console.log('📋 Log từ server:', data.log);
        }

        showLoadingState(false);
        if (data.success) {
            showToast('✅ Cập nhật thông tin thành công!', 'success');
            document.getElementById('phoneDisplay').textContent = formData.get('phoneNumber') || 'Chưa cập nhật';
            document.getElementById('addressDisplay').textContent = formData.get('address') || 'Chưa cập nhật';
            document.querySelector('.profile-header h3').textContent = formData.get('username') || 'Tên người dùng';
            document.getElementById('avatarPreview').src = formData.get('avatarUrl') || 'https://via.placeholder.com/100';
        } else {
            showToast(`❌ Cập nhật thất bại: ${data.message || 'Không rõ nguyên nhân.'}`, 'error');
        }
    })
    .catch(error => {
        showLoadingState(false);
        console.error('❌ Lỗi kết nối máy chủ:', error);
        showToast('❌ Lỗi kết nối máy chủ!', 'error');
    });
}

function showLoadingState(loading) {
    const submitBtn = document.getElementById('submitBtn');
    const btnText = submitBtn.querySelector('span');
    if (loading) {
        submitBtn.classList.add('loading');
        submitBtn.disabled = true;
        btnText.textContent = 'Đang lưu...';
    } else {
        submitBtn.classList.remove('loading');
        submitBtn.disabled = false;
        btnText.textContent = 'Lưu thay đổi';
    }
}

function showToast(message, type = 'success') {
    const toast = document.getElementById('toast');
    const toastIcon = toast.querySelector('.toast-icon');
    const toastMessage = toast.querySelector('.toast-message');
    toastMessage.textContent = message;
    toast.className = `toast ${type}`;
    toastIcon.className = type === 'success'
        ? 'toast-icon fas fa-check-circle'
        : 'toast-icon fas fa-exclamation-circle';
    toast.classList.add('show');
    setTimeout(() => toast.classList.remove('show'), 4000);
}

function addValidationListeners() {
    const usernameInput = document.getElementById('username');
    const phoneInput = document.getElementById('phoneNumber');
    const avatarUrlInput = document.getElementById('avatarUrl');

    if (usernameInput) {
        usernameInput.addEventListener('blur', function () {
            this.style.borderColor = this.value.trim().length < 3 ? '#dc3545' : '#e1e5e9';
        });
    }
    if (phoneInput) {
        phoneInput.addEventListener('blur', function () {
            this.style.borderColor = isValidPhoneNumber(this.value.trim()) ? '#e1e5e9' : '#dc3545';
        });
    }
    if (avatarUrlInput) {
        avatarUrlInput.addEventListener('blur', function () {
            this.style.borderColor = isValidUrl(this.value.trim()) ? '#e1e5e9' : '#dc3545';
        });
    }
}
