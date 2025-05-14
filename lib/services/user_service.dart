import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_monitor/models/user_profile.dart';

class UserService {
  static const String _userProfileKey = 'user_profile';
  static const String _hasCompletedOnboardingKey = 'has_completed_onboarding';

  
  Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final profileMap = {
      'name': profile.name,
      'dateOfBirth': profile.dateOfBirth.toIso8601String(),
      'gender': profile.gender.index,
      'heightCm': profile.heightCm,
      'weightKg': profile.weightKg,
      'customStepsGoal': profile.customStepsGoal,
      'customWaterGoal': profile.customWaterGoal,
      'customSleepGoal': profile.customSleepGoal,
      'customDigitalDetoxGoal': profile.customDigitalDetoxGoal,
      'customActiveBreaksGoal': profile.customActiveBreaksGoal,
    };
    await prefs.setString(_userProfileKey, jsonEncode(profileMap));
    await prefs.setBool(_hasCompletedOnboardingKey, true);
  }

  
  Future<UserProfile?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileString = prefs.getString(_userProfileKey);
    
    if (profileString == null) {
      return null;
    }
    
    try {
      final profileMap = jsonDecode(profileString) as Map<String, dynamic>;
      return UserProfile(
        name: profileMap['name'] as String,
        dateOfBirth: DateTime.parse(profileMap['dateOfBirth'] as String),
        gender: Gender.values[profileMap['gender'] as int],
        heightCm: profileMap['heightCm'] as double,
        weightKg: profileMap['weightKg'] as double,
        customStepsGoal: profileMap['customStepsGoal'] != null ? profileMap['customStepsGoal'] as int : null,
        customWaterGoal: profileMap['customWaterGoal'] != null ? profileMap['customWaterGoal'] as int : null,
        customSleepGoal: profileMap['customSleepGoal'] != null ? profileMap['customSleepGoal'] as double : null,
        customDigitalDetoxGoal: profileMap['customDigitalDetoxGoal'] != null ? profileMap['customDigitalDetoxGoal'] as int : null,
        customActiveBreaksGoal: profileMap['customActiveBreaksGoal'] != null ? profileMap['customActiveBreaksGoal'] as int : null,
      );
    } catch (e) {
      return null;
    }
  }

  
  Future<void> updateUserProfile(UserProfile profile) async {
    await saveUserProfile(profile);
  }

  
  Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasCompletedOnboardingKey) ?? false;
  }

  
  Future<void> resetOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasCompletedOnboardingKey, false);
  }
} 