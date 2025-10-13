package com.example.drvlg.domain.alert.service;

import com.example.drvlg.domain.alert.vo.AlertVO;

import java.util.List;

public interface AlertService {

  List<AlertVO> getAlertsForVehicle(Long vehicleId);
}
