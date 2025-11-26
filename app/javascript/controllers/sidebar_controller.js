import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar"
export default class extends Controller {
  connect() {
    console.log("Sidebar controller connected")
    this.setupKeyboardShortcut()
  }

  disconnect() {
    this.removeKeyboardShortcut()
  }

  // Toggle sidebar on mobile
  toggle(event) {
    console.log("Toggle clicked!")
    // Find the sidebar element
    const sidebar = document.querySelector('.app-sidebar')
    if (sidebar) {
      sidebar.classList.toggle('open')
      console.log("Sidebar toggled, open:", sidebar.classList.contains('open'))
    }

    const overlay = document.querySelector('.sidebar-overlay')
    if (overlay) {
      overlay.classList.toggle('active')
    }
  }

  // Close sidebar when clicking overlay
  closeFromOverlay(event) {
    if (event.target.classList.contains('sidebar-overlay')) {
      this.close()
    }
  }

  close() {
    // Find the sidebar element
    const sidebar = document.querySelector('.app-sidebar')
    if (sidebar) {
      sidebar.classList.remove('open')
    }

    const overlay = document.querySelector('.sidebar-overlay')
    if (overlay) {
      overlay.classList.remove('active')
    }
  }

  // Global search functionality
  handleSearch(event) {
    const query = event.target.value.trim()

    if (query === '' || query.length < 2) {
      this.clearSearch()
      return
    }

    // Debounce search requests
    clearTimeout(this.searchTimeout)
    this.searchTimeout = setTimeout(() => {
      this.performGlobalSearch(query)
    }, 300)
  }

  async performGlobalSearch(query) {
    try {
      const response = await fetch(`/search?query=${encodeURIComponent(query)}`, {
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })

      if (!response.ok) throw new Error('Search failed')

      const data = await response.json()
      this.displaySearchResults(data.results)
    } catch (error) {
      console.error('Search error:', error)
    }
  }

  displaySearchResults(results) {
    // Get or create results container
    let resultsContainer = document.querySelector('.search-results-dropdown')

    if (!resultsContainer) {
      resultsContainer = document.createElement('div')
      resultsContainer.className = 'search-results-dropdown'
      const searchBox = this.element.querySelector('.sidebar-search-section')
      searchBox.appendChild(resultsContainer)
    }

    if (results.length === 0) {
      resultsContainer.innerHTML = `
        <div class="search-no-results">
          <i class="fas fa-search"></i>
          <span>Aucun résultat trouvé</span>
        </div>
      `
      resultsContainer.classList.add('active')
      return
    }

    // Group results by type
    const groupedResults = this.groupResultsByType(results)

    let html = ''

    for (const [type, items] of Object.entries(groupedResults)) {
      const typeLabels = {
        'task': 'Tâches',
        'event': 'Événements',
        'document': 'Documents',
        'member': 'Membres'
      }

      html += `<div class="search-results-group">
        <div class="search-results-group-title">${typeLabels[type] || type}</div>`

      items.forEach(item => {
        const iconColor = item.color || '#667eea'
        html += `
          <a href="${item.url}" class="search-result-item">
            <div class="search-result-icon" style="color: ${iconColor}">
              <i class="fas fa-${item.icon}"></i>
            </div>
            <div class="search-result-content">
              <div class="search-result-title">${item.title}</div>
              <div class="search-result-subtitle">${item.subtitle}</div>
            </div>
            ${item.status ? `<span class="search-result-badge">${item.status}</span>` : ''}
          </a>
        `
      })

      html += `</div>`
    }

    resultsContainer.innerHTML = html
    resultsContainer.classList.add('active')
  }

  groupResultsByType(results) {
    return results.reduce((groups, item) => {
      const type = item.type
      if (!groups[type]) {
        groups[type] = []
      }
      groups[type].push(item)
      return groups
    }, {})
  }

  clearSearch() {
    // Hide search results dropdown
    const resultsContainer = document.querySelector('.search-results-dropdown')
    if (resultsContainer) {
      resultsContainer.classList.remove('active')
      resultsContainer.innerHTML = ''
    }
  }

  // Keyboard shortcut for search (Cmd+K or Ctrl+K)
  handleSearchShortcut(event) {
    if ((event.metaKey || event.ctrlKey) && event.key === 'k') {
      event.preventDefault()
      const searchInput = this.element.querySelector('.sidebar-search-box input')
      if (searchInput) {
        searchInput.focus()
        searchInput.select()
      }
    }

    // ESC to clear search
    if (event.key === 'Escape') {
      event.target.value = ''
      this.clearSearch()
      event.target.blur()
    }
  }

  setupKeyboardShortcut() {
    this.keydownHandler = (event) => {
      if ((event.metaKey || event.ctrlKey) && event.key === 'k') {
        event.preventDefault()
        const searchInput = this.element.querySelector('.sidebar-search-box input')
        if (searchInput) {
          searchInput.focus()
          searchInput.select()
        }
      }
    }
    document.addEventListener('keydown', this.keydownHandler)
  }

  removeKeyboardShortcut() {
    if (this.keydownHandler) {
      document.removeEventListener('keydown', this.keydownHandler)
    }
  }
}
