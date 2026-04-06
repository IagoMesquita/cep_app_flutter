import 'package:cep_app/shared/ui/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

class CepButtonWidget extends StatelessWidget {
  final String label;
  // final void Function() onPressed;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;

  const CepButtonWidget({
    required this.label,
    this.onPressed,
    this.focusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      focusNode: focusNode,
      child: Text(
        label,
        style: context.getTextTheme.bodyMedium,
      ),
    );
  }
}
