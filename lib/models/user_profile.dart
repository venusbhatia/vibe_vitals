import 'package:flutter/material.dart';

enum Gender { male, female, other, preferNotToSay }

class UserProfile {
  final String name;
  final DateTime dateOfBirth;
  final Gender gender;
  final double heightCm;
  final double weightKg;
  final int? customStepsGoal;
  final int? customWaterGoal;
  final double? customSleepGoal;
  final int? customDigitalDetoxGoal;
  final int? customActiveBreaksGoal;

  UserProfile({
    this.name = '',
    required this.dateOfBirth,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    this.customStepsGoal,
    this.customWaterGoal,
    this.customSleepGoal,
    this.customDigitalDetoxGoal,
    this.customActiveBreaksGoal,
  });

  // Calculate age based on date of birth
  int get age {
    final today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month || 
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  // Calculate BMI
  double get bmi {
    // BMI = weight(kg) / height(m)²
    final heightInMeters = heightCm / 100;
    return weightKg / (heightInMeters * heightInMeters);
  }

  // Convert gender enum to string
  String get genderString {
    switch (gender) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
      case Gender.preferNotToSay:
        return 'Prefer not to say';
    }
  }
  
  // Calculate recommended daily water intake in glasses (1 glass = 250ml)
  int get recommendedWaterIntake {
    // Base recommendation on weight (30ml per kg)
    double waterInMl = weightKg * 30;
    
    // Adjust for activity level (assuming moderate)
    waterInMl += 500;
    
    // Adjust for age - older adults might need slightly less
    if (age > 65) {
      waterInMl *= 0.9;
    }
    
    // Convert to glasses (250ml per glass)
    int glasses = (waterInMl / 250).round();
    
    // Cap between 6-12 glasses for reasonable recommendation
    return glasses.clamp(6, 12);
  }
  
  // Calculate recommended sleep in hours
  double get recommendedSleepHours {
    // Base sleep recommendation by age
    double baseHours;
    
    if (age <= 1) {
      baseHours = 14;
    } else if (age <= 3) {
      baseHours = 12;
    } else if (age <= 5) {
      baseHours = 11;
    } else if (age <= 13) {
      baseHours = 10;
    } else if (age <= 17) {
      baseHours = 9;
    } else if (age <= 25) {
      baseHours = 8;
    } else if (age <= 64) {
      baseHours = 7.5;
    } else {
      baseHours = 7;
    }
    
    return baseHours;
  }
  
  // Calculate recommended daily steps
  int get recommendedSteps {
    // Base recommendation
    int baseSteps = 10000;
    
    // Adjust for age
    if (age < 18) {
      baseSteps = 12000; // Children and teens should move more
    } else if (age > 65) {
      baseSteps = 8000; // Slightly lower for seniors
    }
    
    // Adjust for BMI
    if (bmi > 30) {
      // For those with obesity, start with a more achievable goal
      baseSteps = (baseSteps * 0.8).round();
    } else if (bmi < 18.5) {
      // For underweight individuals, moderate activity
      baseSteps = (baseSteps * 0.9).round();
    }
    
    // Round to nearest 500
    return (baseSteps / 500).round() * 500;
  }
  
  // Calculate recommended daily digital detox time (minutes)
  int get recommendedDigitalDetox {
    // Base recommendation - 120 minutes (2 hours) of screen-free time daily
    int baseMinutes = 120;
    
    // Adjust for age
    if (age < 18) {
      baseMinutes = 180; // More detox time for youth
    } else if (age > 65) {
      baseMinutes = 150; // Slightly more for seniors for eye health
    }
    
    // Adjust based on occupation (approximated by gender as a proxy)
    // This is a simplification; ideally would be based on occupation data
    if (gender == Gender.male || gender == Gender.female) {
      // No adjustment needed, using average
    } else {
      // Slight adjustment for other or prefer not to say
      baseMinutes = (baseMinutes * 0.9).round();
    }
    
    // Round to nearest 30 minutes
    return (baseMinutes / 30).round() * 30;
  }
  
  // Calculate recommended active breaks time (minutes per day)
  int get recommendedActiveBreaks {
    // Base recommendation - 60 minutes of standing/movement breaks per day
    int baseMinutes = 60;
    
    // Adjust for age
    if (age < 18) {
      baseMinutes = 90; // More active time for youth
    } else if (age > 65) {
      baseMinutes = 75; // More breaks for seniors, but not as intense
    }
    
    // Adjust for BMI
    if (bmi > 30) {
      // For those with obesity, start with slightly higher goal
      baseMinutes = (baseMinutes * 1.2).round();
    } else if (bmi < 18.5) {
      // For underweight individuals, standard goal
      baseMinutes = baseMinutes;
    }
    
    // Round to nearest 5 minutes
    return (baseMinutes / 5).round() * 5;
  }
  
  // Get actual steps goal (custom if set, otherwise recommended)
  int get stepsGoal => customStepsGoal ?? recommendedSteps;
  
  // Get actual water goal (custom if set, otherwise recommended)
  int get waterGoal => customWaterGoal ?? recommendedWaterIntake;
  
  // Get actual sleep goal (custom if set, otherwise recommended)
  double get sleepGoal => customSleepGoal ?? recommendedSleepHours;
  
  // Get actual digital detox goal (custom if set, otherwise recommended)
  int get digitalDetoxGoal => customDigitalDetoxGoal ?? recommendedDigitalDetox;
  
  // Get actual active breaks goal (custom if set, otherwise recommended)
  int get activeBreaksGoal => customActiveBreaksGoal ?? recommendedActiveBreaks;

  UserProfile copyWith({
    String? name,
    DateTime? dateOfBirth,
    Gender? gender,
    double? heightCm,
    double? weightKg,
    int? customStepsGoal,
    int? customWaterGoal,
    double? customSleepGoal,
    int? customDigitalDetoxGoal,
    int? customActiveBreaksGoal,
  }) {
    return UserProfile(
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      customStepsGoal: customStepsGoal ?? this.customStepsGoal,
      customWaterGoal: customWaterGoal ?? this.customWaterGoal,
      customSleepGoal: customSleepGoal ?? this.customSleepGoal,
      customDigitalDetoxGoal: customDigitalDetoxGoal ?? this.customDigitalDetoxGoal,
      customActiveBreaksGoal: customActiveBreaksGoal ?? this.customActiveBreaksGoal,
    );
  }
} 