document.addEventListener('DOMContentLoaded', function () {
    initializeAccountSettings();
});

function initializeAccountSettings() {
    const form = document.getElementById('settingsForm');
    const avatarUpload = document.getElementById('avatarUpload');
    const avatarPreview = document.getElementById('avatarPreview');
    const submitBtn = document.getElementById('submitBtn');

    // Handle avatar upload
    if (avatarUpload && avatarPreview) {
        avatarUpload.addEventListener('change', function (e) {
            const file = e.target.files[0];
            if (!file)
                return;

            if (!file.type.match('image.*')) {
                showToast('Please select an image file (JPEG, PNG, etc.)', 'error');
                return;
            }

            if (file.size > 2 * 1024 * 1024) {
                showToast('Image size should not exceed 2MB', 'error');
                return;
            }

            const reader = new FileReader();
            reader.onload = function (e) {
                avatarPreview.src = e.target.result;
                avatarPreview.style.display = 'block';
                avatarPreview.nextElementSibling.style.opacity = '0';
            };
            reader.readAsDataURL(file);
        });
    }

    // Live updates
    document.getElementById('username').addEventListener('input', function () {
        document.getElementById('usernameDisplay').textContent = this.value;
    });

    document.getElementById('phoneNumber').addEventListener('input', function () {
        document.getElementById('phoneDisplay').textContent = this.value || 'Not provided';
    });

    document.getElementById('address').addEventListener('input', function () {
        document.getElementById('addressDisplay').textContent = this.value || 'Not provided';
    });

    // Form submission
    if (form) {
        form.addEventListener('submit', function (e) {
            e.preventDefault();
            if (!validateForm())
                return;
            showLoadingState(true);
            submitForm();
        });
    }
}

function validateForm() {
    const form = document.getElementById('settingsForm');
    const usernameInput = document.getElementById('username');
    const phoneNumberInput = document.getElementById('phoneNumber');
    const addressInput = document.getElementById('address');
    const avatarFileInput = document.getElementById('avatarUpload');
    
    // Get current values
    const username = usernameInput.value.trim();
    const phoneNumber = phoneNumberInput.value.trim();
    const address = addressInput.value.trim();
    const avatarFile = avatarFileInput.files[0];
    
    // Get original values from data attributes
    const originalUsername = usernameInput.dataset.original;
    const originalPhone = phoneNumberInput.dataset.original || '';
    const originalAddress = addressInput.dataset.original || '';

    // Check if avatar is being uploaded (regardless of other changes)
    if (avatarFile) {
        // Validate avatar file
        if (!avatarFile.type.match('image.*')) {
            showToast('Please select a valid image file (JPEG, PNG)', 'error');
            return false;
        }
        if (avatarFile.size > 2 * 1024 * 1024) {
            showToast('Image size should not exceed 2MB', 'error');
            return false;
        }
        // If only uploading avatar, return true immediately
        if (username === originalUsername && 
            phoneNumber === originalPhone && 
            address === originalAddress) {
            return true;
        }
    }

    // Check if username was changed
    if (username !== originalUsername) {
        if (!username || username.length < 3 || username.length > 100) {
            showToast('Username must be between 3 and 100 characters', 'error');
            return false;
        }
    }

    // Check if phone number was changed
    if (phoneNumber !== originalPhone) {
        if (phoneNumber && !isValidPhoneNumber(phoneNumber)) {
            showToast('Invalid phone number format', 'error');
            return false;
        }
    }

    // Check if address was changed
    if (address !== originalAddress) {
        if (address && address.length > 255) {
            showToast('Address should not exceed 255 characters', 'error');
            return false;
        }
    }

    // Check if any fields were actually changed
    const hasChanges = username !== originalUsername ||
                      phoneNumber !== originalPhone ||
                      address !== originalAddress ||
                      (avatarFile && avatarFile.size > 0);

    if (!hasChanges) {
        showToast('No changes were made', 'info');
        return false;
    }

    return true;
}

function isValidPhoneNumber(phone) {
    const cleanPhone = phone.replace(/\s/g, '');
    const phoneRegex = /^(0[3|5|7|8|9])+([0-9]{8})$/;
    return phoneRegex.test(cleanPhone);
}

function submitForm() {
    const form = document.getElementById('settingsForm');
    const formData = new FormData(form);
    const avatarFile = document.getElementById('avatarUpload').files[0];

    // Đảm bảo gửi file nếu có
    if (avatarFile) {
        formData.set('avatarFile', avatarFile);
    }

    showLoadingState(true);

    fetch(form.action, {
        method: 'POST',
        body: formData
    })
            .then(response => response.json())
            .then(data => {
                showLoadingState(false);
                if (data.success) {
                    showToast(data.message || 'Cập nhật thành công!', 'success');
                    if (avatarFile && data.avatarUrl) {
                        // Cập nhật ảnh preview
                        const avatarPreview = document.getElementById('avatarPreview');
                        avatarPreview.src = data.avatarUrl;
                        // Reset input file
                        document.getElementById('avatarUpload').value = '';
                    }
                } else {
                    showToast(data.message || 'Cập nhật thất bại', 'error');
                }
            })
            .catch(error => {
                showLoadingState(false);
                showToast('Lỗi kết nối máy chủ', 'error');
            });
}

function showLoadingState(loading) {
    const submitBtn = document.getElementById('submitBtn');
    const btnText = submitBtn.querySelector('.btn-text');
    const spinner = submitBtn.querySelector('.spinner-border');

    if (loading) {
        submitBtn.disabled = true;
        btnText.textContent = 'Saving...';
        spinner.classList.remove('d-none');
    } else {
        submitBtn.disabled = false;
        btnText.textContent = 'Save Changes';
        spinner.classList.add('d-none');
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
            : type === 'error'
            ? 'toast-icon fas fa-exclamation-circle'
            : 'toast-icon fas fa-info-circle';

    toast.classList.add('show');
    setTimeout(() => toast.classList.remove('show'), 4000);
}