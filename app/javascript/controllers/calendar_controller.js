import { Controller } from "@hotwired/stimulus"

// Obaluje FullCalendar. Knihovna se načítá jako globální skript v hlavičce
// stránky kalendáře, proto se tu sahá na window.FullCalendar.
export default class extends Controller {
  static values = {
    eventsUrl: String,
    updateUrlTemplate: String
  }

  static targets = ["container", "errorMessage"]

  connect() {
    this.calendar = new window.FullCalendar.Calendar(this.containerTarget, this.calendarOptions())
    this.calendar.render()
  }

  disconnect() {
    if (this.calendar) {
      this.calendar.destroy()
    }
  }

  calendarOptions() {
    return {
      initialView: "timeGridWeek",
      locale: "cs",
      firstDay: 1,
      slotMinTime: "06:00:00",
      slotMaxTime: "20:00:00",
      allDaySlot: false,
      height: "auto",
      nowIndicator: true,
      editable: true,
      eventStartEditable: true,
      eventDurationEditable: true,
      headerToolbar: {
        left: "prev,next today",
        center: "title",
        right: "timeGridWeek,timeGridDay"
      },
      buttonText: {
        today: "Dnes",
        week: "Týden",
        day: "Den"
      },
      events: this.eventsUrlValue,
      eventContent: (arg) => this.renderEventContent(arg),
      eventDrop: (info) => this.saveMovedVisit(info),
      eventResize: (info) => this.saveMovedVisit(info)
    }
  }

  renderEventContent(arg) {
    const time = arg.timeText
    const client = arg.event.extendedProps.client || ""
    const technician = arg.event.extendedProps.technician || ""

    return {
      html: `<div class="fc-visit">
               <div class="fc-visit-time">${time}</div>
               <div class="fc-visit-title">${arg.event.title}</div>
               <div class="fc-visit-meta">${client} · ${technician}</div>
             </div>`
    }
  }

  async saveMovedVisit(info) {
    const response = await fetch(this.updateUrlFor(info.event.id), {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({
        visit: {
          starts_at: info.event.start.toISOString(),
          ends_at: info.event.end.toISOString()
        }
      })
    })

    if (response.ok) {
      this.showError("")
      return
    }

    const body = await response.json()
    this.showError(body.error)
    info.revert()
  }

  updateUrlFor(visitId) {
    return this.updateUrlTemplateValue.replace(":id", visitId)
  }

  showError(message) {
    if (!this.hasErrorMessageTarget) return

    this.errorMessageTarget.textContent = message
    this.errorMessageTarget.classList.toggle("hidden", message === "")
  }
}
