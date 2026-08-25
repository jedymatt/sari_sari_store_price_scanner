# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Sari Scan is a Flutter **Android-only** app for sari-sari stores (small retail shops in the Philippines). It does two things: barcode-based price lookup, and a customer credit ledger ("Mga Utang").

**Current Status:** Both features implemented — scan/register/manage products, and per-customer utang ledger with Trash.

**Planned Features:**
- Export and import functionality for backup and restore
- Standalone static website for managing products (uses import/export files, no backend)

**Limitations:** Price lookup relies on barcodes; not suitable for products without barcodes (e.g., eggs, onions, garlic).

## Commands

```bash
# Install dependencies
flutter pub get

# Generate code (required after modifying database schema in lib/database.dart)
dart run build_runner build

# Watch for changes and regenerate code automatically
dart run build_runner watch

# Run on connected device/emulator
flutter run

# Build release APK (uses signing config in android/key.properties)
flutter build apk --release

# Run tests
flutter test

# Run a single test file
flutter test test/db_test.dart

# Static analysis
flutter analyze

# Format code
dart format lib/
```

## Architecture

**No state management library** — uses StatefulWidget with setState directly. No dependency injection or repository pattern.

### Data Flow
Pages call database functions directly from `lib/db.dart`. The database layer exposes top-level async functions that use a singleton Drift database instance. StatefulWidget pages reload data after navigation (the `_navigateAndRefresh` pattern — e.g. HomePage refreshes product count and total outstanding after returning from other pages).

`lib/db.dart` exposes:
- Products: `queryProducts()`, `insertProduct()`, `updateProduct()`, `deleteProduct()`
- Customers: `queryCustomers({trashed})`, `getCustomer()`, `activeCustomerNames({excludeId})`, `insertCustomer()`, `updateCustomer()`, `deleteCustomer()`, `setCustomerTrashed()`, `purgeExpiredTrash()`
- Entries: `insertEntry()`, `totalOutstanding()`
- Tests: `setDatabaseForTesting()` / `resetDatabaseForTesting()` to inject an in-memory executor

`queryCustomers()` computes each balance in SQL with a left join and filtered sums, so the list view does not need to load every entry.

### Key Files
- `lib/main.dart` — App entry point, MaterialApp with Material 3, theme and locale management, startup trash purge
- `lib/models.dart` — `Product`, `Customer`, `UtangEntry`, `CustomerWithBalance`, `UtangType` enum, plus pure `balanceOf()` and `roundToCentavos()`
- `lib/database.dart` — Drift table definitions and migration strategy
- `lib/database.g.dart` — Generated Drift code (do not edit manually)
- `lib/db.dart` — Database API layer exposing top-level functions; uses singleton Drift database
- `lib/core/currency.dart` — Philippine Peso formatter (`phpFormat`)
- `lib/core/date_format.dart` — Locale-aware `entryDateFormat()` / `entryTimeFormat()` for ledger entries
- `lib/core/trash.dart` — `trashRetention` (30 days) and pure `daysUntilPurge()`
- `lib/l10n/` — Internationalization; edit `app_en.arb` / `app_ceb.arb`, the `.dart` files are generated
- `lib/pages/camera_page.dart` — Barcode scanning via `mobile_scanner`; shows product price or "not found" inline as overlay
- `lib/pages/home_page.dart` — Entry point with product count, total outstanding, and navigation cards
- `lib/pages/settings_page.dart` — Theme and language pickers
- `lib/pages/product_management/` — CRUD screens for products
  - `manage_products_page.dart` — List view with local search (filters by name/barcode in-memory)
  - `register_product_page.dart` — Add new product with barcode pre-filled
  - `edit_product_page.dart` — Edit existing product details
