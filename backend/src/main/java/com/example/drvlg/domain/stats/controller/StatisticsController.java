package com.example.drvlg.domain.stats.controller;

import com.example.drvlg.domain.stats.service.StatisticsService;
import com.example.drvlg.domain.stats.vo.StatsVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/stats")
public class StatisticsController {

  private final StatisticsService statisticsService;

  @Autowired
  public StatisticsController(StatisticsService statisticsService) {
    this.statisticsService = statisticsService;
  }

  @GetMapping("/summary/monthly")
  public ResponseEntity<StatsVO> getMonthlySummary(@RequestParam Long vehicleId, @RequestParam int year, @RequestParam int month) {
    StatsVO statsVO = statisticsService.getMonthlySummary(vehicleId, year, month);
    return ResponseEntity.ok(statsVO);
  }

}
