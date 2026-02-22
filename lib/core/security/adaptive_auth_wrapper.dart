import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

class AdaptiveAuthWrapper extends StatelessWidget {
  final Widget child;

  const AdaptiveAuthWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthReverificationRequired) {
          _showReverificationDialog(context, state.reason);
        }
      },
      child: child,
    );
  }

  void _showReverificationDialog(BuildContext context, String reason) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Row(
          children: [
            Icon(Icons.security, color: Colors.orange),
            SizedBox(width: 10),
            Text('Security Check', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Anomalous behavior detected: $reason',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 15),
            const Text(
              'To protect your account, please verify your identity again.',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // In a real app, this would navigate to a PIN/Biometric screen
              // For this demo, we'll just emit AuthCheckRequested to reset state
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(AuthCheckRequested());
            },
            child: const Text('VERIFY NOW',
                style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }
}
