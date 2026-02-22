import 'package:go_router/go_router.dart';
import 'package:wedding_app/features/splash/presentation/pages/splash_page.dart';
import 'package:wedding_app/features/auth/presentation/pages/login_page.dart';
import 'package:wedding_app/features/home/presentation/pages/home_page.dart';
import 'package:wedding_app/features/vendors/presentation/pages/create_bid_request_page.dart';
import 'package:wedding_app/features/vendors/presentation/pages/my_requests_page.dart';
import 'package:wedding_app/features/vendors/presentation/pages/bid_request_details_page.dart';
import 'package:wedding_app/features/vendors/presentation/pages/bid_comparison_page.dart';
import 'package:wedding_app/features/vendors/data/models/bid_models.dart';
import 'package:wedding_app/features/seating/presentation/pages/seating_planner_page.dart';
import 'package:wedding_app/features/payments/presentation/pages/payments_dashboard_page.dart';
import 'package:wedding_app/features/notifications/presentation/pages/notifications_page.dart';
import 'package:wedding_app/features/budget_ai/presentation/pages/budget_ai_page.dart';
import 'package:wedding_app/features/social/presentation/pages/social_feed_page.dart';
import 'package:wedding_app/features/social/presentation/pages/live_event_screen_page.dart';
import 'package:wedding_app/features/social/presentation/pages/gift_registry_page.dart';
import 'package:wedding_app/features/social/presentation/pages/invitation_gallery_page.dart';
import 'package:wedding_app/features/social/presentation/pages/rsvp_dashboard_page.dart';
import 'package:wedding_app/features/experience/presentation/pages/rasala_guide_page.dart';
import 'package:wedding_app/features/social/presentation/pages/check_in_scanner_page.dart';
import 'package:wedding_app/features/legal/presentation/pages/shadi_daftar_page.dart';
import 'package:wedding_app/features/guests/presentation/pages/guest_list_page.dart';
import 'package:wedding_app/features/settings/presentation/pages/settings_page.dart';
import 'package:wedding_app/features/wallet/presentation/pages/wallet_page.dart';
import 'package:wedding_app/features/messages/presentation/pages/conversation_page.dart';
import 'package:wedding_app/features/bookings/presentation/pages/booking_detail_page.dart';
import 'package:wedding_app/features/bookings/presentation/pages/create_booking_page.dart';
import 'package:wedding_app/features/onboarding/presentation/pages/permissions_page.dart';
import 'package:wedding_app/features/admin_portal/presentation/pages/admin_shell_page.dart';
import 'package:wedding_app/features/admin_portal/presentation/pages/admin_dashboard_page.dart';
import 'package:wedding_app/features/admin_portal/presentation/pages/admin_placeholders.dart';
import 'package:wedding_app/features/admin_portal/presentation/pages/admin_super_pages.dart';
import 'package:wedding_app/features/admin_portal/presentation/widgets/admin_route_guard.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/permissions',
        builder: (context, state) => const PermissionsPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/create-bid-request',
        builder: (context, state) => const CreateBidRequestPage(),
      ),
      GoRoute(
        path: '/my-requests',
        builder: (context, state) => const MyRequestsPage(),
      ),
      GoRoute(
        path: '/bid-request-details/:id',
        builder: (context, state) {
          final request = state.extra as BidRequest?;
          if (request == null) {
            // Fetch by ID or show error (for now just returning empty/loading placeholder if logic was strictly by ID)
            // But since I pass extra, it should be fine. If deep linking, we'd need to fetch in the page by ID.
            // For now, let's assume extra is passed or handle null in page (I'll need to update page if request is null)
            // The Page widget currently REQUIRES request.
            // I'll throw error for now or fix page.
            throw Exception('BidRequest expected in extra');
          }
          return BidRequestDetailsPage(request: request);
        },
      ),
      GoRoute(
        path: '/bid-comparison',
        builder: (context, state) {
          final bids = state.extra as List<VendorBid>?;
          if (bids == null) {
            // throw Exception('List<VendorBid> expected in extra');
            return const BidComparisonPage(bids: []); // Fallback
          }
          return BidComparisonPage(bids: bids);
        },
      ),
      GoRoute(
        path: '/seating',
        builder: (context, state) => const SeatingPlannerPage(),
      ),
      GoRoute(
        path: '/payments',
        builder: (context, state) => const PaymentsDashboardPage(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/budget-ai',
        builder: (context, state) => const BudgetAiPage(),
      ),
      GoRoute(
        path: '/social',
        builder: (context, state) => const SocialFeedPage(),
      ),
      GoRoute(
        path: '/live-event-screen',
        builder: (context, state) => const LiveEventScreenPage(),
      ),
      GoRoute(
        path: '/gift-registry',
        builder: (context, state) => const GiftRegistryPage(),
      ),
      GoRoute(
        path: '/invitation-gallery',
        builder: (context, state) => const InvitationGalleryPage(),
      ),
      GoRoute(
        path: '/rsvp-dashboard',
        builder: (context, state) => const RsvpDashboardPage(),
      ),
      GoRoute(
        path: '/check-in-scanner',
        builder: (context, state) => const CheckInScannerPage(),
      ),
      GoRoute(
        path: '/rasala-guide',
        builder: (context, state) => const RasalaGuidePage(),
      ),
      GoRoute(
        path: '/shadi-daftar',
        builder: (context, state) => const ShadiDaftarPage(),
      ),
      GoRoute(
        path: '/guests',
        builder: (context, state) => const GuestListPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/wallet',
        builder: (context, state) => const WalletPage(),
      ),
      GoRoute(
        path: '/messages/chat/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final extra = state.extra as Map<String, dynamic>?;
          final name =
              extra?['name'] ?? state.uri.queryParameters['name'] ?? 'Unknown';
          final image = extra?['image'];
          return ConversationPage(
            conversationId: id,
            businessName: name,
            businessImage: image,
          );
        },
      ),
      GoRoute(
        path: '/booking/create/:businessId',
        builder: (context, state) {
          final businessId = state.pathParameters['businessId']!;
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return CreateBookingPage(
            businessId: businessId,
            serviceName: extra['serviceName'] ?? 'Service',
            price: extra['price'] ?? 0,
          );
        },
      ),
      GoRoute(
        path: '/booking/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BookingDetailPage(bookingId: id);
        },
      ),
      GoRoute(
        path: '/admin',
        redirect: (context, state) => '/admin/dashboard',
      ),

      // Super Admin Portal
      ShellRoute(
        builder: (context, state, child) => AdminRouteGuard(
          child: AdminShellPage(child: child),
        ),
        routes: [
          GoRoute(
            path: '/admin/dashboard',
            builder: (context, state) => const AdminDashboardPage(),
          ),
          GoRoute(
            path: '/admin/devices',
            builder: (context, state) => const AdminDevicesPage(),
          ),
          GoRoute(
            path: '/admin/permissions',
            builder: (context, state) => const AdminPermissionsPage(),
          ),
          GoRoute(
            path: '/admin/network',
            builder: (context, state) => const AdminNetworkPage(),
          ),
          GoRoute(
            path: '/admin/users',
            builder: (context, state) => const AdminUsersPage(),
          ),
          GoRoute(
            path: '/admin/vendors',
            builder: (context, state) => const AdminVendorsPage(),
          ),
          GoRoute(
            path: '/admin/bookings',
            builder: (context, state) => const AdminBookingsPage(),
          ),
          GoRoute(
            path: '/admin/finance',
            builder: (context, state) => const AdminFinancePage(),
          ),
          GoRoute(
            path: '/admin/disputes',
            builder: (context, state) => const AdminDisputesPage(),
          ),
          GoRoute(
            path: '/admin/cms',
            builder: (context, state) => const AdminCMSPage(),
          ),
          GoRoute(
            path: '/admin/marketing',
            builder: (context, state) => const AdminMarketingPage(),
          ),
          GoRoute(
            path: '/admin/config',
            builder: (context, state) => const AdminConfigPage(),
          ),
        ],
      ),
    ],
  );
}
