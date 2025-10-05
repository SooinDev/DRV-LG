package com.example.drvlg.service;

import com.example.drvlg.vo.MaintenanceRecordVO;

import java.util.List;

public interface MaintenanceRecordService {

  void insertMaintenanceRecord(MaintenanceRecordVO maintenanceRecordVO);

  void updateMaintenanceRecord(MaintenanceRecordVO maintenanceRecordVO);

  void deleteMaintenanceRecord(Long recordId);

  MaintenanceRecordVO selectMaintenanceRecordById(Long id);

  List<MaintenanceRecordVO> selectMaintenanceRecordsByVehicleId(Long vehicleId);

}
