package com.example.drvlg.domain.record.mapper;

import com.example.drvlg.domain.record.vo.MaintenanceItemVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface MaintenanceItemMapper {
  List<MaintenanceItemVO> selectAllItems();
}
