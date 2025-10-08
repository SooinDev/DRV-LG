package com.example.drvlg.vo;

public class StatsVO {

  /** 총 주유비 */
  private Long totalFuelCost;

  /** 총 정비비 */
  private Long totalMaintenanceCost;

  /** 총 지출 합계 */
  private Long totalSpending;

  public Long getTotalFuelCost() {
    return totalFuelCost;
  }

  public void setTotalFuelCost(Long totalFuelCost) {
    this.totalFuelCost = totalFuelCost;
  }

  public Long getTotalMaintenanceCost() {
    return totalMaintenanceCost;
  }

  public void setTotalMaintenanceCost(Long totalMaintenanceCost) {
    this.totalMaintenanceCost = totalMaintenanceCost;
  }

  public Long getTotalSpending() {
    return totalSpending;
  }

  public void setTotalSpending(Long totalSpending) {
    this.totalSpending = totalSpending;
  }
}
