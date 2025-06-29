// Statistic.js - Enhanced Project Overview Table Functionality

document.addEventListener('DOMContentLoaded', function() {
    initializeTable();
    setupEventListeners();
    updateTableStats();
    addAnimations();
});

// Initialize table functionality
function initializeTable() {
    populateMemberFilter();
    setupTableSorting();
    setupSearchAndFilter();
    addTooltips();
}

// Setup event listeners
function setupEventListeners() {
    // Search input
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('input', debounce(handleSearch, 300));
    }

    // Filter selects
    const statusFilter = document.getElementById('statusFilter');
    const memberFilter = document.getElementById('memberFilter');
    
    if (statusFilter) {
        statusFilter.addEventListener('change', handleFilter);
    }
    
    if (memberFilter) {
        memberFilter.addEventListener('change', handleFilter);
    }

    // Table row clicks
    const tableRows = document.querySelectorAll('.table-row');
    tableRows.forEach(row => {
        row.addEventListener('click', handleRowClick);
    });
}

// Populate member filter dropdown
function populateMemberFilter() {
    const memberFilter = document.getElementById('memberFilter');
    if (!memberFilter) return;

    const members = new Set();
    const rows = document.querySelectorAll('.table-row');
    
    rows.forEach(row => {
        const memberName = row.getAttribute('data-member');
        if (memberName && memberName.trim()) {
            members.add(memberName);
        }
    });

    // Clear existing options except the first one
    memberFilter.innerHTML = '<option value="">Tất cả thành viên</option>';
    
    // Add member options
    Array.from(members).sort().forEach(member => {
        const option = document.createElement('option');
        option.value = member;
        option.textContent = member;
        memberFilter.appendChild(option);
    });
}

// Setup table sorting
function setupTableSorting() {
    const sortableHeaders = document.querySelectorAll('.sortable');
    
    sortableHeaders.forEach(header => {
        header.addEventListener('click', function() {
            const column = this.getAttribute('data-column');
            const currentOrder = this.getAttribute('data-order') || 'asc';
            const newOrder = currentOrder === 'asc' ? 'desc' : 'asc';
            
            // Reset all headers
            sortableHeaders.forEach(h => {
                h.classList.remove('sorted');
                h.removeAttribute('data-order');
                const icon = h.querySelector('.sort-icon');
                if (icon) {
                    icon.className = 'fas fa-sort sort-icon';
                }
            });
            
            // Set current header
            this.classList.add('sorted');
            this.setAttribute('data-order', newOrder);
            const icon = this.querySelector('.sort-icon');
            if (icon) {
                icon.className = `fas fa-sort-${newOrder === 'asc' ? 'up' : 'down'} sort-icon`;
            }
            
            sortTable(column, newOrder);
        });
    });
}

// Sort table function
function sortTable(column, order) {
    const tbody = document.getElementById('tableBody');
    if (!tbody) return;

    const rows = Array.from(tbody.querySelectorAll('.table-row'));
    
    rows.sort((a, b) => {
        let aVal, bVal;
        
        switch(column) {
            case 'member':
                aVal = a.getAttribute('data-member') || '';
                bVal = b.getAttribute('data-member') || '';
                break;
            case 'role':
                aVal = a.querySelector('.role-badge')?.textContent || '';
                bVal = b.querySelector('.role-badge')?.textContent || '';
                break;
            case 'task':
                aVal = a.querySelector('.task-title')?.textContent || '';
                bVal = b.querySelector('.task-title')?.textContent || '';
                break;
            case 'due':
                aVal = a.querySelector('.date-text')?.textContent || '';
                bVal = b.querySelector('.date-text')?.textContent || '';
                // Convert to date for proper sorting
                aVal = new Date(aVal);
                bVal = new Date(bVal);
                break;
            case 'created':
                const createdCells = a.querySelectorAll('.date-text');
                aVal = createdCells[1]?.textContent || '';
                const createdCellsB = b.querySelectorAll('.date-text');
                bVal = createdCellsB[1]?.textContent || '';
                aVal = new Date(aVal);
                bVal = new Date(bVal);
                break;
            case 'status':
                aVal = a.getAttribute('data-status') || '';
                bVal = b.getAttribute('data-status') || '';
                break;
            default:
                return 0;
        }
        
        if (aVal < bVal) return order === 'asc' ? -1 : 1;
        if (aVal > bVal) return order === 'asc' ? 1 : -1;
        return 0;
    });
    
    // Re-append sorted rows
    rows.forEach(row => tbody.appendChild(row));
    
    // Add animation
    rows.forEach((row, index) => {
        setTimeout(() => {
            row.style.animation = 'slideIn 0.3s ease-out';
        }, index * 50);
    });
}

