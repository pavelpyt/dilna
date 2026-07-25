# Demo data, aby šlo všechno proklikat hned po `bin/rails db:seed`.
# Skript je idempotentní — jde ho pustit opakovaně.

demo_account = Account.find_or_create_by!(slug: "novak-topeni-voda") do |account|
  account.name = "Novák — topení a voda"
  account.phone = "+420 602 118 340"
  account.email = "servis@novak-topeni.cz"
end

owner = User.find_or_initialize_by(email: "petr@novak-topeni.cz")
owner.assign_attributes(
  account: demo_account,
  first_name: "Petr",
  last_name: "Novák",
  phone: "+420 602 118 340",
  role: "owner",
  password: "heslo1234",
  password_confirmation: "heslo1234"
)
owner.save!

technicians = [
  { email: "tomas@novak-topeni.cz", first_name: "Tomáš", last_name: "Dvořák", phone: "+420 605 221 118" },
  { email: "jakub@novak-topeni.cz", first_name: "Jakub", last_name: "Král", phone: "+420 606 774 902" }
]

technicians.each do |technician_attributes|
  technician = User.find_or_initialize_by(email: technician_attributes[:email])
  technician.assign_attributes(
    technician_attributes.merge(
      account: demo_account,
      role: "staff",
      password: "heslo1234",
      password_confirmation: "heslo1234"
    )
  )
  technician.save!
end

u_kotvy = demo_account.clients.find_or_initialize_by(name: "Restaurace U Kotvy s.r.o.")
u_kotvy.assign_attributes(
  client_type: "company",
  company_registration_number: "24178901",
  vat_identification_number: "CZ24178901",
  phone: "+420 602 118 340",
  email: "provoz@ukotvy.cz",
  note: "Polední provoz 11–14, na havárie volají přímo provoznímu."
)
u_kotvy.save!

u_kotvy.properties.find_or_initialize_by(street: "Bělehradská 45").tap do |property|
  property.assign_attributes(label: "Hlavní provozovna", city: "Praha 2", postal_code: "120 00")
  property.save!
end

u_kotvy.properties.find_or_initialize_by(street: "Táborská 3").tap do |property|
  property.assign_attributes(label: "Sklad a zázemí", city: "Praha 4 — Nusle", postal_code: "140 00")
  property.save!
end

u_kotvy.contacts.find_or_initialize_by(last_name: "Kolář").tap do |contact|
  contact.assign_attributes(first_name: "Martin", position: "provozní", phone: "+420 602 118 340")
  contact.save!
end

u_kotvy.contacts.find_or_initialize_by(last_name: "Vávrová").tap do |contact|
  contact.assign_attributes(first_name: "Eva", position: "fakturace", email: "ucetni@ukotvy.cz")
  contact.save!
end

svobodova = demo_account.clients.find_or_initialize_by(name: "Jana Svobodová")
svobodova.assign_attributes(client_type: "person", phone: "+420 731 448 210", email: "jana.svobodova@email.cz")
svobodova.save!

svobodova.properties.find_or_initialize_by(street: "Korunní 88").tap do |property|
  property.assign_attributes(label: "Byt 3. patro", city: "Praha 2", postal_code: "101 00")
  property.save!
end

penzion = demo_account.clients.find_or_initialize_by(name: "Penzion Vyhlídka s.r.o.")
penzion.assign_attributes(
  client_type: "company",
  company_registration_number: "05512477",
  phone: "+420 777 310 550",
  email: "recepce@penzion-vyhlidka.cz"
)
penzion.save!

penzion.properties.find_or_initialize_by(street: "Slezská 21").tap do |property|
  property.assign_attributes(label: "Penzion", city: "Praha 2 — Vinohrady", postal_code: "120 00")
  property.save!
end

price_list = [
  { name: "Instalatérské práce", unit: "hod", unit_price: 650, vat_rate: 21, margin_percent: 55 },
  { name: "Výjezd — havárie (mimo pracovní dobu)", unit: "ks", unit_price: 900, vat_rate: 21, margin_percent: 70 },
  { name: "Doprava", unit: "km", unit_price: 12, vat_rate: 21, margin_percent: 30 },
  { name: "Servis plynového kotle", unit: "ks", unit_price: 1_890, vat_rate: 21, margin_percent: 45 },
  { name: "Materiál — spojka, těsnění, koleno", unit: "sada", unit_price: 840, vat_rate: 21, margin_percent: 20 }
]

price_list.each do |service_attributes|
  service = demo_account.services.find_or_initialize_by(name: service_attributes[:name])
  service.assign_attributes(service_attributes)
  service.save!
end

