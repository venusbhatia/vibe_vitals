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

  
  int get age {
    final today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month || 
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  
  double get bmi {
    
    final heightInMeters = heightCm / 100;
    return weightKg / (heightInMeters * heightInMeters);
  }

  
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
  
  
  int get recommendedWaterIntake {
    
    double waterInMl = weightKg * 30;
    
    
    waterInMl += 500;
    
    
    if (age > 65) {
      waterInMl *= 0.9;
    }
    
    
    int glasses = (waterInMl / 250).round();
    
    
    return glasses.clamp(6, 12);
  }
  
  
  double get recommendedSleepHours {
    
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
  
  
  int get recommendedSteps {
    
    int baseSteps = 10000;
    
    
    if (age < 18) {
      baseSteps = 12000; 
    } else if (age > 65) {
      baseSteps = 8000; 
    }
    
    
    if (bmi > 30) {
      
      baseSteps = (baseSteps * 0.8).round();
    } else if (bmi < 18.5) {
      
      baseSteps = (baseSteps * 0.9).round();
    }
    
    
    return (baseSteps / 500).round() * 500;
  }
  
  
  int get recommendedDigitalDetox {
    
    int baseMinutes = 120;
    
    
    if (age < 18) {
      baseMinutes = 180; 
    } else if (age > 65) {
      baseMinutes = 150; 
    }
    
    
    
    if (gender == Gender.male || gender == Gender.female) {
      
    } else {
      
      baseMinutes = (baseMinutes * 0.9).round();
    }
    
    
    return (baseMinutes / 30).round() * 30;
  }
  
  
  int get recommendedActiveBreaks {
    
    int baseMinutes = 60;
    
    
    if (age < 18) {
      baseMinutes = 90; 
    } else if (age > 65) {
      baseMinutes = 75; 
    }
    
    
    if (bmi > 30) {
      
      baseMinutes = (baseMinutes * 1.2).round();
    } else if (bmi < 18.5) {
      
      baseMinutes = baseMinutes;
    }
    
    
    return (baseMinutes / 5).round() * 5;
  }
  
  
  int get stepsGoal => customStepsGoal ?? recommendedSteps;
  
  
  int get waterGoal => customWaterGoal ?? recommendedWaterIntake;
  
  
  double get sleepGoal => customSleepGoal ?? recommendedSleepHours;
  
  
  int get digitalDetoxGoal => customDigitalDetoxGoal ?? recommendedDigitalDetox;
  
  
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