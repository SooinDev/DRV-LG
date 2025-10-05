package com.example.drvlg.controller;

import com.example.drvlg.service.FuelRecordService;
import com.example.drvlg.vo.FuelRecordVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/vehicles/{vehicleId}/fuel-records")
public class FuelRecordController {

  private final FuelRecordService fuelRecordService;

  @Autowired
  public FuelRecordController(FuelRecordService fuelRecordService) {
    this.fuelRecordService = fuelRecordService;
  }

  @PostMapping
  public ResponseEntity<String> insertFuelRecord(@PathVariable Long vehicleId, @RequestBody FuelRecordVO fuelRecordVO) {
    try {
      fuelRecordVO.setVehicleId(vehicleId);
      fuelRecordService.insertFuelRecord(fuelRecordVO);
      return ResponseEntity.ok("주유 기록이 성공적으로 등록되었습니다.");
    } catch (Exception e) {
      return ResponseEntity.badRequest().body("주유 기록 등록에 실패했습니다: " + e.getMessage());
    }
  }

  @GetMapping
  public ResponseEntity<List<FuelRecordVO>> getFuelRecordsByVehicleId(@PathVariable Long vehicleId) {
    List<FuelRecordVO> records = fuelRecordService.selectFuelRecordsByVehicleId(vehicleId);
    return ResponseEntity.ok(records);
  }

  @GetMapping("/{recordId}")
  public ResponseEntity<FuelRecordVO> getFuelRecordById(@PathVariable Long vehicleId, @PathVariable Long recordId) {
    FuelRecordVO record = fuelRecordService.selectFuelRecordById(recordId);
    return ResponseEntity.ok(record);
  }

  @PutMapping("/{recordId}")
  public ResponseEntity<String> updateFuelRecord(@PathVariable Long vehicleId, @PathVariable Long recordId, @RequestBody FuelRecordVO fuelRecordVO) {
    try {
      fuelRecordVO.setRecordId(recordId);
      fuelRecordVO.setVehicleId(vehicleId);
      fuelRecordService.updateFuelRecord(fuelRecordVO);
      return ResponseEntity.ok("주유 기록이 성공적으로 수정되었습니다.");
    } catch (Exception e) {
      return ResponseEntity.badRequest().body("주유 기록 수정에 실패했습니다: " + e.getMessage());
    }
  }

  @DeleteMapping("/{recordId}")
  public ResponseEntity<String> deleteFuelRecord(@PathVariable Long vehicleId, @PathVariable Long recordId) {
    try {
      fuelRecordService.deleteFuelRecord(recordId);
      return ResponseEntity.ok("주유 기록이 성공적으로 삭제되었습니다.");
    } catch (Exception e) {
      return ResponseEntity.badRequest().body("주유 기록 삭제에 실패했습니다: " + e.getMessage());
    }
  }
}