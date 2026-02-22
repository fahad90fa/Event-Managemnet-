import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/router/app_router.dart';
import 'core/config/theme/app_theme.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/network/api_client.dart';
import 'core/network/services/device_info_service.dart';
import 'core/security/behavioral_analytics_service.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'core/network/mock/mock_auth_remote_data_source.dart';
import 'core/security/security_service.dart';
import 'core/security/adaptive_auth_wrapper.dart';
import 'features/vendors/domain/repositories/vendor_repository.dart';
import 'features/vendors/data/repositories/mock_vendor_repository.dart';
import 'features/seating/domain/repositories/seating_repository.dart';
import 'features/seating/data/services/mock_seating_service.dart';
import 'features/seating/presentation/bloc/seating_bloc.dart';
import 'features/payments/domain/repositories/payment_repository.dart';
import 'features/payments/data/services/mock_payment_service.dart';
import 'features/payments/presentation/bloc/payment_bloc.dart';
import 'features/notifications/domain/repositories/notification_repository.dart';
import 'features/notifications/data/services/mock_notification_service.dart';
import 'features/notifications/presentation/bloc/notification_bloc.dart';
import 'features/budget_ai/domain/repositories/budget_prediction_repository.dart';
import 'features/budget_ai/data/services/mock_budget_prediction_service.dart';
import 'features/budget_ai/presentation/bloc/budget_ai_bloc.dart';
import 'features/vendors/domain/repositories/bidding_repository.dart';
import 'features/vendors/data/repositories/mock_bidding_repository.dart';
import 'features/vendors/presentation/bloc/bidding_bloc.dart';
import 'features/social/presentation/bloc/gift_bloc.dart';
import 'features/social/domain/repositories/gift_repository.dart';
import 'features/social/data/services/mock_gift_service.dart';
import 'features/social/domain/repositories/invitation_repository.dart';
import 'features/social/data/services/mock_invitation_service.dart';
import 'features/social/domain/repositories/social_repository.dart';
import 'features/social/data/services/mock_social_service.dart';
import 'features/social/presentation/bloc/social_bloc.dart';
import 'features/social/presentation/bloc/invitation_bloc.dart';
import 'core/config/localization/language_bloc.dart';
import 'features/admin_portal/domain/repositories/admin_repository.dart';
import 'features/admin_portal/data/repositories/mock_admin_repository.dart';
import 'features/admin_portal/presentation/bloc/admin_bloc.dart';

// Set to true to use mock API (no backend needed)
// Set to false to use real API
const bool useMockApi = true;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  const storage = FlutterSecureStorage();
  final deviceInfo = DeviceInfoService();
  final securityService = SecurityService(storage, deviceInfo);
  final behavioralService = BehavioralAnalyticsService();
  final apiClient =
      ApiClient(storage, deviceInfo, securityService, behavioralService);

  // Use mock or real data source based on flag
  final authRemoteDataSource = useMockApi
      ? MockAuthRemoteDataSource()
      : AuthRemoteDataSourceImpl(apiClient.dio);

  // Lock orientation to portrait for now
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // Match dark theme
    ),
  );

  runApp(WeddingOSApp(
    authRepository: AuthRepositoryImpl(
      authRemoteDataSource,
      storage,
      deviceInfo,
      securityService,
    ),
    behavioralService: behavioralService,
    securityService: securityService,
  ));
}

class WeddingOSApp extends StatelessWidget {
  final AuthRepository authRepository;
  final BehavioralAnalyticsService behavioralService;
  final SecurityService securityService;

  const WeddingOSApp({
    super.key,
    required this.authRepository,
    required this.behavioralService,
    required this.securityService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(
          value: authRepository,
        ),
        RepositoryProvider<VendorRepository>(
          create: (context) => MockVendorRepository(),
        ),
        RepositoryProvider<SeatingRepository>(
          create: (context) => MockSeatingService(),
        ),
        RepositoryProvider<PaymentRepository>(
          create: (context) => MockPaymentService(),
        ),
        RepositoryProvider<NotificationRepository>(
          create: (context) => MockNotificationService(),
        ),
        RepositoryProvider<BudgetPredictionRepository>(
          create: (context) => MockBudgetPredictionService(),
        ),
        RepositoryProvider<BiddingRepository>(
          create: (context) => MockBiddingRepository(),
        ),
        RepositoryProvider<GiftRepository>(
          create: (context) => MockGiftService(),
        ),
        RepositoryProvider<InvitationRepository>(
          create: (context) => MockInvitationService(),
        ),
        RepositoryProvider<SocialRepository>(
          create: (context) => MockSocialService(),
        ),
        RepositoryProvider<BehavioralAnalyticsService>.value(
          value: behavioralService,
        ),
        RepositoryProvider<SecurityService>.value(
          value: securityService,
        ),
        RepositoryProvider<AdminRepository>(
          create: (context) => MockAdminRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
              behavioralService: behavioralService,
              securityService: securityService,
            )..add(AuthCheckRequested()),
          ),
          BlocProvider(
            create: (context) => SeatingBloc(
              repository: context.read<SeatingRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => PaymentBloc(
              repository: context.read<PaymentRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => NotificationBloc(
              repository: context.read<NotificationRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => BudgetAiBloc(
              repository: context.read<BudgetPredictionRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => BiddingBloc(
              repository: context.read<BiddingRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => GiftBloc(
              repository: context.read<GiftRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => InvitationBloc(
              repository: context.read<InvitationRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SocialBloc(
              repository: context.read<SocialRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => LanguageBloc(),
          ),
          BlocProvider(
            create: (context) => AdminBloc(
              context.read<AdminRepository>(),
            )..add(LoadAdminData()),
          ),
        ],
        child: Listener(
          onPointerDown: (_) => behavioralService.recordInteraction(),
          child: BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, state) {
              return AdaptiveAuthWrapper(
                child: MaterialApp.router(
                  title: 'BookMyEvent',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  routerConfig: AppRouter.router,
                  locale: state.locale,
                  builder: (context, child) {
                    return Directionality(
                      textDirection: state.direction,
                      child: child!,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
