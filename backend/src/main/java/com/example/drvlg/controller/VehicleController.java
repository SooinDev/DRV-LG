package com.example.drvlg.controller;

import com.example.drvlg.service.VehicleService;
import com.example.drvlg.vo.VehicleVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/vehicles")
public class VehicleController {

  private final VehicleService vehicleService;

  @Autowired
  public VehicleController(VehicleService vehicleService) {
    this.vehicleService = vehicleService;
  }

  @PostMapping("/register")
  public ResponseEntity<String> registerVehicle(@RequestBody VehicleVO vehicleVO) {
    try {
      vehicleService.registerVehicle(vehicleVO);
      return ResponseEntity.ok("차량등록이 성공적으로 완료되었습니다.");
    } catch (Exception e) {
      return ResponseEntity.badRequest().body("차량등록에 실패했습니다: " + e.getMessage());
    }
  }
}
