/**
 * OceanView Resort Management System - Client-side JavaScript
 * Using Native Vanilla JavaScript (No frameworks)
 */

// ============================================================================
// Utility Functions
// ============================================================================

/**
 * Get element by ID
 */
function getElementById(id) {
    return document.getElementById(id);
}

/**
 * Get elements by class name
 */
function getElementsByClass(className) {
    return document.getElementsByClassName(className);
}

/**
 * Add event listener to element
 */
function addEventListener(element, event, handler) {
    if (element) {
        element.addEventListener(event, handler);
    }
}

/**
 * Show or hide element
 */
function toggleVisibility(elementId) {
    const element = getElementById(elementId);
    if (element) {
        element.style.display = element.style.display === 'none' ? 'block' : 'none';
    }
}

/**
 * Validate email format
 */
function validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

/**
 * Validate form fields
 */
function validateFormField(fieldId) {
    const field = getElementById(fieldId);
    if (!field) return false;

    if (field.type === 'email') {
        return validateEmail(field.value);
    }

    return field.value.trim().length > 0;
}

/**
 * Fetch API wrapper for making HTTP requests
 */
async function makeRequest(method, url, data = null) {
    try {
        const options = {
            method: method,
            headers: {
                'Content-Type': 'application/json'
            }
        };

        if (data) {
            options.body = JSON.stringify(data);
        }

        const response = await fetch(url, options);

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        return await response.json();
    } catch (error) {
        console.error('Request error:', error);
        throw error;
    }
}

/**
 * Display notification message
 */
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 1rem;
        border-radius: 4px;
        z-index: 1000;
        animation: slideIn 0.3s ease-in-out;
    `;

    // Style based on type
    const colors = {
        'success': '#4CAF50',
        'error': '#f44336',
        'warning': '#ff9800',
        'info': '#2196F3'
    };

    notification.style.backgroundColor = colors[type] || colors['info'];
    notification.style.color = 'white';

    document.body.appendChild(notification);

    // Remove after 3 seconds
    setTimeout(() => {
        notification.remove();
    }, 3000);
}

/**
 * Initialize event listeners on page load
 */
document.addEventListener('DOMContentLoaded', function() {
    console.log('OceanView Resort Management System - JavaScript initialized');

    // Add custom initialization code here
});

// ============================================================================
// Form Submission Handlers
// ============================================================================

/**
 * Handle generic form submission with validation
 */
function handleFormSubmit(formId, actionUrl) {
    const form = getElementById(formId);
    if (!form) return;

    form.addEventListener('submit', function(e) {
        e.preventDefault();

        // Validate form
        const formData = new FormData(form);
        const data = Object.fromEntries(formData);

        // Basic validation
        let isValid = true;
        for (const [key, value] of Object.entries(data)) {
            if (!value || value.trim().length === 0) {
                isValid = false;
                showNotification(`Field ${key} is required`, 'error');
                break;
            }
        }

        if (!isValid) {
            return;
        }

        // Submit form
        makeRequest('POST', actionUrl, data)
            .then(response => {
                showNotification('Operation successful!', 'success');
                // Redirect or update UI as needed
            })
            .catch(error => {
                showNotification('Operation failed!', 'error');
            });
    });
}

// ============================================================================
// Table Operations
// ============================================================================

/**
 * Sort table by column
 */
function sortTable(tableId, columnIndex) {
    const table = getElementById(tableId);
    if (!table) return;

    const rows = Array.from(table.querySelectorAll('tbody tr'));
    rows.sort((a, b) => {
        const aValue = a.cells[columnIndex].textContent.trim();
        const bValue = b.cells[columnIndex].textContent.trim();
        return aValue.localeCompare(bValue);
    });

    const tbody = table.querySelector('tbody');
    rows.forEach(row => tbody.appendChild(row));
}

/**
 * Filter table rows by search term
 */
function filterTable(tableId, searchTerm) {
    const table = getElementById(tableId);
    if (!table) return;

    const rows = table.querySelectorAll('tbody tr');
    const searchLower = searchTerm.toLowerCase();

    rows.forEach(row => {
        const text = row.textContent.toLowerCase();
        row.style.display = text.includes(searchLower) ? '' : 'none';
    });
}

// ============================================================================
// Modal/Dialog Functions
// ============================================================================

/**
 * Show modal dialog
 */
function showModal(modalId) {
    const modal = getElementById(modalId);
    if (modal) {
        modal.style.display = 'block';
    }
}

/**
 * Close modal dialog
 */
function closeModal(modalId) {
    const modal = getElementById(modalId);
    if (modal) {
        modal.style.display = 'none';
    }
}

/**
 * Close modal when clicking outside content
 */
document.addEventListener('click', function(event) {
    if (event.target.classList.contains('modal')) {
        event.target.style.display = 'none';
    }
});

console.log('OceanView Resort Management System - JavaScript library loaded successfully');

