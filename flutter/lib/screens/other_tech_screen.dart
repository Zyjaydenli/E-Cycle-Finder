import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';

class OtherTechScreen extends StatelessWidget {
  const OtherTechScreen({super.key});

  static const _devices = [
    {'label': 'Laptop', 'icon': Icons.laptop},
    {'label': 'Cell Phone', 'icon': Icons.smartphone},
    {'label': 'Tablet', 'icon': Icons.tablet},
    {'label': 'TV', 'icon': Icons.tv},
    {'label': 'Printer', 'icon': Icons.print},
    {'label': 'Other', 'icon': Icons.devices_other},
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
                  itemCount: _devices.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _deviceCard(context, _devices[i]),
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
          const Text('Other E-Waste', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _deviceCard(BuildContext context, Map<String, dynamic> device) {
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
          child: Icon(device['icon'] as IconData, color: AppTheme.primaryGreen, size: 28),
        ),
        title: Text(device['label'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.primaryGreen),
        onTap: () => context.push('/other-tech/action', extra: device['label'] as String),
      ),
    );
  }
}

class OtherTechActionScreen extends StatelessWidget {
  final String deviceType;
  const OtherTechActionScreen({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EcoBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => context.pop()),
                    const SizedBox(width: 8),
                    Text(deviceType, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('What would you like to do?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                _actionCard(
                  context,
                  icon: Icons.build,
                  title: 'Repair',
                  subtitle: 'Find local repair shops and learn about the benefits of repairing your device.',
                  color: Colors.orange,
                  onTap: () => context.push('/other-tech/repair-info', extra: deviceType),
                ),
                const SizedBox(height: 14),
                _actionCard(
                  context,
                  icon: Icons.recycling,
                  title: 'Recycle',
                  subtitle: 'Find nearby recycling centers that accept your device.',
                  color: AppTheme.primaryGreen,
                  onTap: () => context.push('/other-tech/map', extra: deviceType),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required Color color, required VoidCallback onTap}) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.all(18),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: color, size: 30),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle, style: const TextStyle(color: Colors.black45, fontSize: 13, height: 1.4)),
        ),
        trailing: Icon(Icons.chevron_right, color: color),
        onTap: onTap,
      ),
    );
  }
}

class RepairInfoScreen extends StatelessWidget {
  final String deviceType;
  const RepairInfoScreen({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EcoBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => context.pop()),
                    const SizedBox(width: 8),
                    Text('Repair Your $deviceType', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _benefitsCard(),
                      const SizedBox(height: 16),
                      _placeholderLocationsCard(),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => context.push('/other-tech/map', extra: deviceType),
                          icon: const Icon(Icons.map),
                          label: const Text('Find Recycling Centers Instead'),
                        ),
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

  Widget _benefitsCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(Icons.eco, color: AppTheme.primaryGreen),
              SizedBox(width: 8),
              Text('Benefits of Repairing', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ],
          ),
          SizedBox(height: 10),
          Text(
            '• Saves money compared to buying new\n• Reduces electronic waste significantly\n• Extends the useful life of your device\n• Lowers your carbon footprint\n• Supports local repair businesses',
            style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _placeholderLocationsCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.store, color: AppTheme.primaryGreen),
              SizedBox(width: 8),
              Text('Nearby Repair Shops', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          _placeholderShop('iFixit Vancouver', '123 Main St'),
          _placeholderShop('Tech Repair Pro', '456 Broadway'),
          _placeholderShop('GreenFix Electronics', '789 Robson St'),
          const SizedBox(height: 8),
          const Text('* Placeholder locations — will be updated with real data.', style: TextStyle(color: Colors.black38, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _placeholderShop(String name, String address) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppTheme.primaryGreen, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              Text(address, style: const TextStyle(color: Colors.black45, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
