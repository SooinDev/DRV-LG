package com.example.drvlg.service;

import com.example.drvlg.vo.AlertVO;

import java.util.List;

public interface AlertService {

  List<AlertVO> getAlertsForVehicle(Long vehicleId);
}
