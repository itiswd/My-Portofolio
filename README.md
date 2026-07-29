# Ibrahim Tharwat Portfolio

A Flutter portfolio with a public multimedia project gallery and a private
Supabase-powered content studio.

## Features

- Responsive project case-study gallery.
- Unlimited project media records (subject to the Supabase plan/storage quota).
- Image uploads and direct video uploads.
- YouTube, Vimeo, or other external video links.
- Any number of custom project links.
- Arabic and English project content.
- Draft/published state, featured projects, categories, and display order.
- Private `/admin` area protected by Supabase Auth and Row Level Security.

## Supabase setup

1. Create a Supabase project.
2. Open the SQL Editor and run:
   `supabase/migrations/202607290001_portfolio_cms.sql`.
3. In Authentication > Users, create your email/password account.
4. In the SQL Editor, make that account the only portfolio admin:

```sql
insert into public.admin_users (user_id)
select id from auth.users where email = 'you@example.com';
```

5. Copy `config/supabase.example.json` to `config/supabase.json` and fill in
   the project URL and publishable key.

The publishable key is designed to be used in client apps. Access is enforced
by the included RLS policies. Never put the Supabase service-role key in this
app.

## Run

```powershell
flutter pub get
flutter run -d chrome
```

Open `/admin` to manage projects. The public portfolio displays demo projects
when Supabase is not configured.

For local development, the app automatically reads `config/supabase.json`.
Values passed with `--dart-define` still take priority for production builds.

## Production build

```powershell
flutter build web --release --dart-define-from-file=config/supabase.json
```
