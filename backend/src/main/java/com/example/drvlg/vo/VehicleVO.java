package com.example.drvlg.vo;

import lombok.Data;
import java.util.Date;

@Data
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
}