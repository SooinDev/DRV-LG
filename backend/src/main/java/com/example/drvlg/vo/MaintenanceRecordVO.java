package com.example.drvlg.vo;

import lombok.Data;

import java.util.Date;

public class MaintenanceRecordVO {

  /** 정비 기록 고유 ID */
  private Long maintenanceRecordId;

  /** 차량 고유 ID */
  private Long vehicleId;

  /** 정비 일자 */
  private Date maintenanceDate;

  /** 정비 시 주행 기록 */
  private Integer odoMeter;

  /** 정비 내역 */
  private String item;

  /** 정비 비용 */
  private Integer totalCost;

  /** 정비 메모 */
  private String memo;

  /** 정비 기록 생성일자 */
  private Date createAt;

  /** 정비 기록 수정일자 */
  private Date updateAt;

  public Long getMaintenanceRecordId() {
    return maintenanceRecordId;
  }

  public void setMaintenanceRecordId(Long maintenanceRecordId) {
    this.maintenanceRecordId = maintenanceRecordId;
  }

  public Long getVehicleId() {
    return vehicleId;
  }

  public void setVehicleId(Long vehicleId) {
    this.vehicleId = vehicleId;
  }

  public Date getMaintenanceDate() {
    return maintenanceDate;
  }

  public void setMaintenanceDate(Date maintenanceDate) {
    this.maintenanceDate = maintenanceDate;
  }

  public Integer getOdoMeter() {
    return odoMeter;
  }

  public void setOdoMeter(Integer odoMeter) {
    this.odoMeter = odoMeter;
  }

  public String getItem() {
    return item;
  }

  public void setItem(String item) {
    this.item = item;
  }

  public Integer getTotalCost() {
    return totalCost;
  }

  public void setTotalCost(Integer totalCost) {
    this.totalCost = totalCost;
  }

  public String getMemo() {
    return memo;
  }

  public void setMemo(String memo) {
    this.memo = memo;
  }

  public Date getCreateAt() {
    return createAt;
  }

  public void setCreateAt(Date createAt) {
    this.createAt = createAt;
  }

  public Date getUpdateAt() {
    return updateAt;
  }

  public void setUpdateAt(Date updateAt) {
    this.updateAt = updateAt;
  }
}
