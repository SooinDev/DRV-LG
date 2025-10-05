package com.example.drvlg.vo;

import lombok.Data;

import java.util.Date;

@Data
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
}
