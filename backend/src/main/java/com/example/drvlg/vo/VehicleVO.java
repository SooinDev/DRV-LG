package com.example.drvlg.vo;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.Date;

public class VehicleVO {

  /** 차량 고유 ID */
  private Long vehicleId;

  /** 유저 고유 ID */
  private Long userId;

  /** 차량 번호 */
  @JsonProperty("number")
  private String licensePlate;

  /** 차량 브랜드 */
  @JsonProperty("maker")
  private String make;

  /** 차량 모델 */
  private String model;

  /** 차량 연식 */
  private Integer year;

  /** 차량 별칭 */
  private String nickName;

  /** 차량 최초 등록 시 주행거리 */
  @JsonProperty("initOdo")
  private Integer initialOdometer;

  /** 현재 주행거리 (최신 기록 기준) */
  private Integer currentOdometer;

  /** 차량 등록일 */
  @JsonProperty("registerDate")
  private Date createdAt;

  /** 차량 수정일 */
  @JsonProperty("updateDate")
  private Date updatedAt;

  /** 차량 이미지 경로 */
  private String imageUrl;

  public Long getVehicleId() {
    return vehicleId;
  }

  public void setVehicleId(Long vehicleId) {
    this.vehicleId = vehicleId;
  }

  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

  public String getLicensePlate() {
    return licensePlate;
  }

  public void setLicensePlate(String licensePlate) {
    this.licensePlate = licensePlate;
  }

  public String getMake() {
    return make;
  }

  public void setMake(String make) {
    this.make = make;
  }

  public String getModel() {
    return model;
  }

  public void setModel(String model) {
    this.model = model;
  }

  public Integer getYear() {
    return year;
  }

  public void setYear(Integer year) {
    this.year = year;
  }

  public String getNickName() {
    return nickName;
  }

  public void setNickName(String nickName) {
    this.nickName = nickName;
  }

  public Integer getInitialOdometer() {
    return initialOdometer;
  }

  public void setInitialOdometer(Integer initialOdometer) {
    this.initialOdometer = initialOdometer;
  }

  public Integer getCurrentOdometer() {
    return currentOdometer;
  }

  public void setCurrentOdometer(Integer currentOdometer) {
    this.currentOdometer = currentOdometer;
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

  public String getImageUrl() {
    return imageUrl;
  }

  public void setImageUrl(String imageUrl) {
    this.imageUrl = imageUrl;
  }
}