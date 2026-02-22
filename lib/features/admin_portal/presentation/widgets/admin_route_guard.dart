import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminRouteGuard extends StatefulWidget {
  final Widget child;
  const AdminRouteGuard({super.key, required this.child});

  @override
  State<AdminRouteGuard> createState() => _AdminRouteGuardState();
}

class _AdminRouteGuardState extends State<AdminRouteGuard> {
  bool _isAuthorized = false;
  bool _isVerifying2FA = false;
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    // 1. JWT Simulation: In a real app, check AuthBloc/TokenStorage for ROLE_SUPER_ADMIN
    // 2. IP Whitelist Simulation: Check if current IP matches whitelisted set

    // Simulate a delay for security check
    await Future.delayed(const Duration(milliseconds: 800));

    // For demo purposes, we automatically trigger 2FA if they reach this guard
    setState(() {
      _isVerifying2FA = true;
    });
  }

  void _verifyOTP() {
    if (_otpController.text == '123456') {
      // Mock OTP
      setState(() {
        _isVerifying2FA = false;
        _isAuthorized = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('INVALID SECURITY TOKEN')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthorized) {
      return widget.child;
    }

    if (_isVerifying2FA) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.security_rounded,
                    color: Colors.blueAccent, size: 48),
                const SizedBox(height: 24),
                Text(
                  'Two-Factor Authentication',
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter the 6-digit code from your authenticator app to access the Super Admin Portal.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white38,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 20,
                  ),
                  decoration: InputDecoration(
                    hintText: '000000',
                    hintStyle:
                        TextStyle(color: Colors.white.withValues(alpha: 0.05)),
                    border: InputBorder.none,
                  ),
                  maxLength: 6,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _verifyOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'VERIFY IDENTITY',
                      style: TextStyle(
                          fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('ABORT SESSION',
                      style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const Scaffold(
      backgroundColor: Color(0xFF0F172A),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
