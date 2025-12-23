import 'package:flutter/material.dart';

class BWSSBLogo extends StatelessWidget {
  final double size;
  final String? imagePath;
  final Color? fallbackColor;
  final double? iconSize;
  final bool showBorder;
  final Color borderColor;

  const BWSSBLogo({
    Key? key,
    this.size = 60,
    this.imagePath,
    this.fallbackColor,
    this.iconSize,
    this.showBorder = false,
    this.borderColor = Colors.yellow,
  }) : super(key: key);

  const BWSSBLogo.splash({
    Key? key,
    this.size = 180,
    this.showBorder = false,
    this.borderColor = Colors.yellow,
  }) : imagePath = 'assets/images/splashlogo.png',
       fallbackColor = const Color(0xFF2196F3),
       iconSize = 80;

  const BWSSBLogo.dashboard({
    Key? key,
    this.size = 60,
    this.showBorder = true,
    this.borderColor = Colors.yellow,
  }) : imagePath = 'assets/images/bwssblogodash.png',
       fallbackColor = const Color(0xFF87CEEB),
       iconSize = 28;

  const BWSSBLogo.login({
    Key? key,
    this.size = 50,
    this.showBorder = false,
    this.borderColor = Colors.yellow,
  }) : imagePath = 'assets/images/bwssblogonew.png',
       fallbackColor = const Color(0xFF2196F3),
       iconSize = 28;

  const BWSSBLogo.menu({
    Key? key,
    this.size = 40,
    this.showBorder = false,
    this.borderColor = Colors.yellow,
  }) : imagePath = 'assets/images/menulogo.png',
       fallbackColor = const Color(0xFF2196F3),
       iconSize = 20;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: showBorder ? Border.all(color: borderColor, width: 3) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: imagePath != null
            ? Image.asset(
                imagePath!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallback();
                },
              )
            : _buildFallback(),
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fallbackColor ?? const Color(0xFF2196F3),
      ),
      child: Icon(
        Icons.water_drop,
        color: Colors.white,
        size: iconSize ?? size * 0.4,
      ),
    );
  }
}

class BWSSBIconButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final IconData fallbackIcon;

  const BWSSBIconButton({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.onPressed,
    this.color = const Color(0xFF2196F3),
    this.fallbackIcon = Icons.dashboard,
  }) : super(key: key);

  const BWSSBIconButton.dashboard({
    Key? key,
    required this.label,
    required this.onPressed,
    this.color = const Color(0xFF4CAF50),
  }) : imagePath = 'assets/images/dashboard.png',
       fallbackIcon = Icons.dashboard;

  const BWSSBIconButton.serviceStation({
    Key? key,
    required this.label,
    required this.onPressed,
    this.color = const Color(0xFF2196F3),
  }) : imagePath = 'assets/images/servicestation.png',
       fallbackIcon = Icons.location_on;

  const BWSSBIconButton.waterQuality({
    Key? key,
    required this.label,
    required this.onPressed,
    this.color = const Color(0xFFFF5722),
  }) : imagePath = 'assets/images/wqs.png',
       fallbackIcon = Icons.warning;

  const BWSSBIconButton.supply({
    Key? key,
    required this.label,
    required this.onPressed,
    this.color = const Color(0xFF2196F3),
  }) : imagePath = 'assets/images/supply.png',
       fallbackIcon = Icons.water;

  const BWSSBIconButton.wtp({
    Key? key,
    required this.label,
    required this.onPressed,
    this.color = const Color(0xFF4CAF50),
  }) : imagePath = 'assets/images/wtp.png',
       fallbackIcon = Icons.business;

  const BWSSBIconButton.stp({
    Key? key,
    required this.label,
    required this.onPressed,
    this.color = const Color(0xFF9C27B0),
  }) : imagePath = 'assets/images/stp.png',
       fallbackIcon = Icons.cleaning_services;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  color: Colors.white,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      fallbackIcon,
                      color: Colors.white,
                      size: 24,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}