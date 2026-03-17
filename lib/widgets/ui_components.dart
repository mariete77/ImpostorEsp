import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../utils/design_constants.dart';

/// Botón animado con feedback visual
class AnimatedButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;
  final double? width;
  final double? height;

  const AnimatedButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
    this.width,
    this.height,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isLoading) {
      setState(() => _isPressed = false);
      _controller.reverse();
      widget.onPressed();
    }
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? AppTheme.primary;
    final fgColor = widget.foregroundColor ?? Colors.white;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height ?? DesignConstants.heightButton,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isPressed
                      ? [bgColor.withOpacity(0.8), bgColor.withOpacity(0.9)]
                      : [bgColor, bgColor.withOpacity(0.9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(DesignConstants.radiusLarge),
                boxShadow: _isPressed
                    ? []
                    : AppShadows.medium(bgColor),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTapDown: _handleTapDown,
                  onTapUp: _handleTapUp,
                  onTapCancel: _handleTapCancel,
                  borderRadius: BorderRadius.circular(DesignConstants.radiusLarge),
                  child: widget.isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      : Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.icon != null) ...[
                                Icon(
                                  widget.icon,
                                  color: fgColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                widget.label,
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: DesignConstants.textMedium,
                                  fontWeight: FontWeight.w700,
                                  color: fgColor,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Tarjeta con gradiente y animación
class GradientCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? gradientColor1;
  final Color? gradientColor2;
  final double? width;
  final double? height;
  final EdgeInsets? padding;

  const GradientCard({
    super.key,
    required this.child,
    this.onTap,
    this.gradientColor1,
    this.gradientColor2,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final color1 = gradientColor1 ?? AppTheme.primary;
    final color2 = gradientColor2 ?? AppTheme.accentYellow;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DesignConstants.radiusXLarge),
        boxShadow: AppShadows.large(color1),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: child,
      ),
    );
  }
}

/// Input de texto con estilo personalizado
class StyledTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool showError;
  final String? errorText;
  final IconData? icon;
  final TextInputType? keyboardType;
  final int? maxLength;
  final VoidCallback? onSubmitted;
  final ValueChanged<String>? onChanged;

  const StyledTextField({
    super.key,
    this.label,
    this.hint,
    required this.controller,
    this.focusNode,
    this.showError = false,
    this.errorText,
    this.icon,
    this.keyboardType,
    this.maxLength,
    this.onSubmitted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: GoogleFonts.spaceGrotesk(
              fontSize: DesignConstants.textSmall,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: DesignConstants.spacingSmall),
        ],
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(DesignConstants.radiusMedium),
            border: Border.all(
              color: showError
                  ? Colors.red.withOpacity(0.5)
                  : Colors.white.withOpacity(0.1),
              width: showError ? 2 : 1,
            ),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            maxLength: maxLength,
            onSubmitted: (_) {
              if (onSubmitted != null) {
                onSubmitted!();
              }
            },
            onChanged: onChanged,
            style: GoogleFonts.spaceGrotesk(
              fontSize: DesignConstants.textMedium,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.spaceGrotesk(
                fontSize: DesignConstants.textMedium,
                color: Colors.white.withOpacity(0.4),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              prefixIcon: icon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Icon(
                        icon,
                        color: Colors.white.withOpacity(0.5),
                        size: 20,
                      ),
                    )
                  : null,
              counterText: '',
            ),
          ),
        ),
        if (showError && errorText != null) ...[
          const SizedBox(height: DesignConstants.spacingSmall),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                size: 16,
                color: Colors.red.withOpacity(0.7),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  errorText!,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: DesignConstants.textXSmall,
                    color: Colors.red.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Indicador de progreso circular personalizado
class CircularProgressWithLabel extends StatelessWidget {
  final double progress;
  final String? label;
  final Color? color;
  final double size;

  const CircularProgressWithLabel({
    super.key,
    required this.progress,
    this.label,
    this.color,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? AppTheme.primary;
    final isLow = progress < 0.3;
    final isCritical = progress < 0.15;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Background circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 6,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          // Progress circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 6,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                isCritical
                    ? Colors.red
                    : isLow
                        ? Colors.orange
                        : progressColor,
              ),
            ),
          ),
          // Center label
          if (label != null)
            Center(
              child: Text(
                label!,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: size * 0.25,
                  fontWeight: FontWeight.w700,
                  color: isCritical
                      ? Colors.red
                      : isLow
                          ? Colors.orange
                          : Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Avatar personalizado con gradiente
class Avatar extends StatelessWidget {
  final String name;
  final Color? color;
  final double size;
  final bool isEliminated;

  const Avatar({
    super.key,
    required this.name,
    this.color,
    this.size = 60,
    this.isEliminated = false,
  });

  @override
  Widget build(BuildContext context) {
    final avatarColor = color ?? AppTheme.primary;
    final initials = name
        .split(' ')
        .map((part) => part[0])
        .take(2)
        .join('');

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEliminated
              ? [Colors.grey, Colors.grey.shade700]
              : [avatarColor, avatarColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: AppShadows.medium(avatarColor),
      ),
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: GoogleFonts.spaceGrotesk(
            fontSize: size * 0.35,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Chip de estado
class StatusChip extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;

  const StatusChip({
    super.key,
    required this.label,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppTheme.accentYellow;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: chipColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: chipColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: DesignConstants.textSmall,
              fontWeight: FontWeight.w600,
              color: chipColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
