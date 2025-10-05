package com.example.drvlg.controller;

import com.example.drvlg.service.MaintenanceRecordService;
import com.example.drvlg.vo.MaintenanceRecordVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/vehicles/{vehicleId}/maintenance-records")
public class MaintenanceRecordController {

  private final MaintenanceRecordService maintenanceRecordService;

  @Autowired
  public MaintenanceRecordController(MaintenanceRecordService maintenanceRecordService) {
    this.maintenanceRecordService = maintenanceRecordService;
  }

  @PostMapping
  public ResponseEntity<String> insertMaintenanceRecord(@PathVariable Long vehicleId, @RequestBody MaintenanceRecordVO maintenanceRecordVO) {
    try {
      maintenanceRecordVO.setVehicleId(vehicleId);
      maintenanceRecordService.insertMaintenanceRecord(maintenanceRecordVO);
      return ResponseEntity.ok("정비 기록이 성공적으로 등록되었습니다.");
    } catch (Exception e) {
      return ResponseEntity.badRequest().body("정비 기록 등록에 실패했습니다: " + e.getMessage());
    }
  }

  @GetMapping
  public ResponseEntity<List<MaintenanceRecordVO>> getMaintenanceRecordsByVehicleId(@PathVariable Long vehicleId) {
    List<MaintenanceRecordVO> records = maintenanceRecordService.selectMaintenanceRecordsByVehicleId(vehicleId);
    return ResponseEntity.ok(records);
  }

  @GetMapping("/{recordId}")
  public ResponseEntity<MaintenanceRecordVO> getMaintenanceRecordById(@PathVariable Long vehicleId, @PathVariable Long recordId) {
    MaintenanceRecordVO record = maintenanceRecordService.selectMaintenanceRecordById(recordId);
    return ResponseEntity.ok(record);
  }

  @PutMapping("/{recordId}")
  public ResponseEntity<String> updateMaintenanceRecord(@PathVariable Long vehicleId, @PathVariable Long recordId, @RequestBody MaintenanceRecordVO maintenanceRecordVO) {
    try {
      maintenanceRecordVO.setMaintenanceRecordId(recordId);
      maintenanceRecordVO.setVehicleId(vehicleId);
      maintenanceRecordService.updateMaintenanceRecord(maintenanceRecordVO);
      return ResponseEntity.ok("정비 기록이 성공적으로 수정되었습니다.");
    } catch (Exception e) {
      return ResponseEntity.badRequest().body("정비 기록 수정에 실패했습니다: " + e.getMessage());
    }
  }

  @DeleteMapping("/{recordId}")
  public ResponseEntity<String> deleteMaintenanceRecord(@PathVariable Long vehicleId, @PathVariable Long recordId) {
    try {
      maintenanceRecordService.deleteMaintenanceRecord(recordId);
      return ResponseEntity.ok("정비 기록이 성공적으로 삭제되었습니다.");
    } catch (Exception e) {
      return ResponseEntity.badRequest().body("정비 기록 삭제에 실패했습니다: " + e.getMessage());
    }
  }
}
