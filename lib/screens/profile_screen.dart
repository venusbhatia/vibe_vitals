import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:health_monitor/models/user_profile.dart';
import 'package:health_monitor/services/user_service.dart';
import 'package:health_monitor/theme/app_theme.dart';
import 'package:health_monitor/main.dart';
import 'package:intl/intl.dart';
import 'package:health_monitor/widgets/profile_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  bool _isLoading = true;
  UserProfile? _userProfile;
  final TextEditingController _nameController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    
    
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    
    _loadUserProfile();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  
  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final userProfile = await _userService.getUserProfile();
      
      setState(() {
        _userProfile = userProfile;
        if (userProfile != null) {
          _nameController.text = userProfile.name;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _updateName() async {
    if (_userProfile == null) return;
    
    final updatedProfile = _userProfile!.copyWith(
      name: _nameController.text,
    );
    
    await _userService.updateUserProfile(updatedProfile);
    
    setState(() {
      _userProfile = updatedProfile;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }
  
  Future<void> _updateHeight(double height) async {
    if (_userProfile == null) return;
    
    final updatedProfile = _userProfile!.copyWith(
      heightCm: height,
    );
    
    await _userService.updateUserProfile(updatedProfile);
    
    setState(() {
      _userProfile = updatedProfile;
    });
  }
  
  Future<void> _updateWeight(double weight) async {
    if (_userProfile == null) return;
    
    final updatedProfile = _userProfile!.copyWith(
      weightKg: weight,
    );
    
    await _userService.updateUserProfile(updatedProfile);
    
    setState(() {
      _userProfile = updatedProfile;
    });
  }
  
  Future<void> _updateGender(Gender gender) async {
    if (_userProfile == null) return;
    
    final updatedProfile = _userProfile!.copyWith(
      gender: gender,
    );
    
    await _userService.updateUserProfile(updatedProfile);
    
    setState(() {
      _userProfile = updatedProfile;
    });
  }

  Future<void> _updateDateOfBirth(DateTime dateOfBirth) async {
    if (_userProfile == null) return;
    
    final updatedProfile = _userProfile!.copyWith(
      dateOfBirth: dateOfBirth,
    );
    
    await _userService.updateUserProfile(updatedProfile);
    
    setState(() {
      _userProfile = updatedProfile;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Date of birth updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (_userProfile == null) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: const Center(
          child: Text('User profile not found'),
        ),
      );
    }
    
    final dateFormat = DateFormat('MMMM dd, yyyy');
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Your Profile', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white.withOpacity(0.8),
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: BackgroundGradient(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            children: [
              
              _buildProfileHeader(),
              const SizedBox(height: 40),
              
              
              _buildInfoCategory('Personal Information'),
              const SizedBox(height: 16),
              _buildEditableNameField(),
              const SizedBox(height: 12),
              _buildDateOfBirthRow(),
              const SizedBox(height: 12),
              _buildGenderSelector(),
              const SizedBox(height: 30),
              
              
              _buildInfoCategory('Body Measurements'),
              const SizedBox(height: 16),
              _buildHeightSlider(),
              const SizedBox(height: 20),
              _buildWeightSlider(),
              const SizedBox(height: 20),
              _buildBMICard(),
              const SizedBox(height: 40),
              
              
              _buildInfoCategory('Personal Recommendations'),
              const SizedBox(height: 16),
              _buildRecommendationsCard(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildProfileHeader() {
    return Column(
      children: [
        ProfileAvatar(
          userProfile: _userProfile,
          size: 100.0,
        ),
        const SizedBox(height: 16),
        Text(
          _userProfile!.name.isNotEmpty ? _userProfile!.name : 'User',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.cake_outlined,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_userProfile!.age} years',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.tertiaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    _userProfile!.gender == Gender.male 
                        ? Icons.male_outlined 
                        : _userProfile!.gender == Gender.female 
                            ? Icons.female_outlined 
                            : Icons.person_outline,
                    size: 16,
                    color: AppTheme.tertiaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _userProfile!.genderString,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.tertiaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildInfoCategory(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Container(
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
      ],
    );
  }
  
  Widget _buildEditableNameField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.9),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withOpacity(0.7),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.only(top: 4),
                          hintText: 'Enter your name',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimaryColor,
                        ),
                        onEditingComplete: _updateName,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppTheme.primaryColor,
                      size: 14,
                    ),
                  ),
                  onPressed: _updateName,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildDateOfBirthRow() {
    final dateFormat = DateFormat('MMMM dd, yyyy');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                final currentDate = DateTime.now();
                final initialDate = _userProfile!.dateOfBirth;
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
                          primary: AppTheme.primaryColor,
                        ),
                        dialogBackgroundColor: Colors.white,
                      ),
                      child: child!,
                    );
                  },
                );
                
                if (selectedDate != null) {
                  _updateDateOfBirth(selectedDate);
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.9),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white.withOpacity(0.7),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.cake_outlined,
                        color: AppTheme.errorColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date of Birth',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                dateFormat.format(_userProfile!.dateOfBirth),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textPrimaryColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '(${_userProfile!.age} years)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppTheme.textSecondaryColor,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildGenderSelector() {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.9),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withOpacity(0.7),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.tertiaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.wc_outlined,
                        color: AppTheme.tertiaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildGenderOption(
                        label: 'Male',
                        value: Gender.male,
                        icon: Icons.male_outlined,
                      ),
                      _buildGenderOption(
                        label: 'Female',
                        value: Gender.female,
                        icon: Icons.female_outlined,
                      ),
                      _buildGenderOption(
                        label: 'Other',
                        value: Gender.other,
                        icon: Icons.person_outline,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildGenderOption({
    required String label,
    required Gender value,
    required IconData icon,
  }) {
    final isSelected = _userProfile!.gender == value;
    
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _updateGender(value),
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected 
                  ? AppTheme.tertiaryColor.withOpacity(0.2) 
                  : Colors.transparent,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon, 
                  color: isSelected 
                      ? AppTheme.tertiaryColor 
                      : AppTheme.textSecondaryColor,
                  size: 20,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected 
                        ? AppTheme.tertiaryColor 
                        : AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeightSlider() {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.9),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withOpacity(0.7),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.height_outlined,
                            color: AppTheme.secondaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Height',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_userProfile!.heightCm.toStringAsFixed(0)} cm',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: AppTheme.secondaryColor,
                    inactiveTrackColor: AppTheme.secondaryColor.withOpacity(0.2),
                    thumbColor: Colors.white,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 12,
                      elevation: 4,
                    ),
                    overlayColor: AppTheme.secondaryColor.withOpacity(0.1),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: _userProfile!.heightCm,
                    min: 100,
                    max: 220,
                    divisions: 120,
                    onChanged: (value) {
                      setState(() {
                        _userProfile = _userProfile!.copyWith(heightCm: value);
                      });
                    },
                    onChangeEnd: _updateHeight,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '100 cm',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      Text(
                        '220 cm',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildWeightSlider() {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.9),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withOpacity(0.7),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.monitor_weight_outlined,
                            color: AppTheme.accentColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Weight',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_userProfile!.weightKg.toStringAsFixed(1)} kg',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: AppTheme.accentColor,
                    inactiveTrackColor: AppTheme.accentColor.withOpacity(0.2),
                    thumbColor: Colors.white,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 12,
                      elevation: 4,
                    ),
                    overlayColor: AppTheme.accentColor.withOpacity(0.1),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: _userProfile!.weightKg,
                    min: 30,
                    max: 150,
                    divisions: 120,
                    onChanged: (value) {
                      setState(() {
                        _userProfile = _userProfile!.copyWith(weightKg: value);
                      });
                    },
                    onChangeEnd: _updateWeight,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '30 kg',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      Text(
                        '150 kg',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildBMICard() {
    final bmi = _userProfile!.bmi;
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
    
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.9),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withOpacity(0.7),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.monitor_heart_outlined,
                        color: color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'BMI (Body Mass Index)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.withOpacity(0.8),
                            color.withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            bmi.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Your BMI',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                category,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
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
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: position - 6,
                            top: -5,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: color, width: 3),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Underweight', 
                        style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Normal', 
                        style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Overweight', 
                        style: TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Obese', 
                        style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: color.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: color,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getBMIMessage(category),
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textPrimaryColor.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  String _getBMIMessage(String category) {
    switch (category) {
      case 'Underweight':
        return 'You may need to gain some weight. Consider consulting with a healthcare professional.';
      case 'Normal':
        return 'Your weight is within the healthy range. Keep up the good work!';
      case 'Overweight':
        return 'Consider working on reducing your weight through diet and exercise.';
      case 'Obese':
        return 'It\'s important to take steps to manage your weight. Consult with a healthcare provider.';
      default:
        return '';
    }
  }

  Widget _buildRecommendationsCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.9),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withOpacity(0.7),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.recommend_outlined,
                            color: AppTheme.primaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Your Health Targets',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () => _showEditGoalsDialog(),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                
                _buildRecommendationItem(
                  icon: Icons.directions_walk_rounded,
                  color: AppTheme.primaryColor,
                  title: 'Daily Steps',
                  value: '${_userProfile!.stepsGoal}',
                  description: _getStepsRecommendationText(),
                  isCustom: _userProfile!.customStepsGoal != null,
                ),
                const SizedBox(height: 16),
                
                
                _buildRecommendationItem(
                  icon: Icons.water_drop_rounded,
                  color: AppTheme.secondaryColor,
                  title: 'Water Intake',
                  value: '${_userProfile!.waterGoal} glasses',
                  description: _getWaterRecommendationText(),
                  isCustom: _userProfile!.customWaterGoal != null,
                ),
                const SizedBox(height: 16),
                
                
                _buildRecommendationItem(
                  icon: Icons.bedtime_rounded,
                  color: AppTheme.tertiaryColor,
                  title: 'Sleep Duration',
                  value: '${_userProfile!.sleepGoal} hours',
                  description: _getSleepRecommendationText(),
                  isCustom: _userProfile!.customSleepGoal != null,
                ),
                const SizedBox(height: 16),
                
                
                _buildRecommendationItem(
                  icon: Icons.phonelink_erase_rounded,
                  color: const Color(0xFF5E35B1), 
                  title: 'Digital Detox',
                  value: '${_userProfile!.digitalDetoxGoal} mins',
                  description: _getDigitalDetoxRecommendationText(),
                  isCustom: _userProfile!.customDigitalDetoxGoal != null,
                ),
                const SizedBox(height: 16),
                
                
                _buildRecommendationItem(
                  icon: Icons.accessibility_new_rounded,
                  color: const Color(0xFF00897B), 
                  title: 'Active Breaks',
                  value: '${_userProfile!.activeBreaksGoal} mins',
                  description: _getActiveBreaksRecommendationText(),
                  isCustom: _userProfile!.customActiveBreaksGoal != null,
                ),
                
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppTheme.primaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'These targets are personalized based on your profile. You can customize them by tapping the Edit button.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textPrimaryColor.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _showEditGoalsDialog() {
    int stepsGoal = _userProfile!.stepsGoal;
    int waterGoal = _userProfile!.waterGoal;
    double sleepGoal = _userProfile!.sleepGoal;
    int digitalDetoxGoal = _userProfile!.digitalDetoxGoal;
    int activeBreaksGoal = _userProfile!.activeBreaksGoal;
    
    showDialog(
      context: context,
      builder: (context) {
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Edit Your Health Targets',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      
                      _buildGoalSlider(
                        title: 'Daily Steps',
                        icon: Icons.directions_walk_rounded,
                        color: AppTheme.primaryColor,
                        value: stepsGoal.toDouble(),
                        min: 5000,
                        max: 15000,
                        divisions: 20,
                        valueLabel: '${stepsGoal.toStringAsFixed(0)} steps',
                        onChanged: (value) {
                          stepsGoal = value.round();
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      
                      _buildGoalSlider(
                        title: 'Water Intake',
                        icon: Icons.water_drop_rounded,
                        color: AppTheme.secondaryColor,
                        value: waterGoal.toDouble(),
                        min: 4,
                        max: 12,
                        divisions: 8,
                        valueLabel: '${waterGoal.toStringAsFixed(0)} glasses',
                        onChanged: (value) {
                          waterGoal = value.round();
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      
                      _buildGoalSlider(
                        title: 'Sleep Duration',
                        icon: Icons.bedtime_rounded,
                        color: AppTheme.tertiaryColor,
                        value: sleepGoal,
                        min: 5,
                        max: 10,
                        divisions: 10,
                        valueLabel: '${sleepGoal.toStringAsFixed(1)} hours',
                        onChanged: (value) {
                          sleepGoal = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      
                      _buildGoalSlider(
                        title: 'Digital Detox',
                        icon: Icons.phonelink_erase_rounded,
                        color: const Color(0xFF5E35B1), 
                        value: digitalDetoxGoal.toDouble(),
                        min: 30,
                        max: 240,
                        divisions: 7,
                        valueLabel: '${digitalDetoxGoal.toStringAsFixed(0)} mins',
                        onChanged: (value) {
                          digitalDetoxGoal = value.round();
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      
                      _buildGoalSlider(
                        title: 'Active Breaks',
                        icon: Icons.accessibility_new_rounded,
                        color: const Color(0xFF00897B), 
                        value: activeBreaksGoal.toDouble(),
                        min: 15,
                        max: 120,
                        divisions: 7,
                        valueLabel: '${activeBreaksGoal.toStringAsFixed(0)} mins',
                        onChanged: (value) {
                          activeBreaksGoal = value.round();
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey,
                            ),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              _resetToRecommendedGoals();
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.primaryColor,
                            ),
                            child: const Text('Reset'),
                          ),
                          TextButton(
                            onPressed: () {
                              _updateGoals(
                                stepsGoal, 
                                waterGoal, 
                                sleepGoal,
                                digitalDetoxGoal,
                                activeBreaksGoal,
                              );
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Future<void> _updateGoals(
    int stepsGoal, 
    int waterGoal, 
    double sleepGoal,
    int digitalDetoxGoal,
    int activeBreaksGoal,
  ) async {
    if (_userProfile == null) return;
    
    final updatedProfile = _userProfile!.copyWith(
      customStepsGoal: stepsGoal,
      customWaterGoal: waterGoal,
      customSleepGoal: sleepGoal,
      customDigitalDetoxGoal: digitalDetoxGoal,
      customActiveBreaksGoal: activeBreaksGoal,
    );
    
    await _userService.updateUserProfile(updatedProfile);
    
    setState(() {
      _userProfile = updatedProfile;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Health targets updated')),
      );
    }
  }
  
  Future<void> _resetToRecommendedGoals() async {
    if (_userProfile == null) return;
    
    final updatedProfile = _userProfile!.copyWith(
      customStepsGoal: null,
      customWaterGoal: null,
      customSleepGoal: null,
      customDigitalDetoxGoal: null,
      customActiveBreaksGoal: null,
    );
    
    await _userService.updateUserProfile(updatedProfile);
    
    setState(() {
      _userProfile = updatedProfile;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reset to recommended targets')),
      );
    }
  }
  
  Widget _buildGoalSlider({
    required String title,
    required IconData icon,
    required Color color,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String valueLabel,
    required ValueChanged<double> onChanged,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    valueLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: color,
                inactiveTrackColor: color.withOpacity(0.2),
                thumbColor: Colors.white,
                overlayColor: color.withOpacity(0.1),
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 8,
                  elevation: 4,
                ),
                trackHeight: 4,
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: (newValue) {
                  setState(() {
                    onChanged(newValue);
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildRecommendationItem({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required String description,
    required bool isCustom,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    if (isCustom) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Custom',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _getStepsRecommendationText() {
    final steps = _userProfile!.recommendedSteps;
    
    if (steps >= 10000) {
      return 'This target helps maintain cardiovascular health and manage weight effectively.';
    } else if (steps >= 8000) {
      return 'This moderate target is appropriate for your age and physical condition.';
    } else {
      return 'This is a good starting goal based on your profile. Gradually increase as you build stamina.';
    }
  }
  
  String _getWaterRecommendationText() {
    final glasses = _userProfile!.recommendedWaterIntake;
    final weightKg = _userProfile!.weightKg;
    
    return 'Based on your weight of ${weightKg.toStringAsFixed(1)} kg, aim for $glasses glasses (250ml each) of water daily for optimal hydration.';
  }
  
  String _getSleepRecommendationText() {
    final hours = _userProfile!.recommendedSleepHours;
    final age = _userProfile!.age;
    
    return 'For your age group ($age years), approximately $hours hours of quality sleep per night is recommended for optimal health.';
  }

  String _getDigitalDetoxRecommendationText() {
    final minutes = _userProfile!.digitalDetoxGoal;
    
    return 'Taking regular breaks from screens helps reduce eye strain and improve mental well-being. Aim for at least ${minutes} minutes of screen-free time daily.';
  }
  
  String _getActiveBreaksRecommendationText() {
    final minutes = _userProfile!.activeBreaksGoal;
    
    return 'Regular movement throughout the day helps counteract the negative effects of sitting. Try to get ${minutes} minutes of standing or light activity.';
  }

  Widget _buildInfoRow(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 