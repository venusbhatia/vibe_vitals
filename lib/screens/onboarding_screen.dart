import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:health_monitor/models/user_profile.dart';
import 'package:health_monitor/screens/home_screen.dart';
import 'package:health_monitor/services/user_service.dart';
import 'package:health_monitor/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:health_monitor/main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final UserService _userService = UserService();
  int _currentPage = 0;
  final int _totalPages = 6;
  
  
  String _name = '';
  DateTime? _dateOfBirth;
  Gender _gender = Gender.preferNotToSay;
  double _heightCm = 170.0;
  double _weightKg = 70.0;
  
  
  int _stepsGoal = 10000;
  int _waterGoal = 8;
  double _sleepGoal = 8.0;
  int _digitalDetoxGoal = 120;
  int _activeBreaksGoal = 60;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    if (_dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your date of birth')),
      );
      return;
    }

    final userProfile = UserProfile(
      name: _name,
      dateOfBirth: _dateOfBirth!,
      gender: _gender,
      heightCm: _heightCm,
      weightKg: _weightKg,
      customStepsGoal: _stepsGoal,
      customWaterGoal: _waterGoal,
      customSleepGoal: _sleepGoal,
      customDigitalDetoxGoal: _digitalDetoxGoal,
      customActiveBreaksGoal: _activeBreaksGoal,
    );

    await _userService.saveUserProfile(userProfile);
    
    
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const BackgroundGradient(
            child: HomeScreen(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              _buildWelcomePage(),
              _buildDOBPage(),
              _buildGenderPage(),
              _wrapWithSafeArea(_buildHeightWeightPage()),
              _wrapWithSafeArea(_buildHealthGoalsPage()),
              _wrapWithSafeArea(_buildWellnessGoalsPage()),
            ],
          ),
          
          
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.only(
                  left: 32.0, 
                  right: 32.0, 
                  bottom: 24.0, 
                  top: 16.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    _currentPage > 0
                      ? GestureDetector(
                          onTap: _previousPage,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xFF007AFF),
                              size: 16,
                            ),
                          ),
                        )
                      : const SizedBox(width: 40),
                    
                    
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: _buildProgressIndicator(),
                      ),
                    ),
                    
                    
                    GestureDetector(
                      onTap: _nextPage,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF007AFF),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          _currentPage < _totalPages - 1 ? 'Continue' : 'Get Started',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return SizedBox(
      height: 4,
      child: Row(
        children: List.generate(_totalPages, (index) {
          final isActive = index <= _currentPage;
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < _totalPages - 1 ? 4 : 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: isActive
                    ? const Color(0xFF007AFF)
                    : const Color(0xFFE5E5EA).withOpacity(0.4),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              
              
              const Text(
                'vibe vitals',
                style: TextStyle(
                  fontFamily: 'Gistesy',
                  fontSize: 60,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000),
                ),
              ),
              
              const SizedBox(height: 3),
              
              
              const Text(
                "welcome to vibe vitals! \n \nwe'll help you track your health with precision :)",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D1D1F),
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
              
              const SizedBox(height: 16),
              
              
              const Text(
                'Personalized insights to help you achieve your health goals.',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF86868B),
                  height: 1.4,
                  letterSpacing: -0.2,
                ),
              ),
              
              const SizedBox(height: 60),
              
              
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Your name',
                    hintStyle: const TextStyle(
                      color: Color(0xFFAEAEB2),
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1D1D1F),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
              ),
              
              const SizedBox(height: 8),
              
              
              const Text(
                'How should we address you?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF86868B),
                  letterSpacing: -0.08,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDOBPage() {
    final dateFormat = DateFormat('MMMM dd, yyyy');
    final birthDateText = _dateOfBirth != null
        ? dateFormat.format(_dateOfBirth!)
        : 'Select your date of birth';

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              
              
              const Text(
                'When were you born?',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D1D1F),
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
              
              const SizedBox(height: 16),
              
              
              const Text(
                'We\'ll use this to calculate your age and provide age-appropriate health insights.',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF86868B),
                  height: 1.4,
                  letterSpacing: -0.2,
                ),
              ),
              
              const SizedBox(height: 40),
              
              
              InkWell(
                onTap: () async {
                  final currentDate = DateTime.now();
                  final initialDate = _dateOfBirth ?? DateTime(currentDate.year - 25);
                  final firstDate = DateTime(currentDate.year - 120);
                  final lastDate = DateTime(currentDate.year - 10);
                  
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: const Color(0xFF007AFF),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  
                  if (selectedDate != null) {
                    setState(() {
                      _dateOfBirth = selectedDate;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        birthDateText,
                        style: TextStyle(
                          fontSize: 17,
                          color: _dateOfBirth != null
                              ? const Color(0xFF1D1D1F)
                              : const Color(0xFFAEAEB2),
                        ),
                      ),
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF007AFF),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderPage() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              
              const Text(
                'What is your gender?',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D1D1F),
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                'This helps us provide more accurate health recommendations.',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF86868B),
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 40),
              
              
              _buildGenderOption(
                title: 'Male',
                value: Gender.male,
                icon: Icons.male_outlined,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              _buildGenderOption(
                title: 'Female',
                value: Gender.female,
                icon: Icons.female_outlined,
                color: Colors.pink,
              ),
              const SizedBox(height: 16),
              _buildGenderOption(
                title: 'Other',
                value: Gender.other,
                icon: Icons.person_outline,
                color: Colors.purple,
              ),
              const SizedBox(height: 16),
              _buildGenderOption(
                title: 'Prefer not to say',
                value: Gender.preferNotToSay,
                icon: Icons.not_interested_outlined,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption({
    required String title,
    required Gender value,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _gender == value;
    
    return InkWell(
      onTap: () {
        setState(() {
          _gender = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildHeightWeightPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          
          
          const Text(
            'Height & Weight',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D1D1F),
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          
          const SizedBox(height: 16),
          
          
          const Text(
            'This information helps us calculate your BMI and track your fitness progress.',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Color(0xFF86868B),
              height: 1.4,
              letterSpacing: -0.2,
            ),
          ),
          
          const SizedBox(height: 40),
          
          
          _buildHeightInput(),
          
          const SizedBox(height: 30),
          
          
          _buildWeightInput(),
          
          if (_heightCm > 0 && _weightKg > 0) ...[
            const SizedBox(height: 30),
            _buildBMIIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeightInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Height (cm)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _heightCm,
                min: 100,
                max: 220,
                divisions: 120,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  setState(() {
                    _heightCm = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 60,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                '${_heightCm.toStringAsFixed(0)} cm',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeightInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weight (kg)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _weightKg,
                min: 30,
                max: 150,
                divisions: 120,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  setState(() {
                    _weightKg = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 60,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                '${_weightKg.toStringAsFixed(1)} kg',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBMIIndicator() {
    final bmi = _weightKg / ((_heightCm / 100) * (_heightCm / 100));
    String category;
    Color color;
    
    if (bmi < 18.5) {
      category = 'Underweight';
      color = Colors.blue;
    } else if (bmi < 25) {
      category = 'Normal';
      color = Colors.green;
    } else if (bmi < 30) {
      category = 'Overweight';
      color = Colors.orange;
    } else {
      category = 'Obese';
      color = Colors.red;
    }
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'BMI: ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              bmi.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '($category)',
              style: TextStyle(
                fontSize: 16,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 30,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [
                Colors.blue,
                Colors.green,
                Colors.orange,
                Colors.red,
              ],
              stops: [0.25, 0.5, 0.75, 1.0],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double position = 0;
              if (bmi <= 15) {
                position = 0;
              } else if (bmi >= 40) {
                position = constraints.maxWidth;
              } else {
                
                position = (bmi - 15) / 25 * constraints.maxWidth;
              }
              
              return Stack(
                children: [
                  Positioned(
                    left: position - 15,
                    top: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Underweight', style: TextStyle(fontSize: 12)),
            Text('Normal', style: TextStyle(fontSize: 12)),
            Text('Overweight', style: TextStyle(fontSize: 12)),
            Text('Obese', style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthGoalsPage() {
    
    UserProfile? tempProfile;
    if (_dateOfBirth != null) {
      tempProfile = UserProfile(
        name: _name,
        dateOfBirth: _dateOfBirth!,
        gender: _gender,
        heightCm: _heightCm,
        weightKg: _weightKg,
      );
      
      
      if (_stepsGoal == 10000) {
        _stepsGoal = tempProfile.recommendedSteps;
      }
      if (_waterGoal == 8) {
        _waterGoal = tempProfile.recommendedWaterIntake;
      }
      if (_sleepGoal == 8.0) {
        _sleepGoal = tempProfile.recommendedSleepHours;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          
          
          const Text(
            'Set Your Health Goals',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D1D1F),
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          
          const SizedBox(height: 16),
          
          
          const Text(
            'We\'ve suggested personalized targets based on your profile. Feel free to adjust them.',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Color(0xFF86868B),
              height: 1.4,
              letterSpacing: -0.2,
            ),
          ),
          
          const SizedBox(height: 40),
          
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  
                  _buildGoalSetting(
                    title: 'Daily Steps',
                    icon: Icons.directions_walk_rounded,
                    color: const Color(0xFF007AFF),
                    value: _stepsGoal.toDouble(),
                    minValue: 5000,
                    maxValue: 15000,
                    divisions: 20,
                    valueLabel: '${_stepsGoal.toStringAsFixed(0)} steps',
                    onChanged: (value) {
                      setState(() {
                        _stepsGoal = value.round();
                      });
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  
                  _buildGoalSetting(
                    title: 'Daily Water Intake',
                    icon: Icons.water_drop_rounded,
                    color: const Color(0xFF5AC8FA),
                    value: _waterGoal.toDouble(),
                    minValue: 4,
                    maxValue: 12,
                    divisions: 8,
                    valueLabel: '${_waterGoal.toStringAsFixed(0)} glasses',
                    onChanged: (value) {
                      setState(() {
                        _waterGoal = value.round();
                      });
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  
                  _buildGoalSetting(
                    title: 'Sleep Duration',
                    icon: Icons.bedtime_rounded,
                    color: const Color(0xFF5E5CE6),
                    value: _sleepGoal,
                    minValue: 5,
                    maxValue: 10,
                    divisions: 10,
                    valueLabel: '${_sleepGoal.toStringAsFixed(1)} hours',
                    onChanged: (value) {
                      setState(() {
                        _sleepGoal = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWellnessGoalsPage() {
    
    UserProfile? tempProfile;
    if (_dateOfBirth != null) {
      tempProfile = UserProfile(
        name: _name,
        dateOfBirth: _dateOfBirth!,
        gender: _gender,
        heightCm: _heightCm,
        weightKg: _weightKg,
      );
      
      
      if (_digitalDetoxGoal == 120) {
        _digitalDetoxGoal = tempProfile.recommendedDigitalDetox;
      }
      if (_activeBreaksGoal == 60) {
        _activeBreaksGoal = tempProfile.recommendedActiveBreaks;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          
          
          const Text(
            'Set Your Wellness Goals',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D1D1F),
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          
          const SizedBox(height: 16),
          
          
          const Text(
            'Balance your digital time and physical movement for overall wellbeing.',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Color(0xFF86868B),
              height: 1.4,
              letterSpacing: -0.2,
            ),
          ),
          
          const SizedBox(height: 40),
          
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  
                  _buildGoalSetting(
                    title: 'Screen-off Time',
                    icon: Icons.phonelink_erase_rounded,
                    color: const Color(0xFF5E35B1), 
                    value: _digitalDetoxGoal.toDouble(),
                    minValue: 30,
                    maxValue: 240,
                    divisions: 7,
                    valueLabel: '${_digitalDetoxGoal.toStringAsFixed(0)} mins',
                    onChanged: (value) {
                      setState(() {
                        _digitalDetoxGoal = value.round();
                      });
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  
                  _buildGoalSetting(
                    title: 'Outstanding Time',
                    icon: Icons.accessibility_new_rounded,
                    color: const Color(0xFF00897B), 
                    value: _activeBreaksGoal.toDouble(),
                    minValue: 15,
                    maxValue: 120,
                    divisions: 7,
                    valueLabel: '${_activeBreaksGoal.toStringAsFixed(0)} mins',
                    onChanged: (value) {
                      setState(() {
                        _activeBreaksGoal = value.round();
                      });
                    },
                  ),
                  
                  const SizedBox(height: 30),
                  
                  
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: const Color(0xFF007AFF),
                          size: 24,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Wellness Tips',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1D1D1F),
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Regular breaks from screens and movement throughout the day help reduce stress and improve focus.',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF86868B),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSetting({
    required String title,
    required IconData icon,
    required Color color,
    required double value,
    required double minValue,
    required double maxValue,
    required int divisions,
    required String valueLabel,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  valueLabel,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: color.withOpacity(0.2),
              thumbColor: Colors.white,
              overlayColor: color.withOpacity(0.1),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 10,
                elevation: 4,
              ),
            ),
            child: Slider(
              value: value,
              min: minValue,
              max: maxValue,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  minValue.toStringAsFixed(minValue.truncateToDouble() == minValue ? 0 : 1),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  maxValue.toStringAsFixed(maxValue.truncateToDouble() == maxValue ? 0 : 1),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _wrapWithSafeArea(Widget page) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: page,
      ),
    );
  }
} 