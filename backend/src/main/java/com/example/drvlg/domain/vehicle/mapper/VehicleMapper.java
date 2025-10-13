package com.example.drvlg.domain.vehicle.mapper;

import com.example.drvlg.domain.vehicle.vo.VehicleVO;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface VehicleMapper {

  void insertVehicle(VehicleVO vehicleVO);

  List<VehicleVO> selectVehiclesByUserId(Long userId);

  VehicleVO selectVehicleById(Long vehicleId);

  Integer selectLatestOdometer(Long vehicleId);

  void deleteVehicle(Long vehicleId);

  void updateVehicle(VehicleVO vehicleVO);
}