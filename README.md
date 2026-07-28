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

As shipped, it runs in **demo mode**: submissions are validated and logged to the browser console, not persisted anywhere. You'll see a small warning banner at the bottom of the form when this is active.

## Wire up Supabase (~5 min)

1. Create a project at [supabase.com](https://supabase.com) (free tier is fine).
2. Open the SQL editor and run `schema.sql` from this folder. It creates the `bookings` table with the zip/service constraints and an RLS policy that lets the anon key insert rows (but not read them back — Ray reads bookings from the Supabase dashboard, not through the public form).
3. Go to Project Settings → API. Copy the **Project URL** and **anon public key**.
4. In `index.html`, near the top of the `<script>` block, replace:
   ```js
   const SUPABASE_URL = "YOUR_SUPABASE_PROJECT_URL";
   const SUPABASE_ANON_KEY = "YOUR_SUPABASE_ANON_KEY";
   ```
   with your actual values.
5. Reload the page. The demo-mode banner disappears and submissions now write to the `bookings` table.

