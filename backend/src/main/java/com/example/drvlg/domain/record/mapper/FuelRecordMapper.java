package com.example.drvlg.domain.record.mapper;

import com.example.drvlg.domain.record.vo.FuelRecordVO;
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