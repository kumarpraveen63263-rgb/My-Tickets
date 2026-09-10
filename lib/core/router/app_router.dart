import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/navigation/main_navigation.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/otp_screen.dart';
import '../../presentation/screens/booking/booking_confirmation_screen.dart';
import '../../presentation/screens/booking/checkout_screen.dart';
import '../../presentation/screens/booking/seat_selection_screen.dart';
import '../../presentation/screens/events/event_detail_screen.dart';
import '../../presentation/screens/events/events_home_screen.dart';
import '../../presentation/screens/events/events_list_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/metro/metro_home_screen.dart';
import '../../presentation/screens/metro/metro_map_screen.dart';
import '../../presentation/screens/metro/metro_route_screen.dart';
import '../../presentation/screens/metro/metro_ticket_screen.dart';
import '../../presentation/screens/metro/station_search_screen.dart';
import '../../presentation/screens/movies/movie_detail_screen.dart';
import '../../presentation/screens/movies/movies_list_screen.dart';
import '../../presentation/screens/movies/show_timing_screen.dart';
import '../../presentation/screens/movies/theatre_list_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/profile/edit_profile_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/profile/ticket_report_screen.dart';
import '../../presentation/screens/profile/settings_screen.dart';
import '../../presentation/screens/search/search_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/tickets/my_tickets_screen.dart';
import '../../presentation/screens/tickets/ticket_detail_screen.dart';
import '../../presentation/widgets/common/app_button.dart';
import '../../presentation/widgets/common/app_empty_state.dart';
import '../theme/app_colors.dart';
import 'app_transitions.dart';

class AppRouter {
  AppRouter._();

  /// Root navigator — full-screen routes (auth, detail flows, checkout) are
  /// pushed here so they cover the bottom navigation bar.
  static final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );

  // One navigator key per tab branch so each tab keeps its own nav stack.
  static final GlobalKey<NavigatorState> _homeKey = GlobalKey<NavigatorState>(
    debugLabel: 'home',
  );
  static final GlobalKey<NavigatorState> _moviesKey = GlobalKey<NavigatorState>(
    debugLabel: 'movies',
  );
  static final GlobalKey<NavigatorState> _eventsKey = GlobalKey<NavigatorState>(
    debugLabel: 'events',
  );
  static final GlobalKey<NavigatorState> _metroKey = GlobalKey<NavigatorState>(
    debugLabel: 'metro',
  );
  static final GlobalKey<NavigatorState> _profileKey =
      GlobalKey<NavigatorState>(debugLabel: 'profile');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(
        path: '/otp',
        builder: (context, state) =>
            OtpScreen(phone: state.extra as String? ?? ''),
      ),

      // ---- Bottom-nav shell: a single IndexedStack of 5 branches.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainNavigation(navigationShell: navigationShell),
        branches: [
          // 0 — Home
          StatefulShellBranch(
            navigatorKey: _homeKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'search',
                    builder: (context, state) => SearchScreen(),
                  ),
                  GoRoute(
                    path: 'tickets',
                    builder: (context, state) => const MyTicketsScreen(),
                  ),
                ],
              ),
            ],
          ),
          // 1 — Movies
          StatefulShellBranch(
            navigatorKey: _moviesKey,
            routes: [
              GoRoute(
                path: '/movies',
                builder: (context, state) => const MoviesListScreen(isTab: true),
              ),
            ],
          ),
          // 2 — Events
          StatefulShellBranch(
            navigatorKey: _eventsKey,
            routes: [
              GoRoute(
                path: '/events',
                builder: (context, state) => const EventsHomeScreen(),
                routes: [
                  GoRoute(
                    path: 'search',
                    builder: (context, state) => SearchScreen(),
                  ),
                  GoRoute(
                    path: 'list',
                    builder: (context, state) => const EventsListScreen(),
                  ),
                ],
              ),
            ],
          ),
          // 3 — Metro
          StatefulShellBranch(
            navigatorKey: _metroKey,
            routes: [
              GoRoute(
                path: '/metro',
                builder: (context, state) => const MetroHomeScreen(),
              ),
            ],
          ),
          // 4 — Profile
          StatefulShellBranch(
            navigatorKey: _profileKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // ---- Full-screen routes pushed on the root navigator (cover bottom nav).
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/movies/:id',
        pageBuilder: (context, state) => AppTransitions.sharedAxis(
          state,
          MovieDetailScreen(movieId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/movies/:id/theatres',
        pageBuilder: (context, state) => AppTransitions.sharedAxis(
          state,
          TheatreListScreen(movieId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/movies/:id/shows',
        pageBuilder: (context, state) => AppTransitions.sharedAxis(
          state,
          ShowTimingScreen(movieId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/movies/:id/seats',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return AppTransitions.sharedAxis(
            state,
            SeatSelectionScreen(
              movieId: state.pathParameters['id']!,
              showId: extra['showId'] as String? ?? '',
              theatreName: extra['theatreName'] as String? ?? '',
            ),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/events/:id',
        pageBuilder: (context, state) => AppTransitions.sharedAxis(
          state,
          EventDetailScreen(eventId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/booking/checkout',
        pageBuilder: (context, state) =>
            AppTransitions.sharedAxis(state, CheckoutScreen()),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/booking/confirmation',
        pageBuilder: (context, state) =>
            AppTransitions.fadeThrough(state, BookingConfirmationScreen()),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/ticket/:id',
        pageBuilder: (context, state) => AppTransitions.sharedAxis(
          state,
          TicketDetailScreen(bookingId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/metro/map',
        pageBuilder: (context, state) =>
            AppTransitions.fadeThrough(state, MetroMapScreen()),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/metro/search-station',
        pageBuilder: (context, state) =>
            AppTransitions.sharedAxis(state, StationSearchScreen()),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/metro/route',
        pageBuilder: (context, state) =>
            AppTransitions.sharedAxis(state, MetroRouteScreen()),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/metro/ticket/:id',
        pageBuilder: (context, state) => AppTransitions.sharedAxis(
          state,
          MetroTicketScreen(bookingId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/profile/edit',
        pageBuilder: (context, state) =>
            AppTransitions.sharedAxis(state, EditProfileScreen()),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/profile/report',
        pageBuilder: (context, state) =>
            AppTransitions.sharedAxis(state, const TicketReportScreen()),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/profile/settings',
        pageBuilder: (context, state) =>
            AppTransitions.sharedAxis(state, const SettingsScreen()),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppEmptyState(
                icon: Icons.error_outline_rounded,
                title: 'Page Not Found',
                subtitle: 'The page you are looking for does not exist.',
              ),
              const SizedBox(height: 20),
              AppButton(
                label: 'Go Home',
                fullWidth: false,
                onPressed: () => context.go('/home'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
