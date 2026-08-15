# Wigma 8 — AI Graphic Design Studio

Flutter starter scaffold implementing the PRD's core structure: splash →
auth → home → AI generator flow, with Riverpod state management, Go
Router navigation, and a Supabase backend.

## Setup

```bash
flutter pub get
cp .env.example .env   # then fill in Supabase + AI provider keys
flutter run
```

If you use freezed/json_serializable models later, generate code with:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Project structure

```
lib/
  core/
    constants/     # app-wide strings, enums, env accessor
    router/         # go_router config + route guards
    theme/          # colors, spacing/radius tokens, ThemeData
  features/
    splash/         # 3s splash, centered logo, "from PARM" signature
    auth/           # sign in, sign up, forgot password
    home/           # header, hero, quick-actions grid, drafts
    generator/       # prompt input -> AI service -> results grid
      data/           # DesignRequest/DesignConcept/DesignResult models
                       # + AiDesignService (OpenAI/Stability implementations)
      providers/      # AsyncNotifier wrapping the generation call
      presentation/   # input screen, results screen
    activity/        # previous generations, filterable
    profile/         # account info, plan, saved projects
    settings/        # theme, language, notifications, privacy
  shared/
    providers/       # auth state, theme mode
    widgets/          # buttons, quick-action tile, etc.
  main.dart
```

## What's scaffolded vs. what's a stub

**Wired up:**
- Full navigation graph with auth-based redirects (go_router + Riverpod)
- Supabase auth (email/password + Google/Apple OAuth entry points)
- Theme system matching the PRD color palette (white / deep navy /
  accent blue) with light + dark ThemeData
- Generation flow: prompt screen → AsyncNotifier → results grid, with
  regenerate/edit/download/share/save action buttons in place

**Stubbed — needs real implementation:**
- `AiDesignService` implementations call real OpenAI/Stability endpoints
  but expect you to supply API keys and adjust response parsing to
  match the exact API version you integrate
- Drafts / Activity / Saved Projects currently show empty states —
  wire them to Supabase tables (`drafts`, `generations`, `projects`)
  once your schema is defined
- Export pipeline (PNG/JPG/WEBP/SVG/PDF/MP4) is not implemented —
  Download/Share buttons are present but not yet functional
- Subscription plan gating (Free/Pro/Business limits, watermarking) is
  not enforced anywhere yet
- Brand Kit generator and AI Video Creator reuse the generic prompt
  screen for now; they'll likely need their own multi-step flows

## Design tokens

Colors live in `lib/core/theme/app_colors.dart` and match the PRD
exactly: background `#FFFFFF`, primary navy `#0F172A`, secondary navy
`#1E293B`, accent `#3B82F6`, text `#111827`. Spacing/radius scales are
in `app_spacing.dart` for the "large spacing, rounded corners, minimal
UI" look described in the PRD.

## "from PARM" signature

Per the PRD, this appears **only** on the splash screen, bottom-center,
styled subtly — the same treatment Meta uses at the bottom of Facebook /
Instagram / Threads. It is intentionally not referenced anywhere else
in the codebase; keep it that way when adding new screens.
