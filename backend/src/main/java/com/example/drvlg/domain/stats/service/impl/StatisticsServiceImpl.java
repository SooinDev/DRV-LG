package com.example.drvlg.domain.stats.service.impl;

import com.example.drvlg.domain.stats.mapper.StatisticsMapper;
import com.example.drvlg.domain.stats.service.StatisticsService;
import com.example.drvlg.domain.stats.vo.StatsVO;
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
