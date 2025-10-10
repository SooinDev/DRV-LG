package com.example.drvlg.service.impl;

import com.example.drvlg.mapper.VehicleMapper;
import com.example.drvlg.service.VehicleService;
import com.example.drvlg.vo.VehicleVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@Service
public class VehicleServiceImpl implements VehicleService {

  private final VehicleMapper vehicleMapper;

  @Autowired
  public VehicleServiceImpl(VehicleMapper vehicleMapper) {
    this.vehicleMapper = vehicleMapper;
  }

  @Override
  public void registerVehicle(VehicleVO vehicle) {
    vehicleMapper.insertVehicle(vehicle);
  }

  @Override
  public List<VehicleVO> getVehiclesByUserId(Long userId) {
    return vehicleMapper.selectVehiclesByUserId(userId);
  }

  @Override
  public void deleteVehicle(Long vehicleId, Long currentUserId) throws AccessDeniedException {
    VehicleVO vehicle = vehicleMapper.selectVehicleById(vehicleId);

    if (vehicle == null) {
      throw new RuntimeException("차량을 찾을 수 없습니다.");
    }

    if (!Objects.equals(vehicle.getUserId(), currentUserId)) {
      throw new AccessDeniedException("삭제할 권한이 없습니다.");
    }

    vehicleMapper.deleteVehicle(vehicleId);
  }

  @Override
  public void updateVehicle(VehicleVO vehicle, Long currentUserId) throws AccessDeniedException {
    VehicleVO existingVehicle = vehicleMapper.selectVehicleById(vehicle.getVehicleId());

    if (existingVehicle == null) {
      throw new RuntimeException("차량을 찾을 수 없습니다.");
    }

    if (!Objects.equals(existingVehicle.getUserId(), currentUserId)) {
      throw new AccessDeniedException("수정할 권한이 없습니다.");
    }

    vehicleMapper.updateVehicle(vehicle);
  }
}