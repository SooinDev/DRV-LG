package com.example.drvlg.service;

import com.example.drvlg.vo.StatsVO;

public interface StatisticsService {

  StatsVO getMonthlySummary(Long vehicleId, int year, int month);
}
