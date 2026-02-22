import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/admin_models.dart';
import '../bloc/admin_bloc.dart';
import 'admin_placeholders.dart';

class AdminDevicesPage extends StatelessWidget {
  const AdminDevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminManagementLayout(
      title: 'Device Inventory',
      subtitle: 'Global oversight of hardware running Wedding OS.',
      actions: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download_rounded, size: 18),
          label: const Text('EXPORT CSV'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white10,
            foregroundColor: Colors.white,
          ),
        ),
      ],
      child: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: state.devices.length,
            itemBuilder: (context, index) {
              final device = state.devices[index];
              return AdminDataCard(
                title: device.deviceName,
                subtitle: '${device.model} • ${device.osVersion}',
                trailing: AdminStatusChip(status: device.status.name),
                leading: Icon(
                  device.osVersion.contains('iOS')
                      ? Icons.apple_rounded
                      : Icons.android_rounded,
                  color: Colors.white24,
                ),
                details: [
                  AdminDetailItem(label: 'IP ADDRESS', value: device.ipAddress),
                  AdminDetailItem(
                      label: 'ROOTED', value: device.isRooted ? 'YES' : 'NO'),
                  AdminDetailItem(label: 'BATTERY', value: device.batteryLevel),
                  AdminDetailItem(label: 'STORAGE', value: device.storageFree),
                ],
                onTap: () => _showDeviceDetails(context, device),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeviceDetails(BuildContext context, AdminDevice device) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(device.deviceName,
            style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailLine(
                'Hardware ID', 'HASH_${device.id.hashCode.toRadixString(16)}'),
            _DetailLine('OS Version', device.osVersion),
            _DetailLine('App Version', device.appVersion),
            _DetailLine('Last Seen', device.lastActive.toString()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
          if (device.status != DeviceTrustStatus.banned)
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {},
              child: const Text('BAN DEVICE'),
            ),
        ],
      ),
    );
  }
}

class AdminPermissionsPage extends StatelessWidget {
  const AdminPermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminManagementLayout(
      title: 'Permission Compliance',
      subtitle: 'Real-time grid of sensor and data access grants.',
      child: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: DataTable(
                headingTextStyle: GoogleFonts.inter(
                  color: Colors.white38,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
                dataTextStyle: GoogleFonts.inter(color: Colors.white70),
                columns: const [
                  DataColumn(label: Text('DEVICE / USER')),
                  DataColumn(label: Text('CAMERA')),
                  DataColumn(label: Text('LOCATION')),
                  DataColumn(label: Text('CONTACTS')),
                  DataColumn(label: Text('STORAGE')),
                  DataColumn(label: Text('MIC')),
                ],
                rows: state.permissionCompliance.map((comp) {
                  return DataRow(cells: [
                    DataCell(Text(comp.deviceId)),
                    DataCell(_PermissionIcon(
                        comp.status[PermissionCategory.camera])),
                    DataCell(_PermissionIcon(
                        comp.status[PermissionCategory.location])),
                    DataCell(_PermissionIcon(
                        comp.status[PermissionCategory.contacts])),
                    DataCell(_PermissionIcon(
                        comp.status[PermissionCategory.storage])),
                    DataCell(_PermissionIcon(
                        comp.status[PermissionCategory.microphone])),
                  ]);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AdminNetworkPage extends StatelessWidget {
  const AdminNetworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminManagementLayout(
      title: 'Network Intelligence',
      subtitle: 'ISP distribution and IP classification analysis.',
      child: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: state.ipMetrics.length,
            itemBuilder: (context, index) {
              final metric = state.ipMetrics[index];
              return AdminDataCard(
                title: metric.isp,
                subtitle: metric.ipClass,
                trailing: Text(
                  '${metric.activeNodes} Nodes',
                  style: const TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.bold),
                ),
                leading: Icon(
                  metric.isBlocked ? Icons.block_rounded : Icons.lan_rounded,
                  color: metric.isBlocked ? Colors.redAccent : Colors.white24,
                ),
                details: [
                  AdminDetailItem(
                      label: 'STATUS',
                      value: metric.isBlocked ? 'BLOCKED' : 'ACTIVE'),
                  AdminDetailItem(
                      label: 'THREAT LEVEL',
                      value: metric.isBlocked ? 'HIGH' : 'LOW'),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _PermissionIcon extends StatelessWidget {
  final PermissionLevel? level;
  const _PermissionIcon(this.level);

  @override
  Widget build(BuildContext context) {
    switch (level) {
      case PermissionLevel.granted:
        return const Icon(Icons.check_circle_rounded,
            color: Colors.greenAccent, size: 20);
      case PermissionLevel.denied:
        return const Icon(Icons.cancel_rounded,
            color: Colors.redAccent, size: 20);
      case PermissionLevel.risky:
        return const Icon(Icons.warning_amber_rounded,
            color: Colors.orangeAccent, size: 20);
      default:
        return const Icon(Icons.help_outline_rounded,
            color: Colors.white24, size: 20);
    }
  }
}

class _DetailLine extends StatelessWidget {
  final String label;
  final String value;
  const _DetailLine(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white38, fontSize: 12)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
