// =====================================
// Custom Text Field - حقل نص مخصص
// =====================================

import 'package:flutter/material.dart';

/// Custom Text Field بيعطينا تحكم أفضل بشكل الحقول
/// نستخدمه في كل الـ form fields علشان يكونوا موحدين
class CustomTextField extends StatefulWidget {
  final TextEditingController controller; // Controller للتحكم بالنص
  final String label; // عنوان الحقل
  final String hint; // نص المساعدة
  final IconData prefixIcon; // الأيقونة على اليسار
  final bool isPassword; // هل هذا حقل كلمة سر؟
  final String? Function(String?)? validator; // دالة التحقق من البيانات

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.validator,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // متغير بنستخدمه بـ إظهار وإخفاء كلمة السر
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    // في البداية، نخفي النص لو كان password field
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان الحقل
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            widget.label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),

        // حقل الإدخال نفسه
        TextFormField(
          controller: widget.controller,
          // بننسخ القيمة المدخلة (trim) علشان نشيل المسافات الفارغة
          obscureText: _obscureText,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            prefixIcon: Icon(widget.prefixIcon, color: Colors.grey[600]),
            // لو كان password field، نظهر زر يخفي/يظهر كلمة السر
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey[600],
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
