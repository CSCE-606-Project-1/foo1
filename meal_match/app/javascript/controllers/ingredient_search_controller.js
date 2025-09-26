import { Controller } from "@hotwired/stimulus"

// data-controller="ingredient-search"
export default class extends Controller {
  static targets = ["input", "results"]

  connect() {
    this._timeout = null
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
      li.textContent = it.name || "Unnamed"
      ul.appendChild(li)
    })

    container.appendChild(ul)
  }
}
