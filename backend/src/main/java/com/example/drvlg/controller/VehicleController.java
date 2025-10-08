package com.example.drvlg.controller;

import com.example.drvlg.service.UserService;
import com.example.drvlg.service.VehicleService;
import com.example.drvlg.vo.UserVO;
import com.example.drvlg.vo.VehicleVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.nio.file.AccessDeniedException;
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
      String userEmail = SecurityContextHolder.getContext().getAuthentication().getName();
      UserVO currentUser = userService.getUserByEmail(userEmail);

      vehicle.setUserId(currentUser.getUserId());

      vehicleService.registerVehicle(vehicle);
      return ResponseEntity.ok("차량 등록이 성공적으로 완료되었습니다.");
    } catch (Exception e) {
      return ResponseEntity.badRequest().body("차량 등록에 실패했습니다: " + e.getMessage());
    }
  }

  @GetMapping
  public ResponseEntity<List<VehicleVO>> getMyVehicles() {
    String userEmail = SecurityContextHolder.getContext().getAuthentication().getName();
    UserVO currentUser = userService.getUserByEmail(userEmail);

    List<VehicleVO> vehicles = vehicleService.getVehiclesByUserId(currentUser.getUserId());
    return ResponseEntity.ok(vehicles);
  }

  @DeleteMapping("/{vehicleId}")
  public ResponseEntity<String> deleteVehicle(@PathVariable Long vehicleId) {
    try {
      String userEmail = SecurityContextHolder.getContext().getAuthentication().getName();
      UserVO currentUser = userService.getUserByEmail(userEmail);

      vehicleService.deleteVehicle(vehicleId, currentUser.getUserId());

      return ResponseEntity.ok("차량이 성공적으로 삭제되었습니다.");
    } catch (AccessDeniedException e) {
      return ResponseEntity.status(HttpStatus.FORBIDDEN).body("삭제할 권한이 없습니다.");
    } catch (Exception e) {
      return ResponseEntity.badRequest().body("차량 삭제에 실패했습니다: " + e.getMessage());
    }
  }

  @PutMapping("/{vehicleId}")
  public ResponseEntity<String> updateVehicle(@PathVariable Long vehicleId, @RequestBody VehicleVO vehicle) {
    try {
      String userEmail = SecurityContextHolder.getContext().getAuthentication().getName();
      UserVO currentUser = userService.getUserByEmail(userEmail);

      vehicle.setVehicleId(vehicleId);

      vehicleService.updateVehicle(vehicle, currentUser.getUserId());

      return ResponseEntity.ok("차량 정보가 성공적으로 수정되었습니다.");
    } catch (AccessDeniedException e) {
      return ResponseEntity.status(HttpStatus.FORBIDDEN).body("수정할 권한이 없습니다.");
    } catch (Exception e) {
      return ResponseEntity.badRequest().body("차량 정보 수정에 실패했습니다: " + e.getMessage());
    }
  }
}