havarie = demo_account.jobs.find_or_initialize_by(title: "Havárie — prasklá trubka")
havarie.assign_attributes(
  client: u_kotvy,
  property: u_kotvy.properties.find_by(street: "Bělehradská 45"),
  status: "in_progress",
  description: "Volali že teče voda, priorita — restaurace má polední provoz."
)
havarie.save!

if havarie.job_items.empty?
  havarie.job_items.create!(description: "Výjezd — havárie (mimo pracovní dobu)", quantity: 1, unit: "ks", unit_price: 900, position: 1)
  havarie.job_items.create!(description: "Instalatérské práce", quantity: 2.5, unit: "hod", unit_price: 650, position: 2)
  havarie.job_items.create!(description: "Materiál — spojka, těsnění, koleno", quantity: 1, unit: "sada", unit_price: 840, position: 3)
  havarie.job_items.create!(description: "Doprava", quantity: 18, unit: "km", unit_price: 12, position: 4)
end

if havarie.notes.empty?
  havarie.notes.create!(user: owner, body: "Prasklý spoj pod dřezem v kuchyni, voda tekla do sklepa. Uzávěr byl zatuhlý.")
end

servis_kotle = demo_account.jobs.find_or_initialize_by(title: "Servis plynového kotle")
servis_kotle.assign_attributes(
  client: penzion,
  property: penzion.properties.first,
  status: "completed",
  description: "Roční servis kotle před sezónou."
)
servis_kotle.save!

if servis_kotle.job_items.empty?
  servis_kotle.job_items.create!(description: "Servis plynového kotle", quantity: 1, unit: "ks", unit_price: 1_890, position: 1)
end

baterie = demo_account.jobs.find_or_initialize_by(title: "Výměna baterie v koupelně")
baterie.assign_attributes(
  client: svobodova,
  property: svobodova.properties.first,
  status: "approved",
  description: "Kapající baterie u umyvadla, klientka má vlastní novou."
)
baterie.save!

zamereni = demo_account.jobs.find_or_initialize_by(title: "Zaměření rekonstrukce koupelen")
zamereni.assign_attributes(
  client: penzion,
  property: penzion.properties.first,
  status: "priced",
  description: "Rekonstrukce čtyř koupelen, zaměření a nacenění."
)
zamereni.save!

tomas = User.find_by!(email: "tomas@novak-topeni.cz")
jakub = User.find_by!(email: "jakub@novak-topeni.cz")

# Termíny v aktuálním týdnu, ať je kalendář po seedu čím naplnit.
monday_this_week = Date.current.beginning_of_week

planned_visits = [
  { job: havarie, user: owner, day_offset: 0, from_hour: 11, to_hour: 14 },
  { job: servis_kotle, user: tomas, day_offset: 1, from_hour: 8, to_hour: 11 },
  { job: baterie, user: tomas, day_offset: 2, from_hour: 9, to_hour: 11 },
  { job: zamereni, user: jakub, day_offset: 3, from_hour: 14, to_hour: 16 },
  { job: havarie, user: jakub, day_offset: 4, from_hour: 7, to_hour: 9 }
]

planned_visits.each do |visit_attributes|
  starts_at = (monday_this_week + visit_attributes[:day_offset].days).in_time_zone.change(hour: visit_attributes[:from_hour])
  ends_at = (monday_this_week + visit_attributes[:day_offset].days).in_time_zone.change(hour: visit_attributes[:to_hour])

  next if Visit.exists?(job: visit_attributes[:job], starts_at: starts_at)

  visit_attributes[:job].visits.create!(user: visit_attributes[:user], starts_at: starts_at, ends_at: ends_at)
end

incoming_requests = [
  {
    client_name: "Kavárna Zrno s.r.o.",
    phone: "+420 775 220 118",
    email: "provoz@kavarnazrno.cz",
    street: "Lublaňská 12",
    city: "Praha 2",
    postal_code: "120 00",
    title: "Rozvody vody do nového baru",
    description: "Stavíme nový bar, potřebujeme přivést vodu a odpad. Prosíme o cenovou nabídku."
  },
  {
    client_name: "Marek Beneš",
    phone: "+420 733 908 442",
    street: "Sokolská 60",
    city: "Praha 2",
    postal_code: "120 00",
    title: "Netopí radiátor v ložnici",
    description: "Ostatní radiátory hřejí, tenhle zůstává studený. Asi vzduch v systému."
  }
]

incoming_requests.each do |request_attributes|
  next if demo_account.jobs.exists?(title: request_attributes[:title])

  job_request_form = JobRequestForm.new(request_attributes)
  PublicRequests::JobCreator.new(demo_account).create_job_from_public_form(job_request_form)
end

puts "Hotovo. Přihlas se jako #{owner.email} s heslem heslo1234."
puts "Veřejný poptávkový formulář: /poptavka/#{demo_account.slug}"
