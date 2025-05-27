import 'package:flutter/material.dart';

class CustomTextField{

  static Widget authformfield({
    prefixIcon,
    controller,
    keyboardType,
    hintText,
    suffix,
    enabled,
    onchange,
    validator,
    bool isPassword = false, // Password field ka flag
    bool readOnly = false,
  }) {
    ValueNotifier<bool> obscureText = ValueNotifier<bool>(isPassword); // Password visibility ke liye notifier

    return ValueListenableBuilder<bool>(
      valueListenable: obscureText,
      builder: (context, value, child) {
        return TextFormField(

          enabled: enabled,
          validator: validator,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: value, // ValueNotifier ka value yahan use ho raha hai
          readOnly: readOnly,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            // filled: true,
            contentPadding: EdgeInsets.zero,
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                value ? Icons.visibility_off : Icons.visibility, // Toggle icon
                color: Colors.grey, // Customize icon color
              ),
              onPressed: () {
                obscureText.value = !value; // Obscure text toggle
              },
            )
                : suffix,
            labelStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.teal, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(color: Colors.black26, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
          ),
          onChanged: onchange,
        );
      },
    );
  }
}