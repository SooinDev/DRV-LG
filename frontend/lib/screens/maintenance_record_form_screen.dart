import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/maintenance_record.dart';

class MaintenanceRecordFormScreen extends StatefulWidget {
  final int vehicleId;
  final MaintenanceRecord? record;

  const MaintenanceRecordFormScreen({
    super.key,
    required this.vehicleId,
    this.record,
  });

  @override
  State<MaintenanceRecordFormScreen> createState() => _MaintenanceRecordFormScreenState();
}

class _MaintenanceRecordFormScreenState extends State<MaintenanceRecordFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _itemController = TextEditingController();
  final _odoMeterController = TextEditingController();
  final _totalCostController = TextEditingController();
  final _memoController = TextEditingController();
  final _apiService = ApiService();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.record != null) {
      _itemController.text = widget.record!.item;
      _odoMeterController.text = widget.record!.odoMeter.toString();
      _totalCostController.text = widget.record!.totalCost.toString();
      _memoController.text = widget.record!.memo ?? '';
      _selectedDate = widget.record!.maintenanceDate;
    }
  }

  @override
  void dispose() {
    _itemController.dispose();
    _odoMeterController.dispose();
    _totalCostController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveRecord() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final record = MaintenanceRecord(
        maintenanceRecordId: widget.record?.maintenanceRecordId,
        vehicleId: widget.vehicleId,
        maintenanceDate: _selectedDate,
        odoMeter: int.parse(_odoMeterController.text),
        item: _itemController.text,
        totalCost: int.parse(_totalCostController.text),
        memo: _memoController.text.isEmpty ? null : _memoController.text,
      );

      if (widget.record == null) {
        await _apiService.createMaintenanceRecord(widget.vehicleId, record);
      } else {
        await _apiService.updateMaintenanceRecord(
          widget.vehicleId,
          widget.record!.maintenanceRecordId!,
          record,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.record == null ? '등록되었습니다' : '수정되었습니다'),
          ),
        );
        Navigator.of(context).pop();
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record == null ? '정비 기록 추가' : '정비 기록 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ListTile(
                title: const Text('정비 날짜'),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _itemController,
                decoration: const InputDecoration(
                  labelText: '정비 내역',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '정비 내역을 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _odoMeterController,
                decoration: const InputDecoration(
                  labelText: '주행거리 (km)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '주행거리를 입력하세요';
                  }
                  if (int.tryParse(value) == null) {
                    return '올바른 숫자를 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _totalCostController,
                decoration: const InputDecoration(
                  labelText: '비용 (원)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비용을 입력하세요';
                  }
                  if (int.tryParse(value) == null) {
                    return '올바른 숫자를 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _memoController,
                decoration: const InputDecoration(
                  labelText: '메모 (선택)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveRecord,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(widget.record == null ? '등록' : '수정'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
