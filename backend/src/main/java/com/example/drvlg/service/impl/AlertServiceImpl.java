package com.example.drvlg.service.impl;

import com.example.drvlg.mapper.MaintenanceItemMapper;
import com.example.drvlg.mapper.MaintenanceRecordMapper;
import com.example.drvlg.mapper.VehicleMapper;
import com.example.drvlg.service.AlertService;
import com.example.drvlg.vo.AlertVO;
import com.example.drvlg.vo.MaintenanceItemVO;
import com.example.drvlg.vo.MaintenanceRecordVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class AlertServiceImpl implements AlertService {

  private final MaintenanceItemMapper maintenanceItemMapper;
  private final VehicleMapper vehicleMapper;
  private final MaintenanceRecordMapper maintenanceRecordMapper;

  @Autowired
  public AlertServiceImpl(MaintenanceItemMapper maintenanceItemMapper, VehicleMapper vehicleMapper, MaintenanceRecordMapper maintenanceRecordMapper) {
    this.maintenanceItemMapper = maintenanceItemMapper;
    this.vehicleMapper = vehicleMapper;
    this.maintenanceRecordMapper = maintenanceRecordMapper;
  }

  @Override
  public List<AlertVO> getAlertsForVehicle(Long vehicleId) {
    List<AlertVO> alerts = new ArrayList<>();
    List<MaintenanceItemVO> allItems = maintenanceItemMapper.selectAllItems();
    Integer currentOdometer = vehicleMapper.selectLatestOdometer(vehicleId);

    if (currentOdometer == null) {
      currentOdometer = 0;
    }

    for (MaintenanceItemVO item : allItems) {
      MaintenanceRecordVO lastRecord = maintenanceRecordMapper.selectLatestRecordByItemName(vehicleId, item.getItemName());
      AlertVO alert = new AlertVO();
      alert.setItemName(item.getItemName());

      Integer recommendedKm = item.getRecommendedKm();
      if (recommendedKm == null) {
        continue;
      }

      if (lastRecord == null) {
        int remainingKm = recommendedKm - currentOdometer;
        if (remainingKm <= 0) {
          alert.setStatus(AlertVO.Status.DANGER);
          alert.setMessage("첫 점검 시기가 " + Math.abs(remainingKm) + "km 지났습니다. 점검이 필요합니다.");
        } else if (remainingKm <= 2000) {
          alert.setStatus(AlertVO.Status.WARN);
          alert.setMessage("첫 점검까지 약 " + remainingKm + "km 남았습니다.");
        } else {
          alert.setStatus(AlertVO.Status.GOOD);
          alert.setMessage("첫 점검까지 " + remainingKm + "km 이상 남아 안심입니다.");
        }
        alert.setNextRecommendedKm(recommendedKm);

      } else {
        alert.setLastReplacementDate(lastRecord.getMaintenanceDate());
        alert.setLastReplacementKm(lastRecord.getOdometer());

        int nextRecommendedKm = lastRecord.getOdometer() + recommendedKm;
        alert.setNextRecommendedKm(nextRecommendedKm);

        int remainingKm = nextRecommendedKm - currentOdometer;

        if (remainingKm <= 0) {
          alert.setStatus(AlertVO.Status.DANGER);
          alert.setMessage("교체 시기가 " + Math.abs(remainingKm) + "km 지났습니다. 점검이 필요합니다.");
        } else if (remainingKm <= 2000) {
          alert.setStatus(AlertVO.Status.WARN);
          alert.setMessage("다음 교체까지 약 " + remainingKm + "km 남았습니다.");
        } else {
          alert.setStatus(AlertVO.Status.GOOD);
          alert.setMessage("다음 교체까지 " + remainingKm + "km 이상 남아 양호합니다.");
        }
      }
      alerts.add(alert);
    }
    return alerts;
  }
}