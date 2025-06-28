const contextPath = document.body.getAttribute("data-context-path") || "";
function initializePage() {
    // Add event listeners
    const addAccountForm = document.getElementById('addAccountForm');
    if (addAccountForm) {
        addAccountForm.addEventListener('submit', handleAddAccount);
    }

    // Add keyboard event listeners for modals
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
            hideAllModals();
        }
    });

    // Add click outside modal to close
    const modals = document.querySelectorAll('.modal-overlay');
    modals.forEach(modal => {
        modal.addEventListener('click', function (e) {
            if (e.target === modal) {
                hideAllModals();
            }
        });
    });

    // Add smooth scroll behavior
    document.documentElement.style.scrollBehavior = 'smooth';
}

function animateBackgroundCircles() {
    const circles = document.querySelectorAll('.circle');
    circles.forEach((circle, index) => {
        // Add random movement
        setInterval(() => {
            const randomX = Math.random() * 20 - 10;
            const randomY = Math.random() * 20 - 10;
            circle.style.transform = `translate(${randomX}px, ${randomY}px)`;
        }, 3000 + index * 500);
    });
}

function switchAccount(accountId) {
    // Show loading overlay
    showLoading('Switching to account...');

    // Add visual feedback to the clicked account
    const accountCard = document.querySelector(`[data-account-id="${accountId}"]`);
    if (accountCard) {
        accountCard.style.transform = 'scale(0.95)';
        setTimeout(() => {
            accountCard.style.transform = '';
        }, 200);
    }

    // Simulate API call to switch account
    setTimeout(() => {
        // In real implementation, this would make an AJAX call to the server
        fetch('/api/switch-account', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({accountId: accountId})
        })
                .then(response => response.json())
                .then(data => {
                    hideLoading();
                    if (data.success) {
                        // Show success animation
                        showSuccess('Account switched successfully!');
                        setTimeout(() => {
                            // Redirect to dashboard or reload page
                            window.location.href = '/dashboard';
                        }, 1500);
                    } else {
                        showError('Failed to switch account. Please try again.');
                    }
                })
                .catch(error => {
                    hideLoading();
                    showError('An error occurred while switching accounts.');
                    console.error('Error:', error);
                });
    }, 1500);
}

function removeAccount(accountId) {
    const accountCard = document.querySelector(`[data-account-id="${accountId}"]`);
    const accountName = accountCard.querySelector('h3').textContent;

    showConfirmModal(
            `Are you sure you want to remove "${accountName}" from this device? You can always add it back later.`,
            () => confirmRemoveAccount(accountId)
    );
}

function confirmRemoveAccount(accountId) {
    showLoading('Removing account...');

    // Simulate API call to remove account
    setTimeout(() => {
        // In real implementation, this would make an AJAX call to the server
        fetch('/api/remove-account', {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({accountId: accountId})
        })
                .then(response => response.json())
                .then(data => {
                    hideLoading();
                    hideConfirmModal();
                    if (data.success) {
                        // Remove the account card from DOM with animation
                        const accountCard = document.querySelector(`[data-account-id="${accountId}"]`);
                        if (accountCard) {
                            accountCard.style.animation = 'slideOut 0.3s ease-in-out';
                            accountCard.style.transform = 'scale(0.8)';
                            accountCard.style.opacity = '0';
                            setTimeout(() => {
                                accountCard.remove();
                                checkEmptyState();
                            }, 300);
                        }
                        showSuccess('Account removed successfully.');
                    } else {
                        showError('Failed to remove account. Please try again.');
                    }
                })
                .catch(error => {
                    hideLoading();
                    hideConfirmModal();
                    showError('An error occurred while removing the account.');
                    console.error('Error:', error);
                });
    }, 1000);
}

function showAddAccountModal() {
    const modal = document.getElementById('addAccountModal');
    modal.style.display = 'flex';
    setTimeout(() => {
        modal.classList.add('show');
    }, 10);

    // Focus on email input
    const emailInput = document.getElementById('email');
    if (emailInput) {
        setTimeout(() => {
            emailInput.focus();
        }, 300);
    }
}

