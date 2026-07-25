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

puts "Hotovo. Přihlas se jako #{owner.email} s heslem heslo1234."
