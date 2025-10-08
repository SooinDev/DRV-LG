package com.example.drvlg.controller;

import com.example.drvlg.service.AlertService;
import com.example.drvlg.vo.AlertVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/vehicles/{vehicleId}/alerts")
public class AlertController {

  private final AlertService alertService;

  @Autowired
  public AlertController(AlertService alertService) {
    this.alertService = alertService;
  }

  @GetMapping
  public ResponseEntity<List<AlertVO>> getAllAlerts(@PathVariable Long vehicleId) {
    List<AlertVO> alertVOList = alertService.getAlertsForVehicle(vehicleId);
    return ResponseEntity.ok(alertVOList);
  }
}
