package com.example.drvlg.service.impl;

import com.example.drvlg.mapper.StatisticsMapper;
import com.example.drvlg.service.StatisticsService;
import com.example.drvlg.vo.StatsVO;
import org.springframework.stereotype.Service;

@Service
public class StatisticsServiceImpl implements StatisticsService {

  private final StatisticsMapper statisticsMapper;

  public StatisticsServiceImpl(StatisticsMapper statisticsMapper) {
    this.statisticsMapper = statisticsMapper;
  }

  @Override
  public StatsVO getMonthlySummary(Long vehicleId, int year, int month) {
    StatsVO statsVO = statisticsMapper.selectMonthlySummary(vehicleId, year, month);

    if (statsVO != null) {
      Long total = statsVO.getTotalFuelCost() + statsVO.getTotalMaintenanceCost();
      statsVO.setTotalSpending(total);
    }

    return statsVO;
  }
}