- `lib/pages/mga_utang/` — Customer credit ledger
  - `mga_utang_page.dart` — Customer list with Active/Trash tabs, search, total outstanding
  - `customer_ledger_page.dart` — One customer's entries and running balance
  - `edit_customer_page.dart` — Add or edit a customer (name, optional phone)
  - `add_entry_sheet.dart` — Bottom sheet for recording utang or bayad
- `lib/components/` — Reusable UI components

### Mga Utang (customer credit ledger)
Customers buy on credit and pay later. Each customer has a ledger of entries, each either a debt (`UtangType.debt`, "utang") or a payment (`UtangType.payment`, "bayad").

- Balance is derived, never stored. `balanceOf()` in `lib/models.dart` is the single pure implementation; `queryCustomers()` mirrors the same arithmetic in SQL for list views.
- Peso amounts round to whole centavos via `roundToCentavos()` so a settled balance compares equal to zero instead of leaving floating-point residue.
- `totalOutstanding()` sums only positive balances — an overpaid customer does not reduce the store total.

### Trash (soft delete)
Customers are soft-deleted, not removed. `Customers.deletedAt` is the flag.

- Trashed customers are view-only and show a "deletes in N days" countdown from `daysUntilPurge()`.
- Retention is 30 days (`trashRetention`).
- There is no scheduler or backend, so `purgeExpiredTrash()` runs on app startup and when the Trash tab opens.
- Only trashed customers can be permanently deleted; active ones must be trashed first.

### Theme and Locale Management
Theme mode (system/light/dark) and locale (English/Cebuano) are held in `MyApp` state, persisted via `shared_preferences`, and exposed to the tree through an `InheritedWidget` (`_AppSettingsScope`). Pages access them through static methods:
- `MyApp.setThemeMode(context, mode)` and `MyApp.themeMode(context)`
- `MyApp.setLocale(context, locale)` and `MyApp.locale(context)`
- Getters watch the scope so dependents rebuild; setters read it without subscribing.
- Localized strings are accessed via `AppLocalizations.of(context)`

Cebuano has no Flutter-bundled Material or Cupertino localizations, so `main.dart` registers `_CebuanoMaterialLocalizationsDelegate` and `_CebuanoCupertinoLocalizationsDelegate` that fall back to English. `lib/core/date_format.dart` does the same for `intl` date patterns — it checks `DateFormat.localeExists` and falls back rather than throwing.

### Navigation
Imperative navigation with `Navigator.push()`. No named routes.

### Barcode Scanning Flow
1. `CameraPage` uses `mobile_scanner` with StreamBuilder to listen for barcode scans
2. Queries products from database via FutureBuilder
3. If barcode matches existing product, displays price overlay with edit option
4. If no match, shows "Product not found" with button to navigate to `RegisterProductPage` (pre-fills barcode)
5. Camera is stopped during navigation and restarted on return

### Database Schema
Uses **Drift** for type-safe database operations. SQLite database `sari_scan.db`, **schema version 3**:

```dart
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get price => real()();
  TextColumn get barcode => text()();
}

class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class UtangEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get customerId => integer().references(Customers, #id)();
  TextColumn get type => textEnum<UtangType>()();
  RealColumn get amount => real()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

**Migration history:**
- v1 → v2: added `Customers` and `UtangEntries`
- v2 → v3: renamed `archived_at` to `deleted_at` when Archive became Trash

After modifying the schema in `lib/database.dart`, run `dart run build_runner build` to regenerate `lib/database.g.dart`, bump `schemaVersion`, add an `onUpgrade` branch, and cover it in `test/migration_test.dart`.

### Currency
Uses `intl` package — `phpFormat` global in `lib/core/currency.dart` for Philippine Peso (₱) formatting.

## Testing

Tests live in `test/` and run against an in-memory database injected with `setDatabaseForTesting()`. Pure logic (`balanceOf`, `roundToCentavos`, `daysUntilPurge`, date formats) is tested directly without a database. `test/migration_test.dart` uses `sqlite3` to verify schema upgrades against real old-version databases.
