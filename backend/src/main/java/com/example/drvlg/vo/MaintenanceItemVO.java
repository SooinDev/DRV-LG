package com.example.drvlg.vo;

public class MaintenanceItemVO {

  /** 정비 항목 고유 ID */
  private Long itemId;

  /** 정비 항목 이름 */
  private String itemName;

  /** 추천 교체 주기 (km) */
  private Integer recommendedKm;

  /** 추천 교체 주기 (개월) */
  private Integer recommendedMonths;

  /** 항목 설명 */
  private String description;

  public Long getItemId() {
    return itemId;
  }

  public void setItemId(Long itemId) {
    this.itemId = itemId;
  }

  public String getItemName() {
    return itemName;
  }

  public void setItemName(String itemName) {
    this.itemName = itemName;
  }

  public Integer getRecommendedKm() {
    return recommendedKm;
  }

  public void setRecommendedKm(Integer recommendedKm) {
    this.recommendedKm = recommendedKm;
  }

  public Integer getRecommendedMonths() {
    return recommendedMonths;
  }

  public void setRecommendedMonths(Integer recommendedMonths) {
    this.recommendedMonths = recommendedMonths;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }
}
