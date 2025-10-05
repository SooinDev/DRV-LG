package com.example.drvlg.service;

import com.example.drvlg.vo.FuelRecordVO;
import java.util.List;

public interface FuelRecordService {

  void insertFuelRecord(FuelRecordVO fuelRecordVO);

  void updateFuelRecord(FuelRecordVO fuelRecordVO);

  void deleteFuelRecord(Long id);

  FuelRecordVO selectFuelRecordById(Long recordId);

  List<FuelRecordVO> selectFuelRecordsByVehicleId(Long vehicleId);
}
