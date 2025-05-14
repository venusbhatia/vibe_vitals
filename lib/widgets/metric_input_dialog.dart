import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:health_monitor/models/health_metric.dart';
import 'package:health_monitor/theme/app_theme.dart';

class MetricInputDialog extends StatefulWidget {
  final MetricType type;
  final String title;
  final String unit;

  const MetricInputDialog({
    super.key,
    required this.type,
    required this.title,
    required this.unit,
  });

  @override
  State<MetricInputDialog> createState() => _MetricInputDialogState();
}

class _MetricInputDialogState extends State<MetricInputDialog> with SingleTickerProviderStateMixin {
  final TextEditingController _valueController = TextEditingController();
  String? _errorText;
  double _value = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _valueController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _validateInput() {
    final value = _valueController.text;
    if (value.isEmpty) {
      setState(() {
        _errorText = 'Please enter a value';
      });
      return;
    }

    final numValue = double.tryParse(value);
    if (numValue == null) {
      setState(() {
        _errorText = 'Please enter a valid number';
      });
      return;
    }

    if (numValue <= 0) {
      setState(() {
        _errorText = 'Please enter a value greater than 0';
      });
      return;
    }

    setState(() {
      _errorText = null;
      _value = numValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildAppleStyleDialog();
  }

  Widget _buildAppleStyleDialog() {
    Color dialogColor = Colors.blue;
    switch (widget.type) {
      case MetricType.steps:
        dialogColor = AppTheme.primaryColor;
        break;
      case MetricType.heartRate:
        dialogColor = AppTheme.errorColor;
        break;
      case MetricType.water:
        dialogColor = AppTheme.secondaryColor;
        break;
      case MetricType.sleep:
        dialogColor = AppTheme.tertiaryColor;
        break;
      case MetricType.digitalDetox:
        dialogColor = const Color(0xFF5E35B1); 
        break;
      case MetricType.activeBreaks:
        dialogColor = const Color(0xFF00897B); 
        break;
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                          decoration: BoxDecoration(
                            color: dialogColor.withOpacity(0.1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: dialogColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _getIconForType(widget.type),
                                  color: dialogColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Add ${widget.title}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.8),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Enter your ${widget.title.toLowerCase()} value',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _errorText != null 
                                        ? AppTheme.errorColor.withOpacity(0.5)
                                        : Colors.transparent,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: TextField(
                                        controller: _valueController,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        decoration: InputDecoration(
                                          hintText: 'Enter value',
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                          hintStyle: TextStyle(
                                            color: Colors.black.withOpacity(0.3),
                                            fontSize: 16,
                                          ),
                                        ),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                        onChanged: (_) {
                                          _validateInput();
                                        },
                                        autofocus: true,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      margin: const EdgeInsets.only(right: 4),
                                      decoration: BoxDecoration(
                                        color: dialogColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        widget.unit,
                                        style: TextStyle(
                                          color: dialogColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              
                              if (_errorText != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8, left: 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.exclamationmark_circle,
                                        color: AppTheme.errorColor,
                                        size: 12,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _errorText!,
                                        style: TextStyle(
                                          color: AppTheme.errorColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              
                              const SizedBox(height: 24),
                              
                              
                              Row(
                                children: [
                                  
                                  Expanded(
                                    child: Container(
                                      height: 44,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            color: dialogColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  
                                  Expanded(
                                    child: Container(
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: dialogColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: dialogColor.withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          _validateInput();
                                          if (_errorText == null) {
                                            Navigator.of(context).pop(double.parse(_valueController.text));
                                          }
                                        },
                                        child: const Text(
                                          'Save',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getIconForType(MetricType type) {
    switch (type) {
      case MetricType.steps:
        return Icons.directions_walk_rounded;
      case MetricType.heartRate:
        return CupertinoIcons.heart_fill;
      case MetricType.water:
        return CupertinoIcons.drop_fill;
      case MetricType.sleep:
        return CupertinoIcons.moon_fill;
      case MetricType.digitalDetox:
        return Icons.phonelink_erase_rounded;
      case MetricType.activeBreaks:
        return Icons.accessibility_new_rounded;
    }
  }
} 