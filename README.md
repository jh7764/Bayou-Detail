# Bayou Detail Co. — Booking Form

Single-page booking form. Plain HTML/CSS/JS, no build step, backed by Supabase.

## What it does

- Collects name, vehicle, zip, service, and time slot.
- Blocks bookings outside the service area **twice**: instantly in the browser as you type a zip (so you never fill out a form you can't submit), and again server-side via a Postgres `check` constraint on the `bookings` table (so the block can't be bypassed by calling the API directly).
- Service-area zip list (18 zips: Inner Loop, Kingwood, Katy, Pearland/Friendswood/League City) is pulled directly from the zips that actually appear in Bayou's June job log — this is where techs have actually driven, not a drawn radius.
- Time slots: next 6 working days (Sundays skipped), 3 windows/day.

## Run it locally

No build tooling needed — it's one HTML file.

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

https://wvtfytxiqxkuqtsaffit.supabase.co/rest/v1/
sb_publishable_vD03jxlJY2avdBfwibTZRg_LzmrrWI2

## Deploy (optional)

It's a static file, so any static host works — easiest is dragging the folder into [Netlify Drop](https://app.netlify.com/drop) or `vercel deploy` from this directory. No env vars needed since the Supabase anon key is meant to be public (that's what RLS is for).

## Known gaps / what I'd do with another 2 hours

- **No double-booking protection.** Two customers can currently grab the same tech/slot. Fix: a `slots` table with capacity per tech per window, decremented on insert, or a uniqueness constraint on `(time_slot)` if only one van should run per slot.
- **No confirmation text/email.** The form promises "we'll text you a confirmation" but nothing sends it. Fix: a Supabase Edge Function triggered on insert, calling Twilio.
- **Zip list is hardcoded in two places** (index.html and schema.sql). Fine for 18 zips today; if the service area grows, move it to a `service_zips` table and read both client and server checks from it.
- **No admin view.** Ray currently has to open the Supabase table editor to see bookings. A one-page `/admin` view (list + status toggle) would be the next thing built.
- **Phone number isn't collected**, which is odd for a business that texts confirmations — I'd add it before shipping this for real, I just didn't see it in the requested field list so left it out rather than assume.
