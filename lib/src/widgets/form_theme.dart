import 'package:flutter/material.dart';

/// A class to define the theme for the dynamic form
class PostgresFormTheme {
  /// Primary color used for buttons and accents
  final Color primaryColor;

  /// Background color for the form
  final Color backgroundColor;

  /// Text color for labels
  final Color labelColor;

  /// Text color for input fields
  final Color inputTextColor;

  /// Error color for validation messages
  final Color errorColor;

  /// Border color for input fields
  final Color borderColor;

  /// Border color for focused input fields
  final Color focusedBorderColor;

  /// Border radius for input fields
  final double borderRadius;

  /// Padding for form fields
  final EdgeInsets fieldPadding;

  /// Spacing between form fields
  final double fieldSpacing;

  /// Text style for field labels
  final TextStyle? labelStyle;

  /// Text style for input text
  final TextStyle? inputTextStyle;

  /// Text style for helper text
  final TextStyle? helperStyle;

  /// Text style for error messages
  final TextStyle? errorStyle;

  /// Button style for the submit button
  final ButtonStyle? submitButtonStyle;

  /// Text style for the submit button
  final TextStyle? submitButtonTextStyle;

  /// Icon theme for the form
  final IconThemeData? iconTheme;

  /// Whether to use outlined input decoration
  final bool useOutlinedBorder;

  /// Whether to use filled input decoration
  final bool useFilled;

  /// Fill color for input fields when useFilled is true
  final Color? fillColor;

  const PostgresFormTheme({
    this.primaryColor = const Color(0xFF6200EE),
    this.backgroundColor = Colors.white,
    this.labelColor = const Color(0xFF424242),
    this.inputTextColor = const Color(0xFF212121),
    this.errorColor = Colors.red,
    this.borderColor = const Color(0xFFBDBDBD),
    this.focusedBorderColor = const Color(0xFF6200EE),
    this.borderRadius = 8.0,
    this.fieldPadding = const EdgeInsets.symmetric(vertical: 8.0),
    this.fieldSpacing = 24.0,
    this.labelStyle,
    this.inputTextStyle,
    this.helperStyle,
    this.errorStyle,
    this.submitButtonStyle,
    this.submitButtonTextStyle,
    this.iconTheme,
    this.useOutlinedBorder = true,
    this.useFilled = true,
    this.fillColor,
  });

  /// Light theme preset
  factory PostgresFormTheme.light() {
    return const PostgresFormTheme(
      primaryColor: Color(0xFF6200EE),
      backgroundColor: Colors.white,
      labelColor: Color(0xFF424242),
      inputTextColor: Color(0xFF212121),
      errorColor: Colors.red,
      borderColor: Color(0xFFBDBDBD),
      focusedBorderColor: Color(0xFF6200EE),
      useFilled: true,
      fillColor: Color(0xFFF5F5F5),
    );
  }

  /// Dark theme preset
  factory PostgresFormTheme.dark() {
    return const PostgresFormTheme(
      primaryColor: Color(0xFFBB86FC),
      backgroundColor: Color(0xFF121212),
      labelColor: Color(0xFFE0E0E0),
      inputTextColor: Colors.white,
      errorColor: Color(0xFFCF6679),
      borderColor: Color(0xFF424242),
      focusedBorderColor: Color(0xFFBB86FC),
      useFilled: true,
      fillColor: Color(0xFF2A2A2A),
    );
  }

