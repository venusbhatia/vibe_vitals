import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_monitor/screens/onboarding_screen.dart';
import 'package:health_monitor/services/user_service.dart';
import 'package:health_monitor/theme/app_theme.dart';
import 'package:health_monitor/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style for light mode
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  
  runApp(const HealthMonitorApp());
}

class HealthMonitorApp extends StatelessWidget {
  const HealthMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibe Vitals',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      // Force light mode, don't use system dark mode
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.light,
      home: const OnboardingChecker(),
    );
  }
}

class OnboardingChecker extends StatefulWidget {
  const OnboardingChecker({super.key});

  @override
  State<OnboardingChecker> createState() => _OnboardingCheckerState();
}

class _OnboardingCheckerState extends State<OnboardingChecker> {
  final UserService _userService = UserService();
  bool _isLoading = true;
  bool _hasCompletedOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final hasCompleted = await _userService.hasCompletedOnboarding();
    setState(() {
      _hasCompletedOnboarding = hasCompleted;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const BackgroundGradient(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_hasCompletedOnboarding) {
      return const BackgroundGradient(child: HomeScreen());
    } else {
      return const BackgroundGradient(child: OnboardingScreen());
    }
  }
}

class BackgroundGradient extends StatelessWidget {
  final Widget child;
  
  const BackgroundGradient({
    super.key,
    required this.child,
  });
  
  @override
  Widget build(BuildContext context) {
    // Ignore dark mode and always use light theme colors
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF0F4FF),
            const Color(0xFFF8F9FF),
            const Color(0xFFF0F4FF),
            const Color(0xFFEDF6FF),
          ],
          stops: const [0.0, 0.3, 0.6, 1.0],
        ),
      ),
      child: child,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vibe Vitals',
          style: TextStyle(
            fontFamily: 'Gistesy',
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Welcome to Health Monitor',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
