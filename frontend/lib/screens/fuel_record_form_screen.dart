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
  final _odoMeterController = TextEditingController();
  final _pricePerLiterController = TextEditingController();
  final _litersController = TextEditingController();
  final _totalPriceController = TextEditingController();
  final _memoController = TextEditingController();
  final _apiService = ApiService();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.record != null) {
      _odoMeterController.text = widget.record!.odoMeter.toString();
      _pricePerLiterController.text = widget.record!.pricePerLiter.toString();
      _litersController.text = widget.record!.liters.toString();
      _totalPriceController.text = widget.record!.totalPrice.toString();
      _memoController.text = widget.record!.memo ?? '';
      _selectedDate = widget.record!.fuelDate;
    }
  }

  @override
  void dispose() {
    _odoMeterController.dispose();
    _pricePerLiterController.dispose();
    _litersController.dispose();
    _totalPriceController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _calculateTotalPrice() {
    final pricePerLiter = int.tryParse(_pricePerLiterController.text);
    final liters = double.tryParse(_litersController.text);
    if (pricePerLiter != null && liters != null) {
      final total = (pricePerLiter * liters).round();
      _totalPriceController.text = total.toString();
    }
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
        odoMeter: int.parse(_odoMeterController.text),
        pricePerLiter: int.parse(_pricePerLiterController.text),
        liters: double.parse(_litersController.text),
        totalPrice: int.parse(_totalPriceController.text),
        memo: _memoController.text.isEmpty ? null : _memoController.text,
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
          child: ListView(
            children: [
              ListTile(
                title: const Text('주유 날짜'),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectDate,
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
                controller: _pricePerLiterController,
                decoration: const InputDecoration(
                  labelText: '리터당 단가 (원)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateTotalPrice(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '리터당 단가를 입력하세요';
                  }
                  if (int.tryParse(value) == null) {
                    return '올바른 숫자를 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _litersController,
                decoration: const InputDecoration(
                  labelText: '주유량 (L)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => _calculateTotalPrice(),
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _totalPriceController,
                decoration: const InputDecoration(
                  labelText: '총 금액 (원)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '총 금액을 입력하세요';
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