function hideAddAccountModal() {
    const modal = document.getElementById('addAccountModal');
    modal.classList.remove('show');
    setTimeout(() => {
        modal.style.display = 'none';
        // Clear form
        const form = document.getElementById('addAccountForm');
        if (form) {
            form.reset();
        }
    }, 300);
}

function handleAddAccount(e) {
    e.preventDefault();

    const formData = new FormData(e.target);
    const email = formData.get('email');
    const password = formData.get('password');

    if (!email || !password) {
        showError('Please fill in all fields.');
        return;
    }

    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        showError('Please enter a valid email address.');
        return;
    }

    showLoading('Adding account...');

    // Simulate API call to add account
    setTimeout(() => {
        // In real implementation, this would make an AJAX call to the server
        fetch('/api/add-account', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({email: email, password: password})
        })
                .then(response => response.json())
                .then(data => {
                    hideLoading();
                    if (data.success) {
                        hideAddAccountModal();
                        // Add new account to the list
                        addAccountToList(data.account);
                        showSuccess('Account added successfully!');
                        checkEmptyState();
                    } else {
                        showError(data.message || 'Failed to add account. Please check your credentials.');
                    }
                })
                .catch(error => {
                    hideLoading();
                    showError('An error occurred while adding the account.');
                    console.error('Error:', error);
                });
    }, 2000);
}

function addAccountToList(account) {
    const accountsList = document.getElementById('accountList');
    const accountCard = document.createElement('div');
    accountCard.className = 'account-card';
    accountCard.setAttribute('data-account-id', account.id);
    accountCard.style.animation = 'slideIn 0.3s ease-in-out';

    const avatarGradient = getRandomGradient();
    const initials = getInitials(account.name || account.email);

    accountCard.innerHTML = `
        <div class="account-avatar" style="background: ${avatarGradient};">
            ${initials}
        </div>
        <div class="account-info">
            <h3>${account.name || account.email}</h3>
            <p>${account.email}</p>
            <span class="last-used">Just added</span>
        </div>
        <div class="account-actions">
            <button class="action-btn switch-btn" onclick="switchAccount(${account.id})">
                Switch
            </button>
            <button class="action-btn remove-btn" onclick="removeAccount(${account.id})" title="Remove Account">
                <i class="fas fa-times"></i>
            </button>
        </div>
    `;

    accountsList.appendChild(accountCard);
}

function showConfirmModal(message, onConfirm) {
    const modal = document.getElementById('confirmModal');
    const messageElement = document.getElementById('confirmMessage');
    const confirmButton = document.getElementById('confirmAction');

    messageElement.textContent = message;

    // Remove existing event listeners
    const newConfirmButton = confirmButton.cloneNode(true);
    confirmButton.parentNode.replaceChild(newConfirmButton, confirmButton);

    // Add new event listener
    newConfirmButton.addEventListener('click', onConfirm);

    modal.style.display = 'flex';
    setTimeout(() => {
        modal.classList.add('show');
    }, 10);
}

function hideConfirmModal() {
    const modal = document.getElementById('confirmModal');
    modal.classList.remove('show');
    setTimeout(() => {
        modal.style.display = 'none';
    }, 300);
}

function hideAllModals() {
    hideAddAccountModal();
    hideConfirmModal();
}

function showLoading(message = 'Loading...') {
    const overlay = document.getElementById('loadingOverlay');
    const messageElement = overlay.querySelector('p');
    messageElement.textContent = message;
    overlay.style.display = 'flex';
    setTimeout(() => {
        overlay.classList.add('show');
    }, 10);
}

function hideLoading() {
    const overlay = document.getElementById('loadingOverlay');
    overlay.classList.remove('show');
    setTimeout(() => {
        overlay.style.display = 'none';
    }, 300);
}

function checkEmptyState() {
    const accountsList = document.getElementById('accountList');
    const emptyState = document.getElementById('emptyState');

    if (!accountsList || !emptyState) return; 

    const accounts = accountsList.querySelectorAll('.account-card');

    if (accounts.length === 0) {
        accountsList.style.display = 'none';
        emptyState.style.display = 'block';
    } else {
        accountsList.style.display = 'block';
        emptyState.style.display = 'none';
    }
}


