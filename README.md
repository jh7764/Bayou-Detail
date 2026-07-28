# Bayou Detail Co. - Booking Form

Single-page booking form. Plain HTML/CSS/JS backend by Supabase.

## What it does

- Collects name, vehicle, zip, service, and time slot.
- Blocks bookings outside the service area **twice**: instantly in the browser as you type a zip (so you never fill out a form you can't submit), and again server-side via a Postgres `check` constraint on the `bookings` table (so the block can't be bypassed by calling the API directly).
- Service-area zip list (18 zips: Inner Loop, Kingwood, Katy, Pearland/Friendswood/League City) is pulled directly from the zips that actually appear in Bayou's June job log — this is where techs have actually driven, not a drawn radius.
- Time slots: next 6 working days (Sundays skipped), 3 windows/day.

## Run it locally

No build tooling needed - it's one HTML file.

```bash
open index.html
# or:
python3 -m http.server 8000   # then visit localhost:8000
```
