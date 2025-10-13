package com.example.drvlg.domain.stats.mapper;

import com.example.drvlg.domain.stats.vo.StatsVO;
import org.apache.ibatis.annotations.Param;

public interface StatisticsMapper {

  StatsVO selectMonthlySummary(@Param("vehicleId") Long vehicleId, @Param("year") int year, @Param("month") int month);

}