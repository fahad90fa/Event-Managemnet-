import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/localization/language_bloc.dart';
import '../../../../core/config/localization/translator.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/phone_input_field.dart';
import '../widgets/otp_input_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _showOtp = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, lang) {
        final language = lang.language;
        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthOtpSent) {
                setState(() {
                  _showOtp = true;
                  _otpController.text = state.otp ?? "";
                });
              } else if (state is AuthAuthenticated) {
                Future.delayed(const Duration(milliseconds: 1200), () {
                  if (context.mounted) {
                    if (_phoneController.text == "03000047478") {
                      context.go('/admin/dashboard');
                    } else {
                      context.go('/home');
                    }
                  }
                });
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              final isSuccess = state is AuthAuthenticated;

              return Stack(
                children: [
                  // Premium Animated Background
                  const _PremiumBackground(),

                  // Main Content
                  SafeArea(
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Logo & Brand
                              _buildBrandSection(language),

                              const SizedBox(height: 60),

                              // Glass Card
                              _buildGlassCard(
                                context,
                                language,
                                isLoading,
                                isSuccess,
                              ),

                              const SizedBox(height: 32),

                              // Footer
                              _buildFooter(language),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Back Button (if OTP)
                  if (_showOtp)
                    Positioned(
                      top: 50,
                      left: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 20),
                          onPressed: () {
                            setState(() => _showOtp = false);
                          },
                        ),
                      ).animate().fadeIn().scale(),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBrandSection(AppLanguage language) {
    return Column(
      children: [
        // Premium Logo
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.heroGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDeep.withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 5,
              )
            ],
          ),
          child: Image.asset(
            'assets/images/logo.png',
            width: 48,
            height: 48,
          ),
        )
            .animate()
            .scale(delay: 200.ms, duration: 800.ms, curve: Curves.elasticOut),

        const SizedBox(height: 24),

        // App Name
        Text(
          "BookMyEvent",
          style: GoogleFonts.playfairDisplay(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),

        const SizedBox(height: 8),

        // Tagline
        Text(
          "login_tagline".tr(language),
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white60,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }

  Widget _buildGlassCard(
    BuildContext context,
    AppLanguage language,
    bool isLoading,
    bool isSuccess,
  ) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 440),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Text(
                  _showOtp
                      ? "verify_number".tr(language)
                      : "welcome_back".tr(language),
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 500.ms),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  _showOtp
                      ? "${"otp_sent_to".tr(language)} ${_phoneController.text}"
                      : "login_subtitle".tr(language),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 40),

                // Input Fields
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.2, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: _showOtp
                      ? Column(
                          key: const ValueKey('OTP'),
                          children: [
                            OtpInputField(
                              controller: _otpController,
                              length: 6,
                            ),
                            SizedBox(
                              height: 0,
                              width: 0,
                              child: TextField(
                                controller: _otpController,
                                autofocus: true,
                                keyboardType: TextInputType.number,
                                onChanged: (val) {
                                  setState(() {});
                                  if (val.length == 6) {
                                    context.read<AuthBloc>().add(
                                        AuthVerifyOtpRequested(
                                            _phoneController.text, val));
                                  }
                                },
                              ),
                            ),
                          ],
                        )
                      : PhoneInputField(
                          key: const ValueKey('Phone'),
                          controller: _phoneController,
                        ),
                ),

                const SizedBox(height: 32),

                // Action Button
                _buildPremiumButton(context, isLoading, isSuccess),

                if (_showOtp) ...[
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      context
                          .read<AuthBloc>()
                          .add(AuthSendOtpRequested(_phoneController.text));
                    },
                    child: Text(
                      "resend_code".tr(language),
                      style: GoogleFonts.inter(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ).animate().slideY(
        begin: 0.3, end: 0, duration: 800.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildPremiumButton(
      BuildContext context, bool isLoading, bool isSuccess) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          width: isLoading || isSuccess ? 64 : constraints.maxWidth,
          height: 64,
          decoration: BoxDecoration(
            gradient: isSuccess
                ? const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)])
                : AppColors.royalGradient,
            borderRadius:
                BorderRadius.circular(isLoading || isSuccess ? 32 : 20),
            boxShadow: [
              BoxShadow(
                color:
                    (isSuccess ? AppColors.successDeep : AppColors.primaryDeep)
                        .withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (isLoading || isSuccess) return;
                if (_showOtp) {
                  context.read<AuthBloc>().add(AuthVerifyOtpRequested(
                      _phoneController.text, _otpController.text));
                } else {
                  context
                      .read<AuthBloc>()
                      .add(AuthSendOtpRequested(_phoneController.text));
                }
              },
              borderRadius:
                  BorderRadius.circular(isLoading || isSuccess ? 32 : 20),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : isSuccess
                        ? const Icon(Icons.check_rounded,
                                color: Colors.white, size: 32)
                            .animate()
                            .scale(curve: Curves.elasticOut, duration: 600.ms)
                        : Text(
                            _showOtp ? "VERIFY" : "CONTINUE",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              letterSpacing: 1.5,
                            ),
                          ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter(AppLanguage language) {
    return Column(
      children: [
        Text(
          "by_continuing".tr(language),
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white38,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                "terms".tr(language),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Text("•", style: TextStyle(color: Colors.white38)),
            TextButton(
              onPressed: () {},
              child: Text(
                "privacy".tr(language),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 1000.ms);
  }
}

class _PremiumBackground extends StatelessWidget {
  const _PremiumBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0A0A0A), Color(0xFF1A1A2E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // Animated Orbs
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryDeep.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
              duration: 8.seconds,
              begin: const Offset(1, 1),
              end: const Offset(1.2, 1.2)),
        ),

        Positioned(
          bottom: -150,
          left: -150,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.secondary.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
              duration: 10.seconds,
              begin: const Offset(1, 1),
              end: const Offset(1.3, 1.3)),
        ),

        // Stardust Texture
        Opacity(
          opacity: 0.05,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://www.transparenttextures.com/patterns/stardust.png"),
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
