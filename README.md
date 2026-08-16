# MyTickets

MyTickets is an internship-ready Flutter prototype for discovering and booking movies, events, and metro experiences in one app.

## Internship demo mode

This project intentionally runs without real authentication, payment gateways, or external APIs. The flows are simulated locally so the application can be demonstrated offline.

| Feature | Demo behavior |
|---|---|
| Authentication | Enter any phone number, then use the fixed OTP `123456`. |
| Payment | Checkout creates a local demo booking; no money is charged. |
| Catalogue | Movies, events, theatres, offers, and metro data are seeded in local repositories. |
| Seats | Availability is deterministic for each show, so the same show displays stable seats on every visit. |
| Tickets | Created bookings and cancellations are persisted locally with Hive. |
| Maps | The metro experience uses the existing local route flow; Google Maps credentials are not required for the demo. |

## Run locally

```bash
flutter pub get
flutter run
```

For a web build:

```bash
flutter build web
```

Run the regression tests with:

```bash
flutter test
```

## Implemented local-demo improvements

The demo now includes explicit OTP guidance, deterministic seat generation, Hive-backed booking persistence, persisted booking status changes, case-insensitive and expiry-aware offer validation, ticket-list refresh after booking, a clearly labeled demo checkout action, and focused regression tests for the local business logic.
