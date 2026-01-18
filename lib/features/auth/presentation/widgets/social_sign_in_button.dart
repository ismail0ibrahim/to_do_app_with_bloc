// =====================================
// Social Sign In Button - زر التوقيع الاجتماعي
// =====================================

import 'package:flutter/material.dart';

/// زر مخصص للتوقيع عبر وسائل التواصل
class SocialSignInButton extends StatelessWidget {
  final String label; // نص الزر
  final IconData icon; // الأيقونة
  final Color backgroundColor; // اللون الخلفي
  final VoidCallback onPressed; // الدالة عند الضغط
  final bool isLoading; // هل الزر محمّل؟

  const SocialSignInButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        // بنعطل الزر لو بنحمل
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: backgroundColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

/// Divider مع نص في الوسط
class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.grey, height: 24)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ),
        const Expanded(child: Divider(color: Colors.grey, height: 24)),
      ],
    );
  }
}