// Setup search and filter functionality
function setupSearchAndFilter() {
    // Initial filter setup is done in event listeners
}

// Handle search functionality
function handleSearch(event) {
    const searchTerm = event.target.value.toLowerCase().trim();
    const rows = document.querySelectorAll('.table-row');
    let visibleCount = 0;
    
    rows.forEach(row => {
        const taskTitle = row.querySelector('.task-title')?.textContent.toLowerCase() || '';
        const description = row.querySelector('.description-text')?.textContent.toLowerCase() || '';
        const memberName = row.getAttribute('data-member')?.toLowerCase() || '';
        const creator = row.querySelector('.creator-name')?.textContent.toLowerCase() || '';
        
        const isVisible = taskTitle.includes(searchTerm) || 
                         description.includes(searchTerm) || 
                         memberName.includes(searchTerm) || 
                         creator.includes(searchTerm);
        
        if (isVisible) {
            row.style.display = '';
            row.classList.add('fade-in');
            visibleCount++;
        } else {
            row.style.display = 'none';
            row.classList.remove('fade-in');
        }
    });
    
    // Show/hide empty state
    toggleEmptyState(visibleCount === 0);
    updateTableStats();
}

// Handle filter functionality
function handleFilter() {
    const statusFilter = document.getElementById('statusFilter')?.value || '';
    const memberFilter = document.getElementById('memberFilter')?.value || '';
    const rows = document.querySelectorAll('.table-row');
    let visibleCount = 0;
    
    rows.forEach(row => {
        const rowStatus = row.getAttribute('data-status') || '';
        const rowMember = row.getAttribute('data-member') || '';
        
        const statusMatch = !statusFilter || rowStatus === statusFilter;
        const memberMatch = !memberFilter || rowMember === memberFilter;
        
        if (statusMatch && memberMatch) {
            row.style.display = '';
            row.classList.add('fade-in');
            visibleCount++;
        } else {
            row.style.display = 'none';
            row.classList.remove('fade-in');
        }
    });
    
    // Show/hide empty state
    toggleEmptyState(visibleCount === 0);
    updateTableStats();
}

// Toggle empty state
function toggleEmptyState(show) {
    let emptyRow = document.querySelector('.empty-row');
    
    if (show && !emptyRow) {
        const tbody = document.getElementById('tableBody');
        if (tbody) {
            emptyRow = document.createElement('tr');
            emptyRow.className = 'empty-row';
            emptyRow.innerHTML = `
                <td colspan="8">
                    <div class="empty-state">
                        <i class="fas fa-search"></i>
                        <p>Không tìm thấy kết quả phù hợp</p>
                    </div>
                </td>
            `;
            tbody.appendChild(emptyRow);
        }
    } else if (!show && emptyRow) {
        emptyRow.remove();
    }
}

// Handle row click
function handleRowClick(event) {
    // Don't trigger if clicking on interactive elements
    if (event.target.closest('button') || event.target.closest('a')) {
        return;
    }
    
    const row = event.currentTarget;
    
    // Toggle row selection
    document.querySelectorAll('.table-row').forEach(r => r.classList.remove('selected'));
    row.classList.add('selected');
    
    // Add visual feedback
    row.style.transform = 'scale(1.02)';
    setTimeout(() => {
        row.style.transform = '';
    }, 200);
    
    // You can add more functionality here, like showing task details
    const taskTitle = row.querySelector('.task-title')?.textContent;
    if (taskTitle) {
        console.log('Selected task:', taskTitle);
        // Could open a modal or navigate to task details
    }
}

// Update table statistics
function updateTableStats() {
    const visibleRows = document.querySelectorAll('.table-row[style=""], .table-row:not([style])');
    const totalTasks = visibleRows.length;
    
    // Count unique members
    const uniqueMembers = new Set();
    visibleRows.forEach(row => {
        const member = row.getAttribute('data-member');
        if (member && member.trim()) {
            uniqueMembers.add(member);
        }
    });
    
    // Count completed tasks
    const completedTasks = Array.from(visibleRows).filter(row => 
        row.getAttribute('data-status')?.toLowerCase().includes('completed')
    ).length;
    
    // Update stats display
    const totalTasksEl = document.getElementById('totalTasks');
    const totalMembersEl = document.getElementById('totalMembers');
    const completedTasksEl = document.getElementById('completedTasks');
    
    if (totalTasksEl) totalTasksEl.textContent = totalTasks;
    if (totalMembersEl) totalMembersEl.textContent = uniqueMembers.size;
    if (completedTasksEl) completedTasksEl.textContent = completedTasks;
}

