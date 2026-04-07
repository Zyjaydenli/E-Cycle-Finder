import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'screens/battery_type_screen.dart';
import 'screens/map_screen.dart';
import 'screens/learn_screen.dart';
import 'screens/tracker_screen.dart';
import 'screens/other_tech_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(
      path: '/find-center',
      builder: (_, __) => const _FindCenterScreen(),
      routes: [
        GoRoute(
          path: 'battery',
          builder: (_, __) => const BatteryTypeScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/battery-map',
      builder: (_, state) => MapScreen(title: '${state.extra ?? 'Battery'} Recycling Centers'),
    ),
    GoRoute(path: '/learn', builder: (_, __) => const LearnScreen()),
    GoRoute(path: '/tracker', builder: (_, __) => const TrackerScreen()),
    GoRoute(path: '/other-tech', builder: (_, __) => const OtherTechScreen()),
    GoRoute(
      path: '/other-tech/action',
      builder: (_, state) => OtherTechActionScreen(deviceType: state.extra as String? ?? 'Device'),
    ),
    GoRoute(
      path: '/other-tech/repair-info',
      builder: (_, state) => RepairInfoScreen(deviceType: state.extra as String? ?? 'Device'),
    ),
    GoRoute(
      path: '/other-tech/map',
      builder: (_, state) => MapScreen(title: '${state.extra ?? 'E-Waste'} Recycling Centers'),
    ),
  ],
);

class _FindCenterScreen extends StatelessWidget {
  const _FindCenterScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EcoBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => context.pop()),
                    const SizedBox(width: 8),
                    const Text('Find Recycling Centers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _CategoryCard(
                        icon: Icons.battery_charging_full,
                        title: 'Battery Recycling',
                        subtitle: 'Alkaline, Lithium-ion, Lead-Acid and more',
                        color: Colors.green,
                        onTap: () => context.push('/find-center/battery'),
                      ),
                      const SizedBox(height: 14),
                      _CategoryCard(
                        icon: Icons.devices,
                        title: 'Other E-Waste',
                        subtitle: 'Laptops, phones, tablets, TVs and more',
                        color: Colors.blue,
                        onTap: () => context.push('/other-tech'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.black45, fontSize: 13)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }
}
