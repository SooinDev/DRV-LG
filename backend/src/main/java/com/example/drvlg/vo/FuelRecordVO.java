package com.example.drvlg.vo;

import java.math.BigDecimal;
import java.util.Date;

public class FuelRecordVO {

  /** 기록 고유 ID */
  private Long recordId;

  /** 차량 고유 ID */
  private Long vehicleId;

  /** 주유 날짜 */
  private Date fuelDate;

  /** 주유 시점 주행거리(km) */
  private Integer odoMeter;

  /** 리터당 단가 */
  private Integer pricePerLiter;

  /** 주유량 (리터) */
  private BigDecimal liters;

  /** 총 주유 금액 */
  private Integer totalPrice;

  /** 메모 */
  private String memo;

  /** 등록일 */
  private Date createdAt;

  /** 수정일 */
  private Date updatedAt;

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

  public Integer getOdoMeter() {
    return odoMeter;
  }

  public void setOdoMeter(Integer odoMeter) {
    this.odoMeter = odoMeter;
  }

  public Integer getPricePerLiter() {
    return pricePerLiter;
  }

  public void setPricePerLiter(Integer pricePerLiter) {
    this.pricePerLiter = pricePerLiter;
  }

  public BigDecimal getLiters() {
    return liters;
  }

  public void setLiters(BigDecimal liters) {
    this.liters = liters;
  }

  public Integer getTotalPrice() {
    return totalPrice;
  }

  public void setTotalPrice(Integer totalPrice) {
    this.totalPrice = totalPrice;
  }

  public String getMemo() {
    return memo;
  }

  public void setMemo(String memo) {
    this.memo = memo;
  }

  public Date getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(Date createdAt) {
    this.createdAt = createdAt;
  }

  public Date getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(Date updatedAt) {
    this.updatedAt = updatedAt;
  }
}
