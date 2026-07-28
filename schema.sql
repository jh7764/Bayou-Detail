-- Bayou Detail Co. — booking table
-- Run this in the Supabase SQL editor (or via `supabase db push`) before wiring up the form.

create extension if not exists pgcrypto;

create table if not exists public.bookings (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  name        text not null check (char_length(trim(name)) > 0),
  vehicle     text not null check (char_length(trim(vehicle)) > 0),
  zip         text not null check (zip ~ '^[0-9]{5}$'),
  service     text not null,
  time_slot   text not null,

  -- Service-area enforcement, server-side. This list is pulled directly from
  -- the zips that appear in Bayou's June job log (their actual service area),
  -- not a guess. Keep this in sync with ALLOWED_ZIPS in index.html.
  constraint zip_in_service_area check (
    zip in (
      '77005','77006','77007','77008','77019','77024','77025','77027',
      '77030','77056','77098','77401', -- Inner Loop
      '77339',                          -- North / Kingwood
      '77450','77494',                  -- West / Katy
      '77546','77573','77584'           -- South / Pearland-Friendswood-League City
    )
  ),

  constraint valid_service check (
    service in (
      'Wash & Wax',
      'Interior Deep Clean',
      'Full Detail',
      'Ceramic Coating',
      'Maintenance Plan Visit'
    )
  )
);

alter table public.bookings enable row level security;

-- Public booking form: anyone can create a booking, no one can read others' bookings
-- back through the anon key. Ray reads the table from the Supabase dashboard directly.
create policy "anon can insert bookings"
  on public.bookings
  for insert
  to anon
  with check (true);

create index if not exists bookings_created_at_idx on public.bookings (created_at desc);
