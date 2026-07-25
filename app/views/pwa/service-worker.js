// Service worker pro instalaci na plochu. Offline režim je až fáze 2 —
// zatím se jen registruje a pouští požadavky rovnou na server.
//
// Tady bude v další fázi cache dnešního rozvrhu a fronta zápisů (foto,
// poznámky, hotovo), která se odešle po návratu online.

self.addEventListener("install", () => {
  self.skipWaiting()
})

self.addEventListener("activate", (event) => {
  event.waitUntil(self.clients.claim())
})
