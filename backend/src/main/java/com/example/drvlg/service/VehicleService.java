package com.example.drvlg.service;

import com.example.drvlg.vo.VehicleVO;

import java.util.List;

public interface VehicleService {

  void registerVehicle(VehicleVO vehicleVO);

  List<VehicleVO> getVehiclesByUserId(Long userId);
}
