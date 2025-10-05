package com.example.drvlg.service.impl;

import com.example.drvlg.mapper.FuelRecordMapper;
import com.example.drvlg.service.FuelRecordService;
import com.example.drvlg.vo.FuelRecordVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Service
public class FuelRecordServiceImpl implements FuelRecordService {

  private final FuelRecordMapper fuelRecordMapper;

  @Autowired
  public FuelRecordServiceImpl(FuelRecordMapper fuelRecordMapper) {
    this.fuelRecordMapper = fuelRecordMapper;
  }

  @Override
  public void insertFuelRecord(FuelRecordVO fuelRecordVO) {
    fuelRecordMapper.insertFuelRecord(fuelRecordVO);
  }

  @Override
  public void updateFuelRecord(FuelRecordVO fuelRecordVO) {
    fuelRecordMapper.updateFuelRecord(fuelRecordVO);
  }

  @Override
  public void deleteFuelRecord(Long id) {
    fuelRecordMapper.deleteFuelRecord(id);
  }

  @Override
  public FuelRecordVO selectFuelRecordById(Long recordId) {
    return fuelRecordMapper.selectFuelRecordById(recordId);
  }

  @Override
  public List<FuelRecordVO> selectFuelRecordsByVehicleId(Long vehicleId) {
    return fuelRecordMapper.selectFuelRecordsByVehicleId(vehicleId);
  }
  
}
