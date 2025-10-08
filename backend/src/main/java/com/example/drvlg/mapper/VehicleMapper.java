package com.example.drvlg.mapper;

import com.example.drvlg.vo.VehicleVO;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface VehicleMapper {

  void insertVehicle(VehicleVO vehicleVO);

  List<VehicleVO> selectVehiclesByUserId(Long userId);

  Integer selectLatestOdometer(Long vehicleId);
}