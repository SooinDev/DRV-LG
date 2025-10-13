package com.example.drvlg.domain.stats.service;

import com.example.drvlg.domain.stats.vo.StatsVO;

public interface StatisticsService {

  StatsVO getMonthlySummary(Long vehicleId, int year, int month);
}
