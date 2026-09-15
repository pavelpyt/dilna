# Dílna

**Field-service management pro české řemeslníky.** Poptávky, klienti, zakázky, termíny, docházka, nabídky a faktury na jednom místě.

Řemeslník dnes žije v šesti nástrojích naráz — poptávky v e-mailu, termíny v hlavě, faktury v jiném programu, docházka na papíře. Dílna to sjednocuje do jednoho toku: od první poptávky přes naplánování a realizaci až po zaplacenou fakturu.

Postaveno na Ruby on Rails 3.3 / PostgreSQL 17.

---

## Přehled

Denní rozcestník — co je naplánované na dnešek, co čeká na fakturaci a co je po splatnosti. Cílem je, aby řemeslník po ránu na jedné obrazovce viděl, čemu se má věnovat.

![Přehled](docs/screenshots/prehled.png)

---

## Poptávky z webu

Každá firma má veřejný formulář na vlastní adrese (`/poptavka/:slug`). Když zákazník poptávku odešle, objeví se tady k přijetí nebo odmítnutí — a po přijetí se z ní stane zakázka. Řemeslník tak nemusí přepisovat nic ručně z mailu.

![Poptávky](docs/screenshots/poptavky.png)

---

## Tým a hodiny

Docházka, checklisty a export hodin. Mzdy vědomě neřeším — hodiny jdou ven do Excelu a mzdy počítá účetní. Držet payroll v MVP by znamenalo řešit legislativu, která se změnou jednoho zákona rozbije.

![Tým a hodiny](docs/screenshots/tym-hodiny.png)

---

## Jak je to poskládané

Pár rozhodnutí, na kterých stojí celá aplikace:

**Multi-tenancy** — všechno visí pod `Account`. Dotazy jdou vždy přes `current_account.*`, nikdy `Model.find(params[:id])`, žádný `default_scope`. Data jednoho zákazníka se nemají jak dostat k druhému.

**Stavy zakázky** — `Job::ALLOWED_NEXT_STATUSES`, prostý hash povolených přechodů. Žádný stavový gem — celý automat se přečte na jedné obrazovce.

**Kolize termínů** — hlídá je validace v modelu (kvůli srozumitelné hlášce) *i* exclusion constraint přímo v Postgresu (kvůli souběžnému ukládání). Dvě vrstvy, protože na plánování se nedá spolehnout jen na aplikaci.

**Veřejné adresy** — `/poptavka/:slug` a `/z/:token`. V klientské části je jen náhodný token s platností, nikdy databázové id. Stránky mají `noindex`.

**Fronta** — Solid Queue na Postgresu, i ve vývoji. SMS a maily nikdy neodcházejí ze requestu. Upomínky běží přes `config/recurring.yml`.

**UI** — Tailwind v4 s tokeny přenesenými z prototypu, ViewComponent tam, kde se komponenta rozhoduje podle dat.

---

## Integrace bez jediného API klíče

Fakturoid, Stripe i SMS brána jsou schované za service objekty v `app/services/`. V MVP jen zaloguji akci a vrátím realistickou odpověď — takže celý tok od poptávky po zaplacení projde bez napojení na cokoliv externího.

Skutečné volání se dopíše dovnitř těch service objektů, zbytek aplikace se nezmění. Přepíná se přes ENV:

| Proměnná | Co zapne | Kde se doplní implementace |
|---|---|---|
| `FAKTUROID_ENABLED` | vystavení faktury | `app/services/invoicing/invoice_creator.rb` |
| `STRIPE_ENABLED` | platební odkaz | `app/services/payments/payment_link_creator.rb` |
| `SMS_GATEWAY_ENABLED` | odeslání SMS | `app/services/sms/message_sender.rb` |

Zapnuté bez hotové implementace hlásí `NotImplementedError` — schválně, ať se problém nepozná až v provozu.

Daňový doklad negeneruji sám. `Invoice` je jen zrcadlo faktury z externí služby: externí id, číslo, částka, splatnost, stav a odkaz na doklad.

---

## Rozjetí

```
bin/setup    # gemy, databáze, seedy
bin/dev      # server na http://localhost:3008 + Tailwind watch + fronta
```

Jednotlivě, když je potřeba:

```
bin/rails server -p 3008   # aplikace
bin/jobs                   # fronta (upomínky, SMS, maily)
```

Potřebuješ **Ruby 3.3** a **PostgreSQL 17**. Databáze: `dilna_development` a `dilna_development_queue` (fronta má vlastní).

Po `bin/rails db:seed` se přihlásíš jako `petr@novak-topeni.cz` / `heslo1234`. Techniky demo firmy najdeš na `tomas@` a `jakub@` (stejné heslo).

---

## Sdílení běžícího serveru

Port 3008 jde vystavit přes port forwarding ve VS Code (Ports → Forward a Port → 3008 → Visibility → Public). Rails je na to připravený: `config.hosts` pouští `*.devtunnels.ms` a bere vážně `X-Forwarded-Proto` z tunelu, aby formuláře nepadaly na CSRF.

Pro jiný tunel stačí předat doménu:

```
DEV_TUNNEL_HOST=neco.ngrok-free.app bin/rails server -p 3008
```

> **Pozor:** ve vývojovém režimu ukazují chybové stránky zdrojový kód a proměnné. Na veřejné demo pusť produkční režim, nebo tunel po ukázce zavři.

---

## Testy

```
bin/rails test          # validace modelů, service objekty, request testy
bin/rails test:system   # systémový test: kalendář se opravdu vykreslí
bin/rubocop             # Rails Omakase
```

---

## Co v MVP záměrně není

Payroll (jen export hodin do Excelu), marketing, recenze, sales pipeline, obousměrné threadování e-mailů a SMS, offline PWA režim a vlastní generování daňových dokladů. Vědomě vynechané, aby MVP zůstalo MVP.
