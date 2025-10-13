package com.example.drvlg.domain.record.service;

import com.example.drvlg.domain.record.vo.FuelRecordVO;

import java.util.List;

public interface FuelRecordService {

  void insertFuelRecord(FuelRecordVO fuelRecord, Long currentUserId);

  void updateFuelRecord(FuelRecordVO fuelRecord, Long currentUserId);

  void deleteFuelRecord(Long recordId, Long currentUserId);

  FuelRecordVO selectFuelRecordById(Long recordId, Long currentUserId);

  List<FuelRecordVO> selectFuelRecordsByVehicleId(Long vehicleId, Long currentUserId);
}