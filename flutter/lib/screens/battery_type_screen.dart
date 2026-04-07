import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';

class BatteryTypeScreen extends StatelessWidget {
  const BatteryTypeScreen({super.key});

  static const _batteries = [
    {'label': 'Alkaline', 'icon': Icons.battery_full, 'desc': 'AA, AAA, C, D batteries'},
    {'label': 'Lithium-ion', 'icon': Icons.battery_charging_full, 'desc': 'Laptop, phone batteries'},
    {'label': 'Lead-Acid', 'icon': Icons.car_repair, 'desc': 'Car batteries'},
    {'label': 'Nickel-Metal Hydride', 'icon': Icons.battery_5_bar, 'desc': 'Rechargeable AA/AAA'},
    {'label': 'Button Cell', 'icon': Icons.circle, 'desc': 'Watch, remote batteries'},
    {'label': 'Other', 'icon': Icons.battery_unknown, 'desc': 'All other battery types'},
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
                  itemCount: _batteries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => _batteryCard(context, _batteries[i]),
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
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 8),
          const Text('Select Battery Type', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _batteryCard(BuildContext context, Map<String, dynamic> battery) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(battery['icon'] as IconData, color: AppTheme.primaryGreen, size: 28),
        ),
        title: Text(battery['label'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: Text(battery['desc'] as String, style: const TextStyle(color: Colors.black45, fontSize: 13)),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.primaryGreen),
        onTap: () => context.push('/battery-map', extra: battery['label'] as String),
      ),
    );
  }
}
