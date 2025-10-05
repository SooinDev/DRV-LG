package com.example.drvlg.service.impl;

import com.example.drvlg.mapper.MaintenanceRecordMapper;
import com.example.drvlg.service.MaintenanceRecordService;
import com.example.drvlg.vo.MaintenanceRecordVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MaintenanceRecordServiceImpl implements MaintenanceRecordService {

  private final MaintenanceRecordMapper maintenanceRecordMapper;

  @Autowired
  public MaintenanceRecordServiceImpl(MaintenanceRecordMapper maintenanceRecordMapper) {
    this.maintenanceRecordMapper = maintenanceRecordMapper;
  }

  @Override
  public void insertMaintenanceRecord(MaintenanceRecordVO maintenanceRecordVO) {
    maintenanceRecordMapper.insertMaintenanceRecord(maintenanceRecordVO);
  }

  @Override
  public void updateMaintenanceRecord(MaintenanceRecordVO maintenanceRecordVO) {
    maintenanceRecordMapper.updateMaintenanceRecord(maintenanceRecordVO);
  }

  @Override
  public void deleteMaintenanceRecord(Long recordId) {
    maintenanceRecordMapper.deleteMaintenanceRecord(recordId);
  }

  @Override
  public MaintenanceRecordVO selectMaintenanceRecordById(Long recordId) {
    return maintenanceRecordMapper.selectMaintenanceRecordById(recordId);
  }

  @Override
  public List<MaintenanceRecordVO> selectMaintenanceRecordsByVehicleId(Long vehicleId) {
    return maintenanceRecordMapper.selectMaintenanceRecordsByVehicleId(vehicleId);
  }
}
