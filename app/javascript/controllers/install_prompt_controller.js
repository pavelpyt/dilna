import { Controller } from "@hotwired/stimulus"

// Nabídne přidání na plochu. Android umí systémový dialog, iOS ne — tam se
// musí ukázat gesto ručně, jinak si to uživatel nenajde.
export default class extends Controller {
  static targets = ["androidButton", "iosHint"]

  connect() {
    if (this.alreadyInstalled()) {
      this.element.hidden = true
      return
    }

    this.deferredPrompt = null

    window.addEventListener("beforeinstallprompt", this.captureInstallPrompt)

    if (this.isIos()) {
      this.iosHintTarget.hidden = false
    }
  }

  disconnect() {
    window.removeEventListener("beforeinstallprompt", this.captureInstallPrompt)
  }

  captureInstallPrompt = (event) => {
    event.preventDefault()
    this.deferredPrompt = event
    this.androidButtonTarget.hidden = false
  }

  async install() {
    if (!this.deferredPrompt) return

    this.deferredPrompt.prompt()
    await this.deferredPrompt.userChoice
    this.deferredPrompt = null
    this.element.hidden = true
  }

  dismiss() {
    this.element.hidden = true
  }

  alreadyInstalled() {
    return window.matchMedia("(display-mode: standalone)").matches || window.navigator.standalone === true
  }

  isIos() {
    return /iphone|ipad|ipod/i.test(window.navigator.userAgent)
  }
}
