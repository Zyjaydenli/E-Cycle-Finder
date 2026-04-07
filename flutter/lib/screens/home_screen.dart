import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EcoBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _heroCard(),
                const SizedBox(height: 18),
                _actionsCard(context),
                const SizedBox(height: 18),
                _infoCard(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _heroCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 175),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A9357), Color(0xFF97DFC0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.20),
            blurRadius: 14,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.recycling, color: Colors.white, size: 38),
                    SizedBox(width: 10),
                    Text(
                      'E-Cycle Finder',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Find nearby e-waste recycling centers and build better recycling habits.',
                  style: TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            right: 14,
            child: Icon(Icons.battery_charging_full, size: 58, color: Colors.white.withOpacity(0.22)),
          ),
        ],
      ),
    );
  }

  Widget _actionsCard(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.auto_awesome, color: AppTheme.primaryGreen, size: 18),
              SizedBox(width: 6),
              Text('Explore', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 14),
          _primaryButton(context, 'Find Recycling Centers', Icons.location_on, '/find-center'),
          const SizedBox(height: 10),
          _secondaryButton(context, 'Learn About E-Waste', Icons.menu_book, '/learn'),
          const SizedBox(height: 10),
          _secondaryButton(context, 'Track Your Battery Recycling Impact', Icons.show_chart, '/tracker'),
        ],
      ),
    );
  }

  Widget _primaryButton(BuildContext context, String label, IconData icon, String route) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => context.push(route),
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }

  Widget _secondaryButton(BuildContext context, String label, IconData icon, String route) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => context.push(route),
        icon: Icon(icon, color: AppTheme.primaryGreen),
        label: Text(label),
      ),
    );
  }

  Widget _infoCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.public, color: AppTheme.primaryGreen),
              SizedBox(width: 8),
              Text('Why recycle e-waste?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'E-waste contains hazardous materials and valuable resources. Recycling helps protect the environment, conserve raw materials, and improve community health.',
            style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppTheme.primaryGreen, AppTheme.lightGreen],
              ).createShader(bounds),
              child: const Icon(Icons.recycling, size: 42, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