// Add animations to elements
function addAnimations() {
    // Animate project header card
    const headerCard = document.querySelector('.project-header-card');
    if (headerCard) {
        headerCard.classList.add('fade-in');
    }
    
    // Animate table rows with stagger effect
    const rows = document.querySelectorAll('.table-row');
    rows.forEach((row, index) => {
        setTimeout(() => {
            row.classList.add('slide-in');
        }, index * 100);
    });
    
    // Animate controls
    const controls = document.querySelector('.table-controls');
    if (controls) {
        setTimeout(() => {
            controls.classList.add('fade-in');
        }, 300);
    }
}

// Add tooltips to elements
function addTooltips() {
    // Add tooltips to status badges
    const statusBadges = document.querySelectorAll('.status-badge');
    statusBadges.forEach(badge => {
        const status = badge.textContent.trim();
        let tooltipText = '';
        
        switch(status.toLowerCase()) {
            case 'pending':
                tooltipText = 'Công việc đang chờ xử lý';
                break;
            case 'in progress':
                tooltipText = 'Công việc đang được thực hiện';
                break;
            case 'completed':
                tooltipText = 'Công việc đã hoàn thành';
                break;
        }
        
        if (tooltipText) {
            badge.classList.add('tooltip');
            badge.setAttribute('data-tooltip', tooltipText);
        }
    });
    
    // Add tooltips to role badges
    const roleBadges = document.querySelectorAll('.role-badge');
    roleBadges.forEach(badge => {
        const role = badge.textContent.trim().toLowerCase();
        let tooltipText = '';
        
        switch(role) {
            case 'leader':
                tooltipText = 'Người lãnh đạo dự án';
                break;
            case 'member':
                tooltipText = 'Thành viên dự án';
                break;
            case 'developer':
                tooltipText = 'Nhà phát triển';
                break;
            case 'designer':
                tooltipText = 'Nhà thiết kế';
                break;
        }
        
        if (tooltipText) {
            badge.classList.add('tooltip');
            badge.setAttribute('data-tooltip', tooltipText);
        }
    });
}

// Export PDF functionality
function exportPDF() {
    const exportBtn = document.querySelector('.export-btn');
    if (exportBtn) {
        exportBtn.classList.add('loading');
        exportBtn.disabled = true;
        
        // Simulate loading
        setTimeout(() => {
            // Create form and submit
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = document.querySelector('form[action*="exportPDF"]')?.action || '/exportPDF';
            document.body.appendChild(form);
            form.submit();
            
            // Reset button state
            exportBtn.classList.remove('loading');
            exportBtn.disabled = false;
        }, 1000);
    }
}

// Refresh data functionality
function refreshData() {
    const refreshBtn = document.querySelector('.refresh-btn');
    if (refreshBtn) {
        refreshBtn.style.animation = 'spin 1s linear';
        
        // Simulate data refresh
        setTimeout(() => {
            refreshBtn.style.animation = '';
            location.reload();
        }, 1000);
    }
}

// Utility function: Debounce
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Keyboard shortcuts
document.addEventListener('keydown', function(event) {
    // Ctrl/Cmd + F for search
    if ((event.ctrlKey || event.metaKey) && event.key === 'f') {
        event.preventDefault();
        const searchInput = document.getElementById('searchInput');
        if (searchInput) {
            searchInput.focus();
        }
    }
    
    // Escape to clear search
    if (event.key === 'Escape') {
        const searchInput = document.getElementById('searchInput');
        if (searchInput && searchInput === document.activeElement) {
            searchInput.value = '';
            handleSearch({ target: searchInput });
            searchInput.blur();
        }
    }
});

// Add CSS for selected row state
const style = document.createElement('style');
style.textContent = `
    .table-row.selected {
        background: rgba(255, 93, 0, 0.1) !important;
        border-left: 4px solid #FF5D00;
    }
    
    body.dark-mode .table-row.selected {
        background: rgba(255, 93, 0, 0.2) !important;
    }
`;
document.head.appendChild(style);