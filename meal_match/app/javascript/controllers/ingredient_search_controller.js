import { Controller } from "@hotwired/stimulus"

// data-controller="ingredient-search"
export default class extends Controller {
  static targets = ["input", "results"]

  connect() {
    // bind once so we can remove the same handler on disconnect
    this._boundOnInput = this.onInput.bind(this)
    if (this.hasInputTarget) this.inputTarget.addEventListener('input', this._boundOnInput)
    console.debug('[ingredient-search] connected', { hasInput: this.hasInputTarget, hasResults: this.hasResultsTarget })
  }

  disconnect() {
    if (this.hasInputTarget && this._boundOnInput) this.inputTarget.removeEventListener('input', this._boundOnInput)
  }

  onInput(_e) {
    const q = this.inputTarget.value.trim()
    console.debug('[ingredient-search] input', { q })
    if (q.length < 2) {
      this._clear()
      return
    }

    fetch(`/ingredient_search?q=${encodeURIComponent(q)}`, {
      headers: { Accept: 'application/json' },
      credentials: 'same-origin'
    })
      .then(r => {
        const ct = r.headers.get('content-type') || ''
        // If redirect sent HTML (e.g. login page), treat as failure
        if (!r.ok || !ct.includes('application/json')) return Promise.reject({ response: r, contentType: ct })
        return r.json()
      })
      .then(data => this._renderResults(data))
      .catch(err => {
        // If redirected to login, you may get HTML back — clear results and log
        console.warn('[ingredient-search] fetch failed or returned non-JSON:', err)
        this._clear()
      })
  }

  _renderResults(data) {
    console.debug('[ingredient-search] renderResults', { count: Array.isArray(data) ? data.length : 0 })
    if (!this.hasResultsTarget) return
    if (!Array.isArray(data)) { this._clear(); return }

    this.resultsTarget.innerHTML = data.slice(0,10).map(item => {
      const name = item.description || item.food_name || item.lower_case_description || ''
      const brand = item.brand_owner ? ` — ${item.brand_owner}` : ''
      const id = item.fdcId || item.fdc_id || ''
      return `<div class="ingredient-result" data-fdc-id="${id}" style="padding:.25rem .5rem;border-bottom:1px solid #eee;">${name}${brand}</div>`
    }).join('')
    // small click handler to confirm interactivity
    this.resultsTarget.querySelectorAll('.ingredient-result').forEach(el => {
      el.addEventListener('click', () => console.debug('[ingredient-search] clicked', { fdcId: el.dataset.fdcId, text: el.textContent }))
    })
  }

  _clear() {
    if (this.hasResultsTarget) this.resultsTarget.innerHTML = ''
  }
}
