import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../theme.dart';
import '../data/locations.dart';

class MapScreen extends StatefulWidget {
  final String title;
  const MapScreen({super.key, required this.title});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final LatLng _vancouver = const LatLng(49.2500, -123.1000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _vancouver,
              initialZoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'zy.ecycle_finder',
              ),
              MarkerLayer(
                markers: seedLocations.map((loc) => _buildMarker(loc)).toList(),
              ),
            ],
          ),
          SafeArea(
            child: Column(
              children: [
                _topBar(context),
                const Spacer(),
                _locationList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
              ),
              child: Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationList() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.97),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -4))],
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: AppTheme.primaryGreen, size: 18),
                const SizedBox(width: 6),
                Text('${seedLocations.length} Nearby Locations', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: seedLocations.length,
              itemBuilder: (_, i) => _locationChip(seedLocations[i]),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _locationChip(RecyclingLocation loc) {
    return GestureDetector(
      onTap: () => _mapController.move(loc.coordinates, 15),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 10, bottom: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.primaryGreen.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.recycling, color: AppTheme.primaryGreen, size: 20),
            const SizedBox(height: 6),
            Text(loc.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
            const Spacer(),
            const Text('Open 9am – 6pm', style: TextStyle(color: Colors.black38, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Marker _buildMarker(RecyclingLocation loc) {
    return Marker(
      point: loc.coordinates,
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: () => _showLocationSheet(loc),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: AppTheme.primaryGreen.withOpacity(0.4), blurRadius: 8, spreadRadius: 1)],
          ),
          child: const Icon(Icons.recycling, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  void _showLocationSheet(RecyclingLocation loc) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.recycling, color: AppTheme.primaryGreen, size: 28),
                const SizedBox(width: 10),
                Expanded(child: Text(loc.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17))),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.black45),
                SizedBox(width: 6),
                Text('Open 9am – 6pm', style: TextStyle(color: Colors.black45)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.directions),
                label: const Text('Get Directions'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
