package com.example.drvlg.service;

import com.example.drvlg.vo.VehicleVO;
import org.springframework.security.access.AccessDeniedException;
import java.util.List;

public interface VehicleService {

  void registerVehicle(VehicleVO vehicle);

  List<VehicleVO> getVehiclesByUserId(Long userId);

  void deleteVehicle(Long vehicleId, Long currentUserId) throws AccessDeniedException;

  void updateVehicle(VehicleVO vehicle, Long currentUserId) throws AccessDeniedException;
}