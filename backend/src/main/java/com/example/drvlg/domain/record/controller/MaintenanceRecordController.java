package com.example.drvlg.domain.record.controller;

import com.example.drvlg.domain.record.service.MaintenanceRecordService;
import com.example.drvlg.domain.record.vo.MaintenanceRecordVO;
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
@RequestMapping("/api/vehicles/{vehicleId}/maintenance-records")
public class MaintenanceRecordController {

  private final MaintenanceRecordService maintenanceRecordService;
  private final UserService userService;

  @Autowired
  public MaintenanceRecordController(MaintenanceRecordService maintenanceRecordService, UserService userService) {
    this.maintenanceRecordService = maintenanceRecordService;
    this.userService = userService;
  }

  @PostMapping
  public ResponseEntity<String> insertMaintenanceRecord(@PathVariable Long vehicleId, @RequestBody MaintenanceRecordVO maintenanceRecord) {
    try {
      UserVO currentUser = getCurrentUser();
      maintenanceRecord.setVehicleId(vehicleId);
      maintenanceRecordService.insertMaintenanceRecord(maintenanceRecord, currentUser.getUserId());
      return ResponseEntity.ok("정비 기록이 성공적으로 등록되었습니다.");
    } catch (AccessDeniedException e) {
      return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
    } catch (Exception e) {
      return ResponseEntity.badRequest().body("정비 기록 등록에 실패했습니다: " + e.getMessage());
    }
  }

  @GetMapping
  public ResponseEntity<?> getMaintenanceRecordsByVehicleId(@PathVariable Long vehicleId) {
    try {
      UserVO currentUser = getCurrentUser();
      List<MaintenanceRecordVO> records = maintenanceRecordService.selectMaintenanceRecordsByVehicleId(vehicleId, currentUser.getUserId());
      return ResponseEntity.ok(records);
    } catch (AccessDeniedException e) {
      return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
    } catch (Exception e) {
      return ResponseEntity.badRequest().body(e.getMessage());
    }
  }

  @GetMapping("/{recordId}")
  public ResponseEntity<?> getMaintenanceRecordById(@PathVariable Long vehicleId, @PathVariable Long recordId) {
    try {
      UserVO currentUser = getCurrentUser();
      MaintenanceRecordVO record = maintenanceRecordService.selectMaintenanceRecordById(recordId, currentUser.getUserId());
      return ResponseEntity.ok(record);
    } catch (AccessDeniedException e) {
      return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
    } catch (Exception e) {
      return ResponseEntity.badRequest().body(e.getMessage());
    }
  }

  @PutMapping("/{recordId}")
  public ResponseEntity<String> updateMaintenanceRecord(@PathVariable Long vehicleId, @PathVariable Long recordId, @RequestBody MaintenanceRecordVO maintenanceRecord) {
    try {
      UserVO currentUser = getCurrentUser();
      maintenanceRecord.setMaintenanceRecordId(recordId);
      maintenanceRecord.setVehicleId(vehicleId);
      maintenanceRecordService.updateMaintenanceRecord(maintenanceRecord, currentUser.getUserId());
      return ResponseEntity.ok("정비 기록이 성공적으로 수정되었습니다.");
    } catch (AccessDeniedException e) {
      return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
    } catch (Exception e) {
      return ResponseEntity.badRequest().body("정비 기록 수정에 실패했습니다: " + e.getMessage());
    }
  }

  @DeleteMapping("/{recordId}")
  public ResponseEntity<String> deleteMaintenanceRecord(@PathVariable Long vehicleId, @PathVariable Long recordId) {
    try {
      UserVO currentUser = getCurrentUser();
      maintenanceRecordService.deleteMaintenanceRecord(recordId, currentUser.getUserId());
      return ResponseEntity.ok("정비 기록이 성공적으로 삭제되었습니다.");
    } catch (AccessDeniedException e) {
      return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
    } catch (Exception e) {
      return ResponseEntity.badRequest().body("정비 기록 삭제에 실패했습니다: " + e.getMessage());
    }
  }

  private UserVO getCurrentUser() {
    String userEmail = SecurityContextHolder.getContext().getAuthentication().getName();
    return userService.getUserByEmail(userEmail);
  }
}