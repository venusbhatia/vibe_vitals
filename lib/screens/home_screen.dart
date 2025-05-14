import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:health_monitor/models/health_metric.dart';
import 'package:health_monitor/screens/metric_detail_screen.dart';
import 'package:health_monitor/services/health_service.dart';
import 'package:health_monitor/theme/app_theme.dart';
import 'package:health_monitor/utils/formatters.dart';
import 'package:health_monitor/widgets/metric_input_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_monitor/models/user_profile.dart';
import 'package:health_monitor/services/user_service.dart';
import 'package:health_monitor/screens/profile_screen.dart';
import 'package:flutter/services.dart';
import 'package:health_monitor/widgets/profile_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final HealthService _healthService = HealthService();
  final UserService _userService = UserService();
  Map<MetricType, double> _metricValues = {};
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    
    
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      
      final userProfile = await _userService.getUserProfile();
      
      
      final stepsValue = await _healthService.getTodayTotal(MetricType.steps);
      final heartRateValue = await _healthService.getLatestValue(MetricType.heartRate);
      final waterValue = await _healthService.getTodayTotal(MetricType.water);
      final sleepValue = await _healthService.getLatestValue(MetricType.sleep);
      final digitalDetoxValue = await _healthService.getTodayTotal(MetricType.digitalDetox);
      final activeBreaksValue = await _healthService.getTodayTotal(MetricType.activeBreaks);

      setState(() {
        _userProfile = userProfile;
        _metricValues = {
          MetricType.steps: stepsValue,
          MetricType.heartRate: heartRateValue,
          MetricType.water: waterValue,
          MetricType.sleep: sleepValue,
          MetricType.digitalDetox: digitalDetoxValue,
          MetricType.activeBreaks: activeBreaksValue,
        };
        _isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
    }
  }

  Future<void> _showAddMetricDialog(MetricType type) async {
    String title = '';
    String unit = '';

    switch (type) {
      case MetricType.steps:
        title = 'Steps';
        unit = 'steps';
        break;
      case MetricType.heartRate:
        title = 'Heart Rate';
        unit = 'bpm';
        break;
      case MetricType.water:
        title = 'Water';
        unit = 'glasses';
        break;
      case MetricType.sleep:
        title = 'Sleep';
        unit = 'hours';
        break;
      case MetricType.digitalDetox:
        title = 'Screen-off time';
        unit = 'mins';
        break;
      case MetricType.activeBreaks:
        title = 'Outstanding time';
        unit = 'mins';
        break;
    }

    final value = await showDialog<double>(
      context: context,
      builder: (context) => MetricInputDialog(
        type: type,
        title: title,
        unit: unit,
      ),
    );

    if (value != null) {
      final metric = _healthService.createMetric(
        title: title,
        value: value,
        unit: unit,
        type: type,
      );

      await _healthService.addMetric(metric);
      await _loadData();
    }
  }

  void _navigateToDetailScreen(
    MetricType type,
    String title,
    String unit,
    IconData icon,
    Color color,
  ) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => MetricDetailScreen(
          type: type,
          title: title,
          unit: unit,
          icon: icon,
          color: color,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.05);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;
          
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          
          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    ).then((_) => _loadData()); 
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final formattedDate = Formatters.formatDate(today);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: _fadeAnimation,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    expandedHeight: 90,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: ProfileAvatar(
                          userProfile: _userProfile,
                          size: 36.0,
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => 
                                  const ProfileScreen(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  const begin = Offset(0.0, -0.05);
                                  const end = Offset.zero;
                                  const curve = Curves.easeOutCubic;
                                  
                                  var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                  var offsetAnimation = animation.drive(tween);
                                  
                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                  );
                                },
                                transitionDuration: const Duration(milliseconds: 300),
                              ),
                            ).then((_) => _loadData()); 
                          },
                        ),
                      ),
                    ],
                    flexibleSpace: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: FlexibleSpaceBar(
                          title: Text(
                            'vibe vitals',
                            style: TextStyle(
                              fontFamily: 'Gistesy',
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 36,
                              letterSpacing: 0.5,
                            ),
                          ),
                          centerTitle: true,
                          titlePadding: const EdgeInsets.only(bottom: 8),
                          background: Container(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'Hello, ',
                                style: Theme.of(context).textTheme.headlineMedium
                              ),
                              Text(
                                _userProfile?.name.isNotEmpty == true ? _userProfile!.name : 'User',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 16,
                                color: AppTheme.textSecondaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                formattedDate,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          _buildSectionHeader(context, 'Today\'s Activity'),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      delegate: SliverChildListDelegate([
                        _buildHealthCard(
                          'Steps',
                          _metricValues[MetricType.steps]?.toInt().toString() ?? '0',
                          'steps today',
                          Icons.directions_walk_rounded,
                          AppTheme.primaryColor,
                          () => _navigateToDetailScreen(
                            MetricType.steps,
                            'Steps',
                            'steps',
                            Icons.directions_walk_rounded,
                            AppTheme.primaryColor,
                          ),
                        ),
                        _buildHealthCard(
                          'Heart Rate',
                          _metricValues[MetricType.heartRate]?.toInt().toString() ?? '0',
                          'bpm',
                          Icons.favorite_rounded,
                          AppTheme.errorColor,
                          () => _navigateToDetailScreen(
                            MetricType.heartRate,
                            'Heart Rate',
                            'bpm',
                            Icons.favorite_rounded,
                            AppTheme.errorColor,
                          ),
                        ),
                        _buildHealthCard(
                          'Water',
                          _metricValues[MetricType.water]?.toInt().toString() ?? '0',
                          'glasses',
                          Icons.water_drop_rounded,
                          AppTheme.secondaryColor,
                          () => _navigateToDetailScreen(
                            MetricType.water,
                            'Water',
                            'glasses',
                            Icons.water_drop_rounded,
                            AppTheme.secondaryColor,
                          ),
                        ),
                        _buildHealthCard(
                          'Sleep',
                          _metricValues[MetricType.sleep]?.toString() ?? '0',
                          'hours',
                          Icons.bedtime_rounded,
                          AppTheme.tertiaryColor,
                          () => _navigateToDetailScreen(
                            MetricType.sleep,
                            'Sleep',
                            'hours',
                            Icons.bedtime_rounded,
                            AppTheme.tertiaryColor,
                          ),
                        ),
                        _buildHealthCard(
                          'Screen-off time',
                          _metricValues[MetricType.digitalDetox]?.toInt().toString() ?? '0',
                          'mins today',
                          Icons.phonelink_erase_rounded,
                          const Color(0xFF5E35B1), 
                          () => _navigateToDetailScreen(
                            MetricType.digitalDetox,
                            'Screen-off time',
                            'mins',
                            Icons.phonelink_erase_rounded,
                            const Color(0xFF5E35B1),
                          ),
                        ),
                        _buildHealthCard(
                          'Outstanding time',
                          _metricValues[MetricType.activeBreaks]?.toInt().toString() ?? '0',
                          'mins today',
                          Icons.accessibility_new_rounded,
                          const Color(0xFF00897B), 
                          () => _navigateToDetailScreen(
                            MetricType.activeBreaks,
                            'Outstanding time',
                            'mins',
                            Icons.accessibility_new_rounded,
                            const Color(0xFF00897B),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          _buildSectionHeader(context, 'Quick Actions'),
                          const SizedBox(height: 16),
                          _buildQuickActionButton(
                            'Add Steps',
                            Icons.directions_walk_rounded,
                            AppTheme.primaryColor,
                            () => _showAddMetricDialog(MetricType.steps),
                          ),
                          const SizedBox(height: 12),
                          _buildQuickActionButton(
                            'Record Heart Rate',
                            Icons.favorite_rounded,
                            AppTheme.errorColor,
                            () => _showAddMetricDialog(MetricType.heartRate),
                          ),
                          const SizedBox(height: 12),
                          _buildQuickActionButton(
                            'Log Water Intake',
                            Icons.water_drop_rounded,
                            AppTheme.secondaryColor,
                            () => _showAddMetricDialog(MetricType.water),
                          ),
                          const SizedBox(height: 12),
                          _buildQuickActionButton(
                            'Record Sleep',
                            Icons.bedtime_rounded,
                            AppTheme.tertiaryColor,
                            () => _showAddMetricDialog(MetricType.sleep),
                          ),
                          const SizedBox(height: 12),
                          _buildQuickActionButton(
                            'Log Screen-off time',
                            Icons.phonelink_erase_rounded,
                            const Color(0xFF5E35B1), 
                            () => _showAddMetricDialog(MetricType.digitalDetox),
                          ),
                          const SizedBox(height: 12),
                          _buildQuickActionButton(
                            'Log Outstanding time',
                            Icons.accessibility_new_rounded,
                            const Color(0xFF00897B), 
                            () => _showAddMetricDialog(MetricType.activeBreaks),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: _isLoading 
          ? null 
          : FloatingActionButton(
              onPressed: _loadData,
              child: const Icon(Icons.refresh_rounded),
            ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.dividerColor.withOpacity(0),
                  AppTheme.dividerColor,
                  AppTheme.dividerColor.withOpacity(0),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthCard(
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    
    String targetValue = '';
    if (_userProfile != null) {
      if (title == 'Steps') {
        targetValue = _userProfile!.stepsGoal.toString();
      } else if (title == 'Water') {
        targetValue = _userProfile!.waterGoal.toString();
      } else if (title == 'Sleep') {
        targetValue = _userProfile!.sleepGoal.toString();
      } else if (title == 'Screen-off time') {
        targetValue = _userProfile!.digitalDetoxGoal.toString();
      } else if (title == 'Outstanding time') {
        targetValue = _userProfile!.activeBreaksGoal.toString();
      }
    }
    
    
    double progress = 0.0;
    if (targetValue.isNotEmpty && value != '0') {
      double currentVal = double.tryParse(value) ?? 0;
      double targetVal = double.tryParse(targetValue) ?? 1;
      progress = (currentVal / targetVal).clamp(0.0, 1.0);
    }

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.8),
                  Colors.white.withOpacity(0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          icon,
                          size: 22,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                      Text(
                        unit,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondaryColor,
                          letterSpacing: -0.3,
                        ),
                      ),
                      if (targetValue.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: color.withOpacity(0.1),
                                  valueColor: AlwaysStoppedAnimation<Color>(color),
                                  minHeight: 4,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Target: $targetValue',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${(progress * 100).toInt()}%',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: color,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                GestureDetector(
                                  onTap: () => _showTargetInfoDialog(context, title),
                                  child: Icon(
                                    Icons.info_outline,
                                    size: 12,
                                    color: color.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ],
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.8),
                  Colors.white.withOpacity(0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showTargetInfoDialog(BuildContext context, String title) {
    String dialogTitle = '';
    String dialogContent = '';
    IconData dialogIcon = Icons.info_outline;
    Color dialogColor = AppTheme.primaryColor;
    
    if (_userProfile == null) return;
    
    if (title == 'Steps') {
      dialogTitle = 'Daily Steps Target';
      final isCustom = _userProfile!.customStepsGoal != null;
      final recommendedSteps = _userProfile!.recommendedSteps;
      final actualGoal = _userProfile!.stepsGoal;
      
      dialogContent = isCustom
          ? 'Your custom target is $actualGoal steps. The recommended target based on your profile would be $recommendedSteps steps.\n\nRegular walking helps maintain cardiovascular health, manage weight, and improve mood.'
          : 'Your recommended target of $actualGoal steps is based on your age (${_userProfile!.age}), gender, and BMI (${_userProfile!.bmi.toStringAsFixed(1)}).\n\nRegular walking helps maintain cardiovascular health, manage weight, and improve mood.';
      
      dialogIcon = Icons.directions_walk_rounded;
      dialogColor = AppTheme.primaryColor;
    } else if (title == 'Water') {
      dialogTitle = 'Water Intake Target';
      final isCustom = _userProfile!.customWaterGoal != null;
      final recommendedWater = _userProfile!.recommendedWaterIntake;
      final actualGoal = _userProfile!.waterGoal;
      
      dialogContent = isCustom
          ? 'Your custom target is $actualGoal glasses. The recommended target based on your weight would be $recommendedWater glasses.\n\nStaying properly hydrated supports metabolism, skin health, and cognitive function.'
          : 'Your recommended target of $actualGoal glasses is calculated based on your weight (${_userProfile!.weightKg.toStringAsFixed(1)} kg) and activity level.\n\nStaying properly hydrated supports metabolism, skin health, and cognitive function.';
      
      dialogIcon = Icons.water_drop_rounded;
      dialogColor = AppTheme.secondaryColor;
    } else if (title == 'Sleep') {
      dialogTitle = 'Sleep Duration Target';
      final isCustom = _userProfile!.customSleepGoal != null;
      final recommendedSleep = _userProfile!.recommendedSleepHours;
      final actualGoal = _userProfile!.sleepGoal;
      
      dialogContent = isCustom
          ? 'Your custom target is $actualGoal hours. The recommended target based on your age would be $recommendedSleep hours.\n\nQuality sleep is essential for recovery, immune function, and mental well-being.'
          : 'Your recommended sleep target of $actualGoal hours is based on your age group.\n\nQuality sleep is essential for recovery, immune function, and mental well-being.';
      
      dialogIcon = Icons.bedtime_rounded;
      dialogColor = AppTheme.tertiaryColor;
    } else if (title == 'Screen-off time') {
      dialogTitle = 'Screen-off Time Target';
      final isCustom = _userProfile!.customDigitalDetoxGoal != null;
      final recommendedDetox = _userProfile!.recommendedDigitalDetox;
      final actualGoal = _userProfile!.digitalDetoxGoal;
      
      dialogContent = isCustom
          ? 'Your custom target is $actualGoal minutes. The recommended target based on your profile would be $recommendedDetox minutes.\n\nTaking regular breaks from screens helps reduce eye strain, improve focus, and promote better sleep quality.'
          : 'Your recommended target of $actualGoal minutes is based on your age and lifestyle factors.\n\nTaking regular breaks from screens helps reduce eye strain, improve focus, and promote better sleep quality.';
      
      dialogIcon = Icons.phonelink_erase_rounded;
      dialogColor = const Color(0xFF5E35B1); 
    } else if (title == 'Outstanding time') {
      dialogTitle = 'Outstanding Time Target';
      final isCustom = _userProfile!.customActiveBreaksGoal != null;
      final recommendedBreaks = _userProfile!.recommendedActiveBreaks;
      final actualGoal = _userProfile!.activeBreaksGoal;
      
      dialogContent = isCustom
          ? 'Your custom target is $actualGoal minutes. The recommended target based on your profile would be $recommendedBreaks minutes.\n\nStanding up and moving regularly throughout the day helps improve circulation, reduce stiffness, and boost productivity.'
          : 'Your recommended target of $actualGoal minutes is based on your age and BMI (${_userProfile!.bmi.toStringAsFixed(1)}).\n\nStanding up and moving regularly throughout the day helps improve circulation, reduce stiffness, and boost productivity.';
      
      dialogIcon = Icons.accessibility_new_rounded;
      dialogColor = const Color(0xFF00897B); 
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: dialogColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            dialogIcon,
                            color: dialogColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          dialogTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      dialogContent,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textPrimaryColor.withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            foregroundColor: dialogColor,
                            backgroundColor: dialogColor.withOpacity(0.1),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Got it',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 