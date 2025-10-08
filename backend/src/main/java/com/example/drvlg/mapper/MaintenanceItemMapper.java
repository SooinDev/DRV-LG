package com.example.drvlg.mapper;

import com.example.drvlg.vo.MaintenanceItemVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface MaintenanceItemMapper {
  List<MaintenanceItemVO> selectAllItems();
}
