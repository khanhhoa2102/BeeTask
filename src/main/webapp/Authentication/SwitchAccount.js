const contextPath = document.body.getAttribute("data-context-path") || "";
let currentDeleteEmail = null;

// Initialize page
document.addEventListener('DOMContentLoaded', function() {
    loadAccounts();
    setupEventListeners();
});

function setupEventListeners() {
    // Add account form
    const addForm = document.getElementById('addAccountForm');
    if (addForm) {
        addForm.addEventListener('submit', handleAddAccount);
    }

    // Modal close on backdrop click
    document.querySelectorAll('.modal-backdrop').forEach(modal => {
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                hideAllModals();
            }
        });
    });

    // Escape key to close modals
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            hideAllModals();
        }
    });
}

function loadAccounts() {
    const accountsList = document.getElementById('accountsList');
    const emptyMessage = document.getElementById('emptyMessage');
    const accounts = JSON.parse(localStorage.getItem("recentAccounts")) || [];
    
    // Filter out current account
    const otherAccounts = accounts.filter(acc => acc.email !== currentEmail);
    
    if (otherAccounts.length === 0) {
        accountsList.style.display = 'none';
        emptyMessage.style.display = 'block';
        return;
    }
    
    accountsList.style.display = 'block';
    emptyMessage.style.display = 'none';
    accountsList.innerHTML = '';
    
    otherAccounts.forEach(account => {
        const accountElement = createAccountElement(account);
        accountsList.appendChild(accountElement);
    });
}

function createAccountElement(account) {
    const div = document.createElement('div');
    div.className = 'account-item';
    div.setAttribute('data-email', account.email);
    
    const initials = getInitials(account.username || account.email);
    const gradient = getRandomGradient();
    
    div.innerHTML = `
        <div class="account-avatar" style="background: ${gradient};">
            ${initials}
        </div>
        <div class="account-details">
            <h3>${account.username || account.email}</h3>
            <p>${account.email}</p>
            <span class="last-used">Last used recently</span>
        </div>
        <div class="account-menu">
            <button class="menu-btn switch-btn" onclick="switchAccount('${account.email}')" title="Switch to this account">
                Switch
            </button>
            <button class="menu-btn delete-btn" onclick="confirmDeleteAccount('${account.email}')" title="Remove account">
                <i class="fas fa-trash"></i>
            </button>
        </div>
    `;
    
    return div;
}

function switchAccount(email) {
    const accounts = JSON.parse(localStorage.getItem("recentAccounts")) || [];
    const account = accounts.find(acc => acc.email === email);

    if (!account) {
        showToast('Account not found', 'error');
        return;
    }

    showLoading('Switching account...');

    // ✅ XÓA HOÀN TOÀN DỮ LIỆU GOOGLE CŨ TRƯỚC KHI GHI MỚI
    localStorage.removeItem("switchGoogleEmail");
    localStorage.removeItem("switchGoogleRefreshToken");
    localStorage.removeItem("switchEmail");
    localStorage.removeItem("switc  hPassword");

    // Set switching flag
    sessionStorage.setItem("switchingInProgress", "true");

    if (account.refreshToken) {
        // Google account
        localStorage.setItem("switchGoogleEmail", account.email);
        localStorage.setItem("switchGoogleRefreshToken", account.refreshToken);
    } else {
        // Manual account (local)
        localStorage.setItem("switchEmail", account.email);
        localStorage.setItem("switchPassword", account.password);
    }

    // Simulate loading time
    setTimeout(() => {
        window.location.href = contextPath + "/Authentication/Login.jsp";
    }, 1500);
}

    

function confirmDeleteAccount(email) {
    const accounts = JSON.parse(localStorage.getItem("recentAccounts")) || [];
    const account = accounts.find(acc => acc.email === email);
    
    if (!account) return;
    
    currentDeleteEmail = email;
    const message = `Are you sure you want to remove "${account.username || account.email}" from this device?`;
    document.getElementById('confirmMessage').textContent = message;
    
    // Setup confirm button
    const confirmBtn = document.getElementById('confirmDelete');
    confirmBtn.onclick = () => deleteAccount(email);
    
    showModal('confirmModal');
}

