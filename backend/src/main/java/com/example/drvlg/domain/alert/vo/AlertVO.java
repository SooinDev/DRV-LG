package com.example.drvlg.domain.alert.vo;

import java.util.Date;

public class AlertVO {

  /**
   * 알림 상태를 나타내는 Enum
   * GOOD: 양호, WARN: 경고, DANGER: 위험
   */
  public enum Status {
    GOOD,
    WARN,
    DANGER
  }

  /** 정비 항목 이름 */
  private String itemName;

  /** 현재 알림 상태 */
  private Status status;

  /** 사용자에게 보여줄 메시지 */
  private String message;

  /** 마지막 교체일 */
  private Date lastReplacementDate;

  /** 마지막 교체 시 주행거리 */
  private Integer lastReplacementKm;

  /** 다음 교체 추천 주행거리 */
  private Integer nextRecommendedKm;

  public String getItemName() {
    return itemName;
  }

  public void setItemName(String itemName) {
    this.itemName = itemName;
  }

  public Status getStatus() {
    return status;
  }

  public void setStatus(Status status) {
    this.status = status;
  }

  public String getMessage() {
    return message;
  }

  public void setMessage(String message) {
    this.message = message;
  }

  public Date getLastReplacementDate() {
    return lastReplacementDate;
  }

  public void setLastReplacementDate(Date lastReplacementDate) {
    this.lastReplacementDate = lastReplacementDate;
  }

  public Integer getLastReplacementKm() {
    return lastReplacementKm;
  }

  public void setLastReplacementKm(Integer lastReplacementKm) {
    this.lastReplacementKm = lastReplacementKm;
  }

  public Integer getNextRecommendedKm() {
    return nextRecommendedKm;
  }

  public void setNextRecommendedKm(Integer nextRecommendedKm) {
    this.nextRecommendedKm = nextRecommendedKm;
  }
}