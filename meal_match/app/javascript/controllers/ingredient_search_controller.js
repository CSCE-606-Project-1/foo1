import { Controller } from "@hotwired/stimulus"

// data-controller="ingredient-search"
export default class extends Controller {
  static targets = ["input", "results", "selected"]

  connect() {
    this._timeout = null
    this._selected = new Map()
    // Mark the element so the page-level fallback can detect Stimulus is active
    try {
      this.element.dataset.ingredientSearchConnected = "true"
    } catch (e) {
      // no-op
    }
    // Debug: indicate controller connected in browser console
    try { console.debug && console.debug("[ingredient-search] connected", { hasInput: this.hasInputTarget, hasResults: this.hasResultsTarget }) } catch (e) {}
  }

  // Called on input event
  search() {
    const q = (this.inputTarget?.value || "").trim()
    try { console.debug && console.debug("[ingredient-search] input", q) } catch (e) {}
    if (this._timeout) clearTimeout(this._timeout)
    // debounce a little
    this._timeout = setTimeout(() => this._doSearch(q), 250)
  }

  async _doSearch(q) {
    if (!q) {
      this._render([])
      return
    }

    try {
      const url = `/ingredient_search?q=${encodeURIComponent(q)}`
      try { console.debug && console.debug("[ingredient-search] fetching", url) } catch (e) {}
      const res = await fetch(url, { headers: { Accept: "application/json" } })
      if (!res.ok) throw new Error("fetch failed")
      const body = await res.json()
      const items = body.ingredients || []
      try { console.debug && console.debug("[ingredient-search] got results", items.length) } catch (e) {}
      this._render(items)
    } catch (e) {
      console.warn("Ingredient search failed", e)
      this._render([])
    }
  }

  _render(items) {
    if (!this.hasResultsTarget) return
    const container = this.resultsTarget
    container.innerHTML = ""

    if (!items || items.length === 0) {
      container.hidden = true
      return
    }

    container.hidden = false
    const ul = document.createElement("ul")
    ul.style.listStyle = "none"
    ul.style.padding = "0"
    ul.style.margin = "0.5rem 0 0 0"

    items.forEach(it => {
      const li = document.createElement("li")
      li.style.padding = ".5rem"
      li.style.borderBottom = "1px solid #eee"
      li.textContent = it.name || it.title || "Unnamed"
      // attach data so we can identify the ingredient when clicked
      if (it.id) li.dataset.ingId = it.id
      if (it.name) li.dataset.ingName = it.name
      li.style.cursor = 'pointer'
  li.addEventListener('click', (e) => { e.stopPropagation(); this._toggleSelect(it) })
      ul.appendChild(li)
    })

    container.appendChild(ul)
    this._renderSelected()
  }

  _toggleSelect(it) {
    const id = String(it.id || it.provider_id || it.idIngredient || it.providerId || it.id)
    const name = it.name || it.title || it.name || 'Unnamed'
    if (!id) return
    if (this._selected.has(id)) this._selected.delete(id)
    else this._selected.set(id, name)
    this._renderSelected()
  }

  _renderSelected() {
    if (!this.hasSelectedTarget) return
    const container = this.selectedTarget
    container.innerHTML = ''
    if (this._selected.size === 0) {
      container.hidden = true
      return
    }
    container.hidden = false
    const ul = document.createElement('ul')
    ul.style.listStyle = 'none'
    ul.style.padding = '0'
    ul.style.margin = '0.5rem 0 0 0'
    Array.from(this._selected.entries()).forEach(([id, name]) => {
      const li = document.createElement('li')
      li.style.display = 'inline-block'
      li.style.padding = '.25rem .5rem'
      li.style.margin = '.25rem'
      li.style.border = '1px solid #ddd'
      li.style.borderRadius = '.5rem'
      li.style.background = '#f7f7f7'
      li.textContent = name
      li.dataset.ingId = id
      li.style.cursor = 'pointer'
      // clicking a selected item will remove it
      li.addEventListener('click', (e) => {
        // Prevent the click from bubbling up to the modal backdrop which would
        // close the modal when the element is removed during the click handler.
        e.stopPropagation()
        this._selected.delete(id)
        this._renderSelected()
      })
      ul.appendChild(li)
    })
    container.appendChild(ul)
  }
}
