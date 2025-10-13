package com.example.drvlg.domain.record.service;

import com.example.drvlg.domain.record.vo.MaintenanceRecordVO;

import java.util.List;

public interface MaintenanceRecordService {

  void insertMaintenanceRecord(MaintenanceRecordVO maintenanceRecord, Long currentUserId);

  void updateMaintenanceRecord(MaintenanceRecordVO maintenanceRecord, Long currentUserId);

  void deleteMaintenanceRecord(Long recordId, Long currentUserId);

  MaintenanceRecordVO selectMaintenanceRecordById(Long recordId, Long currentUserId);

  List<MaintenanceRecordVO> selectMaintenanceRecordsByVehicleId(Long vehicleId, Long currentUserId);
}