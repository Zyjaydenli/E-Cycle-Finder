import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  static const _sections = [
    {
      'title': 'What is E-Waste?',
      'icon': Icons.devices,
      'body':
          'Electronic waste (e-waste) refers to discarded electrical or electronic devices. This includes phones, computers, TVs, and batteries. E-waste is one of the fastest-growing waste streams globally.',
    },
    {
      'title': 'Key Facts',
      'icon': Icons.bar_chart,
      'body':
          '• Over 50 million tonnes of e-waste is generated per year globally.\n• Only 20% of e-waste is formally recycled.\n• E-waste contains lead, mercury, cadmium and other toxic materials.\n• Recycling one million laptops saves energy equivalent to 3,657 homes.',
    },
    {
      'title': 'Quick Tips',
      'icon': Icons.lightbulb_outline,
      'body':
          '• Drop off old devices at certified recycling centers.\n• Remove batteries before recycling electronics.\n• Donate working devices instead of throwing them away.\n• Look for the e-waste recycling symbol on packaging.',
    },
    {
      'title': 'Environmental Impact',
      'icon': Icons.eco,
      'body':
          'Improper disposal of e-waste can contaminate soil and groundwater. Recycling recovers precious metals like gold, silver, and copper, reducing the need for new mining operations.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EcoBackground(
        child: SafeArea(
          child: Column(
            children: [
              _header(context),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: _sections.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (_, i) => _sectionCard(_sections[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => context.pop()),
          const SizedBox(width: 8),
          const Text('Learn About E-Waste', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _sectionCard(Map<String, dynamic> section) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(section['icon'] as IconData, color: AppTheme.primaryGreen, size: 22),
              const SizedBox(width: 8),
              Text(section['title'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Text(section['body'] as String, style: const TextStyle(color: Colors.black54, fontSize: 14, height: 1.55)),
        ],
      ),
    );
  }
}
