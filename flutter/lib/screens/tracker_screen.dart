import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  int _batteriesRecycled = 0;
  int _devicesRecycled = 0;
  final _batteryCtrl = TextEditingController();
  final _deviceCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _batteriesRecycled = prefs.getInt('batteries') ?? 0;
      _devicesRecycled = prefs.getInt('devices') ?? 0;
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('batteries', _batteriesRecycled);
    await prefs.setInt('devices', _devicesRecycled);
  }

  void _addEntry() {
    final batteries = int.tryParse(_batteryCtrl.text) ?? 0;
    final devices = int.tryParse(_deviceCtrl.text) ?? 0;
    setState(() {
      _batteriesRecycled += batteries;
      _devicesRecycled += devices;
    });
    _batteryCtrl.clear();
    _deviceCtrl.clear();
    _save();
    Navigator.pop(context);
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Log Recycling', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(
              controller: _batteryCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Batteries recycled',
                prefixIcon: const Icon(Icons.battery_charging_full, color: AppTheme.primaryGreen),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _deviceCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Devices recycled',
                prefixIcon: const Icon(Icons.devices, color: AppTheme.primaryGreen),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _addEntry, child: const Text('Save Entry')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EcoBackground(
        child: SafeArea(
          child: Column(
            children: [
              _header(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _impactCard(),
                      const SizedBox(height: 16),
                      _statsRow(),
                      const SizedBox(height: 16),
                      _logButton(),
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

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => context.pop()),
          const SizedBox(width: 8),
          const Text('Recycling Impact Tracker', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _impactCard() {
    final co2Saved = (_batteriesRecycled * 0.15 + _devicesRecycled * 2.5).toStringAsFixed(1);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppTheme.primaryGreen, AppTheme.lightGreen], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.2), blurRadius: 14, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your Impact', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('~$co2Saved kg CO₂ saved', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Great work helping the environment!', style: TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(child: _statCard('Batteries', _batteriesRecycled.toString(), Icons.battery_charging_full)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('Devices', _devicesRecycled.toString(), Icons.devices)),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return AppCard(
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryGreen, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
          Text(label, style: const TextStyle(color: Colors.black45, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _logButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _showAddSheet,
        icon: const Icon(Icons.add),
        label: const Text('Log Recycling Entry'),
      ),
    );
  }
}
