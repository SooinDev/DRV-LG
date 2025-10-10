package com.example.drvlg.controller;

import com.example.drvlg.service.UserService;
import com.example.drvlg.service.VehicleService;
import com.example.drvlg.vo.UserVO;
import com.example.drvlg.vo.VehicleVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/vehicles")
public class VehicleController {

  private final VehicleService vehicleService;
  private final UserService userService;

  @Autowired
  public VehicleController(VehicleService vehicleService, UserService userService) {
    this.vehicleService = vehicleService;
    this.userService = userService;
  }

  @PostMapping
  public ResponseEntity<String> registerVehicle(@RequestBody VehicleVO vehicle) {
    try {
      UserVO currentUser = getCurrentUser();
      vehicle.setUserId(currentUser.getUserId());

      vehicleService.registerVehicle(vehicle);
      return ResponseEntity.ok("차량 등록이 성공적으로 완료되었습니다.");
    } catch (Exception e) {
      return ResponseEntity.badRequest().body("차량 등록에 실패했습니다: " + e.getMessage());
    }
  }

  @GetMapping
  public ResponseEntity<List<VehicleVO>> getMyVehicles() {
    UserVO currentUser = getCurrentUser();
    List<VehicleVO> vehicles = vehicleService.getVehiclesByUserId(currentUser.getUserId());
    return ResponseEntity.ok(vehicles);
  }

  @PutMapping("/{vehicleId}")
  public ResponseEntity<String> updateVehicle(@PathVariable Long vehicleId, @RequestBody VehicleVO vehicle) {
    try {
      UserVO currentUser = getCurrentUser();
      vehicle.setVehicleId(vehicleId);

      vehicleService.updateVehicle(vehicle, currentUser.getUserId());
      return ResponseEntity.ok("차량 정보가 성공적으로 수정되었습니다.");
    } catch (AccessDeniedException e) {
      return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
    } catch (Exception e) {
      return ResponseEntity.badRequest().body("차량 정보 수정에 실패했습니다: " + e.getMessage());
    }
  }

  @DeleteMapping("/{vehicleId}")
  public ResponseEntity<String> deleteVehicle(@PathVariable Long vehicleId) {
    try {
      UserVO currentUser = getCurrentUser();
      vehicleService.deleteVehicle(vehicleId, currentUser.getUserId());
      return ResponseEntity.ok("차량이 성공적으로 삭제되었습니다.");
    } catch (AccessDeniedException e) {
      return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
    } catch (Exception e) {
      return ResponseEntity.badRequest().body("차량 삭제에 실패했습니다: " + e.getMessage());
    }
  }

  private UserVO getCurrentUser() {
    String userEmail = SecurityContextHolder.getContext().getAuthentication().getName();
    return userService.getUserByEmail(userEmail);
  }
}