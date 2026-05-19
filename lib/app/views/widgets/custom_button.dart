import 'package:crio_app/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final double? borderRadius;
  final double? elevation;
  final double? fontSize;
  final IconData? icon;
  final FontWeight? fontWeight;
  final double? width;
  final double? height;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.textColor,
    this.borderRadius,
    this.elevation,
    this.fontSize,
    this.icon,
    this.width,
    this.height,
    this.fontWeight,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    return SizedBox(
      width: width ?? w * 0.3,
      height: height ?? h * 0.06,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: .zero,
          backgroundColor: color ?? Theme.of(context).primaryColor,
          foregroundColor: textColor ?? AppTheme.primaryText,
          elevation: elevation ?? 3,
          shape: RoundedRectangleBorder(
            borderRadius: .circular(borderRadius ?? w * 0.015),
          ),
        ),
        child: Row(
          mainAxisSize: .min,
          mainAxisAlignment: .center,
          children: [
            if (isLoading)
              CustomCircularIndicator(
                size: (height ?? h * 0.06) * 0.45,
                color: textColor ?? AppTheme.primaryText,
                strokeWidth: 2.5,
              )
            else ...[
              if (icon != null) ...[
                Icon(icon, size: (fontSize ?? w * 0.035) + 2),
                SizedBox(width: w * 0.02),
              ],
              Text(
                text,
                style: GoogleFonts.outfit(
                  fontSize: fontSize ?? w * 0.035,
                  fontWeight: fontWeight ?? .w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CustomCircularIndicator extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const CustomCircularIndicator({
    super.key,
    required this.size,
    required this.color,
    this.strokeWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(color: color, strokeWidth: strokeWidth),
    );
  }
}
