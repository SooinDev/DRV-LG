package com.example.drvlg.service.impl;

import com.example.drvlg.mapper.FuelRecordMapper;
import com.example.drvlg.mapper.VehicleMapper;
import com.example.drvlg.service.FuelRecordService;
import com.example.drvlg.vo.VehicleVO;
import com.example.drvlg.vo.FuelRecordVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@Service
public class FuelRecordServiceImpl implements FuelRecordService {

  private final FuelRecordMapper fuelRecordMapper;
  private final VehicleMapper vehicleMapper;

  @Autowired
  public FuelRecordServiceImpl(FuelRecordMapper fuelRecordMapper, VehicleMapper vehicleMapper) {
    this.fuelRecordMapper = fuelRecordMapper;
    this.vehicleMapper = vehicleMapper;
  }

  @Override
  public void insertFuelRecord(FuelRecordVO fuelRecord, Long currentUserId) {
    checkVehicleOwnership(fuelRecord.getVehicleId(), currentUserId);
    fuelRecordMapper.insertFuelRecord(fuelRecord);
  }

  @Override
  public void updateFuelRecord(FuelRecordVO fuelRecord, Long currentUserId) {
    checkRecordOwnership(fuelRecord.getRecordId(), currentUserId);
    fuelRecordMapper.updateFuelRecord(fuelRecord);
  }

  @Override
  public void deleteFuelRecord(Long recordId, Long currentUserId) {
    checkRecordOwnership(recordId, currentUserId);
    fuelRecordMapper.deleteFuelRecord(recordId);
  }

  @Override
  public FuelRecordVO selectFuelRecordById(Long recordId, Long currentUserId) {
    checkRecordOwnership(recordId, currentUserId);
    return fuelRecordMapper.selectFuelRecordById(recordId);
  }

  @Override
  public List<FuelRecordVO> selectFuelRecordsByVehicleId(Long vehicleId, Long currentUserId) {
    checkVehicleOwnership(vehicleId, currentUserId);
    return fuelRecordMapper.selectFuelRecordsByVehicleId(vehicleId);
  }

  private void checkVehicleOwnership(Long vehicleId, Long currentUserId) {
    VehicleVO vehicle = vehicleMapper.selectVehicleById(vehicleId);
    if (vehicle == null || !Objects.equals(vehicle.getUserId(), currentUserId)) {
      throw new AccessDeniedException("해당 차량에 접근할 권한이 없습니다.");
    }
  }

  private void checkRecordOwnership(Long recordId, Long currentUserId) {
    FuelRecordVO record = fuelRecordMapper.selectFuelRecordById(recordId);
    if (record == null) {
      throw new RuntimeException("기록을 찾을 수 없습니다.");
    }
    checkVehicleOwnership(record.getVehicleId(), currentUserId);
  }
}