  /// Material 3 inspired theme
  factory PostgresFormTheme.material3() {
    return PostgresFormTheme(
      primaryColor: const Color(0xFF6750A4),
      backgroundColor: Colors.white,
      labelColor: const Color(0xFF49454F),
      inputTextColor: const Color(0xFF1C1B1F),
      errorColor: const Color(0xFFB3261E),
      borderColor: const Color(0xFF79747E),
      focusedBorderColor: const Color(0xFF6750A4),
      borderRadius: 4.0,
      useFilled: false,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      inputTextStyle: const TextStyle(
        fontSize: 16,
      ),
      submitButtonStyle: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  /// Creates an InputDecoration based on this theme
  InputDecoration createInputDecoration({
    required String labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? helperText,
    String? errorText,
  }) {
    final border = useOutlinedBorder
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: borderColor),
          )
        : UnderlineInputBorder(
            borderSide: BorderSide(color: borderColor),
          );

    final focusedBorder = useOutlinedBorder
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: focusedBorderColor, width: 2.0),
          )
        : UnderlineInputBorder(
            borderSide: BorderSide(color: focusedBorderColor, width: 2.0),
          );

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      helperText: helperText,
      errorText: errorText,
      labelStyle: labelStyle?.copyWith(color: labelColor) ??
          TextStyle(color: labelColor),
      hintStyle: inputTextStyle?.copyWith(color: labelColor.withOpacity(0.6)) ??
          TextStyle(color: labelColor.withOpacity(0.6)),
      helperStyle: helperStyle ??
          TextStyle(
            color: labelColor.withOpacity(0.7),
            fontSize: 12,
          ),
      errorStyle: errorStyle ??
          TextStyle(
            color: errorColor,
            fontSize: 12,
          ),
      filled: useFilled,
      fillColor: fillColor ?? backgroundColor.withOpacity(0.05),
      border: border,
      enabledBorder: border,
      focusedBorder: focusedBorder,
      errorBorder: useOutlinedBorder
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: errorColor),
            )
          : UnderlineInputBorder(
              borderSide: BorderSide(color: errorColor),
            ),
      focusedErrorBorder: useOutlinedBorder
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: errorColor, width: 2.0),
            )
          : UnderlineInputBorder(
              borderSide: BorderSide(color: errorColor, width: 2.0),
            ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: useOutlinedBorder ? 16 : 8,
      ),
    );
  }

  /// Creates a ButtonStyle for the submit button based on this theme
  ButtonStyle getSubmitButtonStyle() {
    return submitButtonStyle ??
        ButtonStyle(
          backgroundColor: WidgetStateProperty.all(primaryColor),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        );
  }

  /// Creates a copy of this theme with the given fields replaced
  PostgresFormTheme copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    Color? labelColor,
    Color? inputTextColor,
    Color? errorColor,
    Color? borderColor,
    Color? focusedBorderColor,
    double? borderRadius,
    EdgeInsets? fieldPadding,
    double? fieldSpacing,
    TextStyle? labelStyle,
    TextStyle? inputTextStyle,
    TextStyle? helperStyle,
    TextStyle? errorStyle,
    ButtonStyle? submitButtonStyle,
    TextStyle? submitButtonTextStyle,
    IconThemeData? iconTheme,
    bool? useOutlinedBorder,
    bool? useFilled,
    Color? fillColor,
  }) {
    return PostgresFormTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      labelColor: labelColor ?? this.labelColor,
      inputTextColor: inputTextColor ?? this.inputTextColor,
      errorColor: errorColor ?? this.errorColor,
      borderColor: borderColor ?? this.borderColor,
      focusedBorderColor: focusedBorderColor ?? this.focusedBorderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      fieldPadding: fieldPadding ?? this.fieldPadding,
      fieldSpacing: fieldSpacing ?? this.fieldSpacing,
      labelStyle: labelStyle ?? this.labelStyle,
      inputTextStyle: inputTextStyle ?? this.inputTextStyle,
      helperStyle: helperStyle ?? this.helperStyle,
      errorStyle: errorStyle ?? this.errorStyle,
      submitButtonStyle: submitButtonStyle ?? this.submitButtonStyle,
      submitButtonTextStyle:
          submitButtonTextStyle ?? this.submitButtonTextStyle,
      iconTheme: iconTheme ?? this.iconTheme,
      useOutlinedBorder: useOutlinedBorder ?? this.useOutlinedBorder,
      useFilled: useFilled ?? this.useFilled,
      fillColor: fillColor ?? this.fillColor,
    );
  }
}
