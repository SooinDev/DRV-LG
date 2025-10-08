package com.example.drvlg.mapper;

import com.example.drvlg.vo.FuelRecordVO;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface FuelRecordMapper {

  void insertFuelRecord(FuelRecordVO fuelRecord);

  void updateFuelRecord(FuelRecordVO fuelRecord);

  void deleteFuelRecord(Long recordId);

  FuelRecordVO selectFuelRecordById(Long recordId);

  List<FuelRecordVO> selectFuelRecordsByVehicleId(Long vehicleId);

}