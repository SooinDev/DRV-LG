package com.example.drvlg.service.impl;

import com.example.drvlg.mapper.VehicleMapper;
import com.example.drvlg.service.VehicleService;
import com.example.drvlg.vo.VehicleVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class VehicleServiceImpl implements VehicleService {

  private final VehicleMapper vehicleMapper;

  @Autowired
  public VehicleServiceImpl(VehicleMapper vehicleMapper) {
    this.vehicleMapper = vehicleMapper;
  }

  @Override
  public void registerVehicle(VehicleVO vehicleVO) {
    vehicleMapper.insertVehicle(vehicleVO);
  }

  @Override
  public List<VehicleVO> getVehiclesByUserId(Long userId) {
    return vehicleMapper.selectVehiclesByUserId(userId);
  }
}
