# Dílna

Field-service management pro české řemeslníky. Poptávky, klienti, zakázky,
termíny, docházka, nabídky a faktury na jednom místě.

MVP podle `MVP_technicky_dokument.md` a `ui_prototyp.html` (oba leží ve složce
nad tímhle repem).

## Rozjetí

```bash
bin/setup    # gemy, databáze, seedy
bin/dev      # server na http://localhost:3008, Tailwind watch a fronta
```

Jednotlivě, když je to potřeba zvlášť:

```bash
bin/rails server -p 3008   # aplikace
bin/jobs                   # fronta (upomínky, odesílání SMS a mailů)
```

Potřebuješ Ruby 3.3 a PostgreSQL 17. Databáze se jmenují `dilna_development`
a `dilna_development_queue` (fronta má vlastní).

Po `bin/rails db:seed` se přihlásíš jako **petr@novak-topeni.cz** s heslem
**heslo1234**. Techniky demo firmy najdeš na `tomas@` a `jakub@` (stejné heslo).

## Bez jediného API klíče

Fakturoid, Stripe i SMS brána jsou schované za service objekty v `app/services/`.
V MVP jen zalogují akci a vrátí realistickou odpověď, takže celý tok od poptávky
po zaplacení jde projít bez napojení na cokoliv externího.

Skutečné volání se dopíše dovnitř těch service objektů, zbytek aplikace se
nezmění. Přepínají se přes ENV:

| Proměnná | Co zapne | Kde se doplní implementace |
|---|---|---|
| `FAKTUROID_ENABLED` | vystavení faktury přes Fakturoid | `app/services/invoicing/invoice_creator.rb` |
| `STRIPE_ENABLED` | platební odkaz přes Stripe | `app/services/payments/payment_link_creator.rb` |
| `SMS_GATEWAY_ENABLED` | odeslání SMS přes bránu | `app/services/sms/message_sender.rb` |

Zapnuté bez hotové implementace hlásí `NotImplementedError` — schválně, ať se to
nepozná až v provozu.

Daňový doklad negenerujeme sami. `Invoice` je jen zrcadlo faktury z externí
služby: externí id, číslo, částka, splatnost, stav a odkaz na doklad.

## Jak je to poskládané

- **Multi-tenancy** — všechno visí pod `Account`. Dotazy jdou vždycky přes
  `current_account.*`, nikdy `Model.find(params[:id])`. Žádný `default_scope`.
- **Stavy zakázky** — `Job::ALLOWED_NEXT_STATUSES`, prostý hash povolených
  přechodů. Žádný gem, celý automat se přečte na jedné obrazovce.
- **Kolize termínů** — hlídá je validace v modelu (kvůli hlášce) i exclusion
  constraint v Postgresu (kvůli souběžnému ukládání).
- **Veřejné adresy** — `/poptavka/:slug` a `/z/:token`. V client hubu je jen
  náhodný token s platností, nikdy id z databáze. Stránky mají `noindex`.
- **Fronta** — Solid Queue na Postgresu, i ve vývoji. SMS a maily nikdy
  neodcházejí ze requestu. Upomínky jsou v `config/recurring.yml`.
- **UI** — Tailwind v4 s tokeny z prototypu (`app/assets/tailwind/application.css`)
  a ViewComponent tam, kde se komponenta rozhoduje podle dat.

## Testy

```bash
bin/rails test          # validace modelů, service objekty, request testy
bin/rails test:system   # jediný systémový test: kalendář se opravdu vykreslí
bin/rubocop             # Rails Omakase
```

## Co v MVP záměrně není

Payroll (jen export hodin do Excelu), marketing, recenze, sales pipeline,
obousměrné threadování e-mailů a SMS, offline režim PWA a vlastní generování
daňových dokladů.
