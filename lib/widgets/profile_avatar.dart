import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:health_monitor/theme/app_theme.dart';
import 'package:health_monitor/models/user_profile.dart';

class ProfileAvatar extends StatefulWidget {
  final UserProfile? userProfile;
  final double size;
  final VoidCallback? onTap;

  const ProfileAvatar({
    Key? key,
    required this.userProfile,
    this.size = 40.0,
    this.onTap,
  }) : super(key: key);

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String get _getInitials {
    if (widget.userProfile == null || widget.userProfile!.name.isEmpty) {
      return 'U';
    }
    
    final nameParts = widget.userProfile!.name.trim().split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else {
      return nameParts[0][0].toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => widget.onTap != null ? _animationController.forward() : null,
      onTapUp: (_) => widget.onTap != null ? _animationController.reverse() : null,
      onTapCancel: () => widget.onTap != null ? _animationController.reverse() : null,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF333333),
                    Color(0xFF111111),
                  ],
                ),
                boxShadow: [
                  
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: widget.size * 0.2,
                    offset: const Offset(0, 3),
                    spreadRadius: 1,
                  ),
                  
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: widget.size * 0.1,
                    offset: const Offset(0, -1),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      _getInitials,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: widget.size * 0.4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 