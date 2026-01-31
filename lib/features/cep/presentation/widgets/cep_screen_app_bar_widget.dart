import 'package:cep_app/shared/ui/theme/domain/providers/theme_notifier.dart';
import 'package:cep_app/shared/ui/theme/domain/providers/theme_notifier_provider.dart';
import 'package:cep_app/shared/ui/theme/domain/providers/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CepScreenAppBarWidget extends ConsumerStatefulWidget {
  final String title;
  final List<Widget> tabs;

  const CepScreenAppBarWidget({
    required this.title,
    required this.tabs,
    super.key,
  });

  @override
  ConsumerState<CepScreenAppBarWidget> createState() =>
      _CepScreenAppBarWidgetState();
}

class _CepScreenAppBarWidgetState extends ConsumerState<CepScreenAppBarWidget> {
  @override
  void initState() {
    ref.read<ThemeNotifier>(themeNotifierProvider.notifier).initThemeState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch<ThemeState>(themeNotifierProvider);
    final themeNotifier = ref.watch<ThemeNotifier>(themeNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Switch.adaptive(
            value: themeState.getTheme == ThemeMode.dark,
            onChanged: (_) {
              themeNotifier.changeTheme(context);
            },
          ),
        ],
      ),
    );
  }
}