function showSuccess(message) {
    showNotification(message, 'success');
}

function showError(message) {
    showNotification(message, 'error');
}

function showNotification(message, type) {
    // Create notification element
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.innerHTML = `
        <i class="fas ${type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle'}"></i>
        <span>${message}</span>
        <button class="notification-close" onclick="this.parentElement.remove()">
            <i class="fas fa-times"></i>
        </button>
    `;

    // Add to page
    document.body.appendChild(notification);

    // Show notification
    setTimeout(() => {
        notification.classList.add('show');
    }, 10);

    // Auto remove after 5 seconds
    setTimeout(() => {
        if (notification.parentElement) {
            notification.classList.remove('show');
            setTimeout(() => {
                if (notification.parentElement) {
                    notification.remove();
                }
            }, 300);
        }
    }, 5000);
}

function getRandomGradient() {
    const gradients = [
        'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
        'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)',
        'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)',
        'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)',
        'linear-gradient(135deg, #fa709a 0%, #fee140 100%)',
        'linear-gradient(135deg, #a8edea 0%, #fed6e3 100%)',
        'linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%)',
        'linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%)'
    ];
    return gradients[Math.floor(Math.random() * gradients.length)];
}

function getInitials(name) {
    return name.split(' ').map(word => word.charAt(0).toUpperCase()).join('').substring(0, 2);
}

function showPrivacyInfo() {
    showNotification('Privacy Policy: Your account information is securely stored and managed according to our privacy policy.', 'success');
}

// Add smooth transitions for better UX
document.addEventListener('click', function (e) {
    if (e.target.classList.contains('action-btn')) {
        e.target.style.transform = 'scale(0.95)';
        setTimeout(() => {
            e.target.style.transform = '';
        }, 150);
    }
});

document.addEventListener("DOMContentLoaded", function () {
    const accountList = document.getElementById("accountList");
    const accounts = JSON.parse(localStorage.getItem("recentAccounts")) || [];

    if (typeof currentEmail === "undefined") {
        console.warn("⚠️ currentEmail is undefined.");
    }

    const filteredAccounts = accounts.filter(acc => acc.email !== currentEmail);

    if (filteredAccounts.length === 0) {
        accountList.innerHTML = `<p style="color: gray;">No other accounts</p>`;
        return;
    }

    filteredAccounts.forEach(acc => {
        const div = document.createElement("div");
        div.className = "account-card";
        div.innerHTML = `
            <div class="account-avatar">${acc.username.slice(0, 2).toUpperCase()}</div>
            <div class="account-info">
                <h3>${acc.username}</h3>
                <p>${acc.email}</p>
                <button onclick="switchToAccount('${acc.email}')">Switch</button>
            </div>
        `;
        accountList.appendChild(div);
    });
});


function switchToAccount(email) {
    const accounts = JSON.parse(localStorage.getItem("recentAccounts")) || [];
    const acc = accounts.find(a => a.email === email);
    if (!acc) return;

    // Đặt cờ để Login.jsp biết đây là chuyển tài khoản, tránh auto-login trùng
    sessionStorage.setItem("switchingInProgress", "true");

    if (acc.refreshToken) {
        // ✅ Google account
        localStorage.setItem("switchGoogleEmail", acc.email);
        localStorage.setItem("switchGoogleRefreshToken", acc.refreshToken);
        window.location.href = contextPath + "/Authentication/Login.jsp";
    } else {
        // Manual account
        localStorage.setItem("switchEmail", acc.email);
        localStorage.setItem("switchPassword", acc.password);
        window.location.href = contextPath + "/Authentication/Login.jsp";
    }
}


function switchToGoogle(email, refreshToken) {
    localStorage.setItem("switchGoogleEmail", email);
    localStorage.setItem("switchGoogleRefreshToken", refreshToken);
    window.location.href = "Authentication/Login.jsp";
}
document.addEventListener('DOMContentLoaded', function () {
    // Initialize the page
    initializePage();

    // Check if there are any accounts to show empty state
    checkEmptyState();

    // Add floating animation to background circles
    animateBackgroundCircles();
});
