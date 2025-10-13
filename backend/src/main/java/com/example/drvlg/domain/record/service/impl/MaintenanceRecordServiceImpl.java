package com.example.drvlg.domain.record.service.impl;

import com.example.drvlg.domain.record.service.MaintenanceRecordService;
import com.example.drvlg.domain.record.vo.MaintenanceRecordVO;
import com.example.drvlg.domain.record.mapper.MaintenanceRecordMapper;
import com.example.drvlg.domain.vehicle.mapper.VehicleMapper;
import com.example.drvlg.domain.vehicle.vo.VehicleVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@Service
public class MaintenanceRecordServiceImpl implements MaintenanceRecordService {

  private final MaintenanceRecordMapper maintenanceRecordMapper;
  private final VehicleMapper vehicleMapper;

  @Autowired
  public MaintenanceRecordServiceImpl(MaintenanceRecordMapper maintenanceRecordMapper, VehicleMapper vehicleMapper) {
    this.maintenanceRecordMapper = maintenanceRecordMapper;
    this.vehicleMapper = vehicleMapper;
  }

  @Override
  public void insertMaintenanceRecord(MaintenanceRecordVO maintenanceRecord, Long currentUserId) {
    checkVehicleOwnership(maintenanceRecord.getVehicleId(), currentUserId);
    maintenanceRecordMapper.insertMaintenanceRecord(maintenanceRecord);
  }

  @Override
  public void updateMaintenanceRecord(MaintenanceRecordVO maintenanceRecord, Long currentUserId) {
    checkRecordOwnership(maintenanceRecord.getMaintenanceRecordId(), currentUserId);
    maintenanceRecordMapper.updateMaintenanceRecord(maintenanceRecord);
  }

  @Override
  public void deleteMaintenanceRecord(Long recordId, Long currentUserId) {
    checkRecordOwnership(recordId, currentUserId);
    maintenanceRecordMapper.deleteMaintenanceRecord(recordId);
  }

  @Override
  public MaintenanceRecordVO selectMaintenanceRecordById(Long recordId, Long currentUserId) {
    checkRecordOwnership(recordId, currentUserId);
    return maintenanceRecordMapper.selectMaintenanceRecordById(recordId);
  }

  @Override
  public List<MaintenanceRecordVO> selectMaintenanceRecordsByVehicleId(Long vehicleId, Long currentUserId) {
    checkVehicleOwnership(vehicleId, currentUserId);
    return maintenanceRecordMapper.selectMaintenanceRecordsByVehicleId(vehicleId);
  }

  private void checkVehicleOwnership(Long vehicleId, Long currentUserId) {
    VehicleVO vehicle = vehicleMapper.selectVehicleById(vehicleId);
    if (vehicle == null || !Objects.equals(vehicle.getUserId(), currentUserId)) {
      throw new AccessDeniedException("해당 차량에 접근할 권한이 없습니다.");
    }
  }

  private void checkRecordOwnership(Long recordId, Long currentUserId) {
    MaintenanceRecordVO record = maintenanceRecordMapper.selectMaintenanceRecordById(recordId);
    if (record == null) {
      throw new RuntimeException("기록을 찾을 수 없습니다.");
    }
    checkVehicleOwnership(record.getVehicleId(), currentUserId);
  }
}