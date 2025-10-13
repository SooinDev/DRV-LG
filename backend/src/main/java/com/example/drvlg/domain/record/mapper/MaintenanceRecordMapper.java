package com.example.drvlg.domain.record.mapper;

import com.example.drvlg.domain.record.vo.MaintenanceRecordVO;

import java.util.List;

public interface MaintenanceRecordMapper {

  void insertMaintenanceRecord(MaintenanceRecordVO maintenanceRecordVO);

  void updateMaintenanceRecord(MaintenanceRecordVO maintenanceRecordVO);

  void deleteMaintenanceRecord(Long recordId);

  MaintenanceRecordVO selectMaintenanceRecordById(Long recordId);

  List<MaintenanceRecordVO> selectMaintenanceRecordsByVehicleId(Long vehicleId);

  MaintenanceRecordVO selectLatestRecordByItemName(Long vehicleId, String itemName);
}
