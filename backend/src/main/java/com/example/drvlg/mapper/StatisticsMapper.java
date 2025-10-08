package com.example.drvlg.mapper;

import com.example.drvlg.vo.StatsVO;
import org.apache.ibatis.annotations.Param;

public interface StatisticsMapper {

  StatsVO selectMonthlySummary(@Param("vehicleId") Long vehicleId, @Param("year") int year, @Param("month") int month);

}