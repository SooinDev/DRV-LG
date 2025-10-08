import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/fuel_record.dart';

class FuelRecordFormScreen extends StatefulWidget {
  final int vehicleId;
  final FuelRecord? record;

  const FuelRecordFormScreen({
    super.key,
    required this.vehicleId,
    this.record,
  });

  @override
  State<FuelRecordFormScreen> createState() => _FuelRecordFormScreenState();
}

class _FuelRecordFormScreenState extends State<FuelRecordFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fuelAmountController = TextEditingController();
  final _apiService = ApiService();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.record != null) {
      _fuelAmountController.text = widget.record!.fuelAmount.toString();
      _selectedDate = widget.record!.fuelDate;
    }
  }

  @override
  void dispose() {
    _fuelAmountController.dispose();
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
      final record = FuelRecord(
        recordId: widget.record?.recordId,
        vehicleId: widget.vehicleId,
        fuelDate: _selectedDate,
        fuelAmount: double.parse(_fuelAmountController.text),
      );

      if (widget.record == null) {
        await _apiService.createFuelRecord(widget.vehicleId, record);
      } else {
        await _apiService.updateFuelRecord(
          widget.vehicleId,
          widget.record!.recordId!,
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
        title: Text(widget.record == null ? '주유 기록 추가' : '주유 기록 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ListTile(
                title: const Text('주유 날짜'),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fuelAmountController,
                decoration: const InputDecoration(
                  labelText: '주유량 (L)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '주유량을 입력하세요';
                  }
                  if (double.tryParse(value) == null) {
                    return '올바른 숫자를 입력하세요';
                  }
                  return null;
                },
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
