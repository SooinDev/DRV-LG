package com.example.drvlg.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

public class FuelRecordVO {

  /** 기록 고유 ID */
  private Long recordId;

  /** 차량 고유 ID */
  private Long vehicleId;

  /** 주유 날짜 */
  private Date fuelDate;

  /** 주유량 */
  private BigDecimal fuelAmount;

  public Long getRecordId() {
    return recordId;
  }

  public void setRecordId(Long recordId) {
    this.recordId = recordId;
  }

  public Long getVehicleId() {
    return vehicleId;
  }

  public void setVehicleId(Long vehicleId) {
    this.vehicleId = vehicleId;
  }

  public Date getFuelDate() {
    return fuelDate;
  }

  public void setFuelDate(Date fuelDate) {
    this.fuelDate = fuelDate;
  }

  public BigDecimal getFuelAmount() {
    return fuelAmount;
  }

  public void setFuelAmount(BigDecimal fuelAmount) {
    this.fuelAmount = fuelAmount;
  }
}
