package com.example.drvlg.vo;

import lombok.Data;
import java.util.Date;

public class VehicleVO {

  /** 차량 고유 ID */
  private Long vehicleId;

  /** 유저 고유 ID */
  private Long usrId;

  /** 차량 번호 */
  private String number;

  /** 차량 브랜드 */
  private String maker;

  /** 차량 모델 */
  private String model;

  /** 차량 연식 */
  private Integer year;

  /** 차량 별칭 */
  private String nickName;

  /** 차량 최초 등록 시 주행거리 */
  private Integer initOdo;

  /** 차량 등록일 */
  private Date registerDate;

  /** 차량 수정일 */
  private Date updateDate;

  public Long getVehicleId() {
    return vehicleId;
  }

  public void setVehicleId(Long vehicleId) {
    this.vehicleId = vehicleId;
  }

  public Long getUsrId() {
    return usrId;
  }

  public void setUsrId(Long usrId) {
    this.usrId = usrId;
  }

  public String getNumber() {
    return number;
  }

  public void setNumber(String number) {
    this.number = number;
  }

  public String getMaker() {
    return maker;
  }

  public void setMaker(String maker) {
    this.maker = maker;
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

  public Integer getInitOdo() {
    return initOdo;
  }

  public void setInitOdo(Integer initOdo) {
    this.initOdo = initOdo;
  }

  public Date getRegisterDate() {
    return registerDate;
  }

  public void setRegisterDate(Date registerDate) {
    this.registerDate = registerDate;
  }

  public Date getUpdateDate() {
    return updateDate;
  }

  public void setUpdateDate(Date updateDate) {
    this.updateDate = updateDate;
  }
}