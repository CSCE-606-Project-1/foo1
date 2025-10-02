import { Controller } from "@hotwired/stimulus"

// data-controller="ingredient-search"
export default class extends Controller {
  static targets = ["input", "results", "selected", "hiddenInputs"]
  static values = {
    preselected: Array
  }

  connect() {
    this._timeout = null
    this._selected = new Map()

    if (this.hasPreselectedValue) {
      try {
        this.preselectedValue.forEach((item) => {
          if (!item) return
          const id = this._normalizeId(item.id)
          if (!id) return
          const name = this._nameFor(item)
          this._selected.set(id, name)
        })
      } catch (e) {
        console.warn("[ingredient-search] failed to hydrate preselected items", e)
      }
    }

    try {
      this.element.dataset.ingredientSearchConnected = "true"
    } catch (e) {
      // no-op
    }

    this._renderSelected()

    try {
      console.debug && console.debug("[ingredient-search] connected", {
        hasInput: this.hasInputTarget,
        hasResults: this.hasResultsTarget
      })
    } catch (e) {
      // debug only
    }
  }

  // Called on input event
  search() {
    const q = (this.hasInputTarget ? this.inputTarget.value : "").trim()
    try { console.debug && console.debug("[ingredient-search] input", q) } catch (e) {}
    if (this._timeout) clearTimeout(this._timeout)
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

    items.forEach((raw) => {
      const id = this._normalizeId(raw && (raw.id || raw.provider_id || raw.idIngredient || raw.providerId))
      const name = this._nameFor(raw)
      const li = document.createElement("li")
      li.style.padding = ".5rem"
      li.style.borderBottom = "1px solid #eee"
      li.style.cursor = "pointer"
      li.textContent = name
      if (id) {
        li.dataset.ingId = id
        if (this._selected.has(id)) li.setAttribute("aria-pressed", "true")
      }
      li.addEventListener("click", (event) => {
        event.stopPropagation()
        this._toggleSelect({ id, name })
      })
      ul.appendChild(li)
    })

    container.appendChild(ul)
    this._renderSelected()
  }

  _toggleSelect(item) {
    const id = this._normalizeId(item && item.id)
    if (!id) return
    const name = this._nameFor(item)

    if (this._selected.has(id)) {
      this._selected.delete(id)
    } else {
      this._selected.set(id, name)
    }

    this._renderSelected()
  }

  _renderSelected() {
    if (!this.hasSelectedTarget) return

    const container = this.selectedTarget
    container.innerHTML = ""

    if (this._selected.size === 0) {
      container.hidden = true
      this._syncHiddenInputs()
      return
    }

    container.hidden = false
    const ul = document.createElement("ul")
    ul.style.listStyle = "none"
    ul.style.padding = "0"
    ul.style.margin = "0.5rem 0 0 0"

    Array.from(this._selected.entries()).forEach(([id, name]) => {
      const li = document.createElement("li")
      li.style.display = "inline-block"
      li.style.padding = ".25rem .5rem"
      li.style.margin = ".25rem"
      li.style.border = "1px solid #ddd"
      li.style.borderRadius = ".5rem"
      li.style.background = "#f7f7f7"
      li.style.cursor = "pointer"
      li.dataset.ingId = id
      li.textContent = name
      li.addEventListener("click", (event) => {
        event.stopPropagation()
        this._selected.delete(id)
        this._renderSelected()
      })
      ul.appendChild(li)
    })

    container.appendChild(ul)
    this._syncHiddenInputs()
  }

  _syncHiddenInputs() {
    if (!this.hasHiddenInputsTarget) return
    const container = this.hiddenInputsTarget
    container.innerHTML = ""
    this._selected.forEach((_, id) => {
      const input = document.createElement("input")
      input.type = "hidden"
      input.name = "ingredient_list[selected_ingredient_ids][]"
      input.value = id
      container.appendChild(input)
    })
  }

  _normalizeId(value) {
    if (value === undefined || value === null) return null
    const str = String(value).trim()
    return str.length === 0 ? null : str
  }

  _nameFor(item) {
    if (!item) return "Unnamed"
    return item.name || item.title || item.strIngredient || item.stringredient || "Unnamed"
  }
}
