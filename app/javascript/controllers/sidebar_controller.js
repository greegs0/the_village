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

  // Search functionality
  handleSearch(event) {
    const query = event.target.value.toLowerCase().trim()

    if (query === '') {
      this.clearSearch()
      return
    }

    const navLinks = this.element.querySelectorAll('.sidebar-nav-link')
    let hasResults = false

    navLinks.forEach(link => {
      const text = link.textContent.toLowerCase()
      if (text.includes(query)) {
        link.style.display = 'flex'
        link.classList.add('search-highlight')
        hasResults = true
      } else {
        link.style.display = 'none'
        link.classList.remove('search-highlight')
      }
    })

    // Show/hide group labels based on results
    const groups = this.element.querySelectorAll('.sidebar-nav-group')
    groups.forEach(group => {
      const visibleLinks = group.querySelectorAll('.sidebar-nav-link[style="display: flex;"]')
      group.style.display = visibleLinks.length > 0 ? 'block' : 'none'
    })
  }

  clearSearch() {
    const navLinks = this.element.querySelectorAll('.sidebar-nav-link')
    navLinks.forEach(link => {
      link.style.display = 'flex'
      link.classList.remove('search-highlight')
    })

    const groups = this.element.querySelectorAll('.sidebar-nav-group')
    groups.forEach(group => {
      group.style.display = 'block'
    })
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
