import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/maintenance_record.dart';
import 'maintenance_record_form_screen.dart';

class MaintenanceRecordsScreen extends StatefulWidget {
  final int vehicleId;

  const MaintenanceRecordsScreen({super.key, required this.vehicleId});

  @override
  State<MaintenanceRecordsScreen> createState() => _MaintenanceRecordsScreenState();
}

class _MaintenanceRecordsScreenState extends State<MaintenanceRecordsScreen> {
  final _apiService = ApiService();
  List<MaintenanceRecord> _records = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _isLoading = true);

    try {
      final records = await _apiService.getMaintenanceRecords(widget.vehicleId);
      setState(() {
        _records = records;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteRecord(int recordId) async {
    try {
      await _apiService.deleteMaintenanceRecord(widget.vehicleId, recordId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('삭제되었습니다')),
        );
        _loadRecords();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('정비 기록'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _records.isEmpty
              ? const Center(child: Text('정비 기록이 없습니다'))
              : ListView.builder(
                  itemCount: _records.length,
                  itemBuilder: (context, index) {
                    final record = _records[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(
                          record.item,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('yyyy-MM-dd').format(record.maintenanceDate),
                            ),
                            Text('주행거리: ${record.odoMeter}km'),
                            Text('비용: ${record.totalCost}원'),
                            if (record.memo != null && record.memo!.isNotEmpty)
                              Text('메모: ${record.memo}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MaintenanceRecordFormScreen(
                                      vehicleId: widget.vehicleId,
                                      record: record,
                                    ),
                                  ),
                                ).then((_) => _loadRecords());
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('삭제 확인'),
                                    content: const Text('이 기록을 삭제하시겠습니까?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('취소'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _deleteRecord(record.maintenanceRecordId!);
                                        },
                                        child: const Text('삭제'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MaintenanceRecordFormScreen(
                vehicleId: widget.vehicleId,
              ),
            ),
          ).then((_) => _loadRecords());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
