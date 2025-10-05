package com.example.drvlg.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
public class FuelRecordVO {

  /** 기록 고유 ID */
  private Long recordId;

  /** 차량 고유 ID */
  private Long vehicleId;

  /** 주유 날짜 */
  private Date fuelDate;

  /** 주유량 */
  private BigDecimal fuelAmount;
}
