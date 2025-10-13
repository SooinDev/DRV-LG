package com.example.drvlg.domain.record.controller;

import com.example.drvlg.domain.record.service.FuelRecordService;
import com.example.drvlg.domain.record.vo.FuelRecordVO;
import com.example.drvlg.domain.user.service.UserService;
import com.example.drvlg.domain.user.vo.UserVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/vehicles/{vehicleId}/fuel-records")
public class FuelRecordController {

  private final FuelRecordService fuelRecordService;
  private final UserService userService;

  @Autowired
  public FuelRecordController(FuelRecordService fuelRecordService, UserService userService) {
    this.fuelRecordService = fuelRecordService;
    this.userService = userService;
  }

  @PostMapping
  public ResponseEntity<String> insertFuelRecord(@PathVariable Long vehicleId, @RequestBody FuelRecordVO fuelRecord) {
    try {
      UserVO currentUser = getCurrentUser();
      fuelRecord.setVehicleId(vehicleId);
      fuelRecordService.insertFuelRecord(fuelRecord, currentUser.getUserId());
      return ResponseEntity.ok("주유 기록이 성공적으로 등록되었습니다.");
    } catch (AccessDeniedException e) {
      return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
    } catch (Exception e) {
      return ResponseEntity.badRequest().body("주유 기록 등록에 실패했습니다: " + e.getMessage());
    }
  }

  @GetMapping
  public ResponseEntity<?> getFuelRecordsByVehicleId(@PathVariable Long vehicleId) {
    try {
      UserVO currentUser = getCurrentUser();
      List<FuelRecordVO> records = fuelRecordService.selectFuelRecordsByVehicleId(vehicleId, currentUser.getUserId());
      return ResponseEntity.ok(records);
    } catch (AccessDeniedException e) {
      return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
    } catch (Exception e) {
      return ResponseEntity.badRequest().body(e.getMessage());
    }
  }

  @GetMapping("/{recordId}")
  public ResponseEntity<?> getFuelRecordById(@PathVariable Long vehicleId, @PathVariable Long recordId) {
    try {
      UserVO currentUser = getCurrentUser();
      FuelRecordVO record = fuelRecordService.selectFuelRecordById(recordId, currentUser.getUserId());
      return ResponseEntity.ok(record);
    } catch (AccessDeniedException e) {
      return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
    } catch (Exception e) {
      return ResponseEntity.badRequest().body(e.getMessage());
    }
  }

  @PutMapping("/{recordId}")
  public ResponseEntity<String> updateFuelRecord(@PathVariable Long vehicleId, @PathVariable Long recordId, @RequestBody FuelRecordVO fuelRecord) {
    try {
      UserVO currentUser = getCurrentUser();
      fuelRecord.setRecordId(recordId);
      fuelRecord.setVehicleId(vehicleId);
      fuelRecordService.updateFuelRecord(fuelRecord, currentUser.getUserId());
      return ResponseEntity.ok("주유 기록이 성공적으로 수정되었습니다.");
    } catch (AccessDeniedException e) {
      return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
    } catch (Exception e) {
      return ResponseEntity.badRequest().body("주유 기록 수정에 실패했습니다: " + e.getMessage());
    }
  }

  @DeleteMapping("/{recordId}")
  public ResponseEntity<String> deleteFuelRecord(@PathVariable Long vehicleId, @PathVariable Long recordId) {
    try {
      UserVO currentUser = getCurrentUser();
      fuelRecordService.deleteFuelRecord(recordId, currentUser.getUserId());
      return ResponseEntity.ok("주유 기록이 성공적으로 삭제되었습니다.");
    } catch (AccessDeniedException e) {
      return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
    } catch (Exception e) {
      return ResponseEntity.badRequest().body("주유 기록 삭제에 실패했습니다: " + e.getMessage());
    }
  }

  private UserVO getCurrentUser() {
    String userEmail = SecurityContextHolder.getContext().getAuthentication().getName();
    return userService.getUserByEmail(userEmail);
  }
}