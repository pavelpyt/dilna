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

puts "Hotovo. Přihlas se jako #{owner.email} s heslem heslo1234."
