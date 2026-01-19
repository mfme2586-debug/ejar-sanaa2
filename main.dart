import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ejar_sanaa/core/theme/app_theme.dart';
import 'package:ejar_sanaa/providers/listing_provider.dart';
import 'package:ejar_sanaa/providers/auth_provider.dart';
import 'package:ejar_sanaa/screens/splash_screen.dart';
import 'package:ejar_sanaa/screens/home_screen.dart';
import 'package:ejar_sanaa/screens/search_screen.dart';
import 'package:ejar_sanaa/screens/listing_details_screen.dart';
import 'package:ejar_sanaa/screens/add_listing_screen.dart';
import 'package:ejar_sanaa/screens/advertiser_dashboard_screen.dart';
import 'package:ejar_sanaa/screens/login_screen.dart';

void main() {
  runApp(const EjarSanaaApp());
}

class EjarSanaaApp extends StatelessWidget {
  const EjarSanaaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ListingProvider()),
      ],
      child: MaterialApp.router(
        title: 'إيجار صنعاء',
        debugShowCheckedModeBanner: false,
        
        // RTL Support
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar', 'YE'),
          Locale('en', 'US'),
        ],
        locale: const Locale('ar', 'YE'),
        
        // Theme
        theme: AppTheme.lightTheme,
        
        // Router
        routerConfig: _router,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
    GoRoute(
      path: '/listing/:id',
      builder: (_, state) => ListingDetailsScreen(listingId: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(path: '/add-listing', builder: (_, __) => const AddListingScreen()),
    GoRoute(path: '/dashboard', builder: (_, __) => const AdvertiserDashboardScreen()),
  ],
);
