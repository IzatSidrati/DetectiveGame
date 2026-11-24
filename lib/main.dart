import 'package:flutter/material.dart';
import 'screens/home_shell.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = AppStateController();
  await controller.load();
  runApp(MindCaseApp(controller: controller));
}

class MindCaseApp extends StatelessWidget {
  final AppStateController controller;

  const MindCaseApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindCase',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(),
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        return LayoutBuilder(
          builder: (context, constraints) {
            // On mobile widths, render full-bleed. On wide desktop/web screens,
            // keep a clean centered mobile-proportioned frame so illustrations look crisp.
            if (constraints.maxWidth <= 540) {
              return child;
            }
            return ColoredBox(
              color: const Color(0xFF070A0F),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      vertical: BorderSide(
                        color: AppColors.border.withOpacity(0.6),
                        width: 1,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.45),
                        blurRadius: 28,
                      ),
                    ],
                  ),
                  child: ClipRect(child: child),
                ),
              ),
            );
          },
        );
      },
      home: HomeShell(controller: controller),
    );
  }
}
