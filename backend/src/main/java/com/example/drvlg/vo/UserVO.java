package com.example.drvlg.vo;

import lombok.Data;

@Data
public class UserVO {

  /** 유저 이메일 (로그인 ID) */
  private String email;

  /** 유저 패스워드 */
  private String pswd;

  /** 유저 닉네임 */
  private String ncknm;
}
