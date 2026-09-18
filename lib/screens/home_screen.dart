import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/game_enums.dart';
import '../widgets/xo_painter.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GameMode _selectedMode = GameMode.passAndPlay;
  PlayerMark _selectedPlayer = PlayerMark.x;

  void _startGame() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GameScreen(
          gameMode: _selectedMode,
          humanPlayer: _selectedPlayer,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // Glowing Logo / Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const XMarkWidget(size: 48),
                  const SizedBox(width: 14),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF38BDF8), Color(0xFF818CF8)],
                    ).createShader(bounds),
                    child: const Text(
                      'TIC TAC TOE',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const OMarkWidget(size: 48),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Cross-Platform Classic Edition',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                  letterSpacing: 1.0,
                ),
              ),

              const SizedBox(height: 36),

              // Game Mode Selection Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'SELECT GAME MODE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: const Color(0xFF94A3B8).withValues(alpha: 0.8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Game Mode Cards
              _ModeCard(
                icon: Icons.people_alt_rounded,
                title: 'Pass & Play',
                subtitle: '2 Players on this device',
                iconColor: const Color(0xFF38BDF8),
                isSelected: _selectedMode == GameMode.passAndPlay,
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedMode = GameMode.passAndPlay);
                },
              ),
              const SizedBox(height: 12),
              _ModeCard(
                icon: Icons.smart_toy_outlined,
                title: 'vs AI (Casual)',
                subtitle: 'Fun & relaxing computer player',
                iconColor: const Color(0xFF34D399),
                isSelected: _selectedMode == GameMode.vsAiEasy,
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedMode = GameMode.vsAiEasy);
                },
              ),
              const SizedBox(height: 12),
              _ModeCard(
                icon: Icons.psychology_rounded,
                title: 'vs AI (Unbeatable)',
                subtitle: 'Flawless Minimax computer master',
                iconColor: const Color(0xFFF43F5E),
                isSelected: _selectedMode == GameMode.vsAiUnbeatable,
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedMode = GameMode.vsAiUnbeatable);
                },
              ),

              const SizedBox(height: 28),

              // Choose Your Symbol (Only relevant for AI mode)
              if (_selectedMode != GameMode.passAndPlay) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'PICK YOUR MARK',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: const Color(0xFF94A3B8).withValues(alpha: 0.8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _SymbolChoiceCard(
                        symbol: 'X',
                        subtitle: 'Goes First',
                        color: const Color(0xFFF43F5E),
                        isSelected: _selectedPlayer == PlayerMark.x,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedPlayer = PlayerMark.x);
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _SymbolChoiceCard(
                        symbol: 'O',
                        subtitle: 'Goes Second',
                        color: const Color(0xFF06B6D4),
                        isSelected: _selectedPlayer == PlayerMark.o,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedPlayer = PlayerMark.o);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
              ],

              const SizedBox(height: 12),

              // Start Game Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _startGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38BDF8),
                    foregroundColor: const Color(0xFF0F172A),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow_rounded, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'START MATCH',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Footer compatibility notice
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.phone_android_rounded, size: 16, color: Color(0xFF64748B)),
                    SizedBox(width: 6),
                    Text(
                      'Android',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                    SizedBox(width: 12),
                    Text('•', style: TextStyle(color: Color(0xFF64748B))),
                    SizedBox(width: 12),
                    Icon(Icons.phone_iphone_rounded, size: 16, color: Color(0xFF64748B)),
                    SizedBox(width: 6),
                    Text(
                      'iOS',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1E293B)
              : const Color(0xFF1E293B).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? iconColor : const Color(0xFF334155),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: iconColor.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? iconColor : const Color(0xFF475569),
            ),
          ],
        ),
      ),
    );
  }
}

class _SymbolChoiceCard extends StatelessWidget {
  final String symbol;
  final String subtitle;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _SymbolChoiceCard({
    required this.symbol,
    required this.subtitle,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : const Color(0xFF1E293B).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? color : const Color(0xFF334155),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              symbol,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