function deleteAccount(email) {
    hideModal('confirmModal');
    showLoading('Removing account...');
    
    // Remove from localStorage
    const accounts = JSON.parse(localStorage.getItem("recentAccounts")) || [];
    const updatedAccounts = accounts.filter(acc => acc.email !== email);
    localStorage.setItem("recentAccounts", JSON.stringify(updatedAccounts));
    
    // Remove from DOM with animation
    const accountElement = document.querySelector(`[data-email="${email}"]`);
    if (accountElement) {
        accountElement.classList.add('removing');
        setTimeout(() => {
            accountElement.remove();
            loadAccounts(); // Refresh the list
            hideLoading();
            showToast('Account removed successfully', 'success');
        }, 300);
    } else {
        hideLoading();
        showToast('Account removed successfully', 'success');
    }
}

function handleAddAccount(e) {
    e.preventDefault();
    
    const formData = new FormData(e.target);
    const email = formData.get('email').trim();
    const password = formData.get('password').trim();
    
    if (!email || !password) {
        showToast('Please fill in all fields', 'error');
        return;
    }
    
    if (!isValidEmail(email)) {
        showToast('Please enter a valid email address', 'error');
        return;
    }
    
    // Check if account already exists
    const accounts = JSON.parse(localStorage.getItem("recentAccounts")) || [];
    if (accounts.some(acc => acc.email === email)) {
        showToast('Account already exists', 'error');
        return;
    }
    
    hideModal('addModal');
    showLoading('Adding account...');
    
    // Simulate API call
    setTimeout(() => {
        const newAccount = {
            email: email,
            username: email.split('@')[0],
            password: password,
            addedAt: new Date().toISOString()
        };
        
        accounts.push(newAccount);
        localStorage.setItem("recentAccounts", JSON.stringify(accounts));
        
        hideLoading();
        loadAccounts();
        showToast('Account added successfully', 'success');
        
        // Reset form
        document.getElementById('addAccountForm').reset();
    }, 2000);
}

// Modal functions
function showAddModal() {
    showModal('addModal');
    // Focus on email input
    setTimeout(() => {
        document.getElementById('email').focus();
    }, 300);
}

function hideAddModal() {
    hideModal('addModal');
    document.getElementById('addAccountForm').reset();
}

function hideConfirmModal() {
    hideModal('confirmModal');
    currentDeleteEmail = null;
}

function showModal(modalId) {
    const modal = document.getElementById(modalId);
    modal.style.display = 'flex';
    setTimeout(() => {
        modal.classList.add('show');
    }, 10);
}

function hideModal(modalId) {
    const modal = document.getElementById(modalId);
    modal.classList.remove('show');
    setTimeout(() => {
        modal.style.display = 'none';
    }, 300);
}

function hideAllModals() {
    hideAddModal();
    hideConfirmModal();
}

// Loading functions
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

// Toast notifications
function showToast(message, type = 'success') {
    const container = document.getElementById('toastContainer');
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    
    const icon = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';
    
    toast.innerHTML = `
        <i class="fas ${icon}"></i>
        <span>${message}</span>
        <button class="toast-close" onclick="this.parentElement.remove()">
            <i class="fas fa-times"></i>
        </button>
    `;
    
    container.appendChild(toast);
    
    // Show toast
    setTimeout(() => {
        toast.classList.add('show');
    }, 10);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        if (toast.parentElement) {
            toast.classList.remove('show');
            setTimeout(() => {
                if (toast.parentElement) {
                    toast.remove();
                }
            }, 300);
        }
    }, 5000);
}

// Utility functions
function getInitials(name) {
    return name.split(' ')
        .map(word => word.charAt(0).toUpperCase())
        .join('')
        .substring(0, 2);
}

function getRandomGradient() {
    const gradients = [
        'linear-gradient(135deg, #667eea, #764ba2)',
        'linear-gradient(135deg, #f093fb, #f5576c)',
        'linear-gradient(135deg, #4facfe, #00f2fe)',
        'linear-gradient(135deg, #43e97b, #38f9d7)',
        'linear-gradient(135deg, #fa709a, #fee140)',
        'linear-gradient(135deg, #a8edea, #fed6e3)',
        'linear-gradient(135deg, #ff9a9e, #fecfef)',
        'linear-gradient(135deg, #ffecd2, #fcb69f)'
    ];
    return gradients[Math.floor(Math.random() * gradients.length)];
}

function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}