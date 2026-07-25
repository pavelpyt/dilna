// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Service worker běží kvůli instalaci na plochu. Offline režim je až fáze 2.
if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("/service-worker")
}
