package com.example.drvlg.vo;

import lombok.Data;

public class UserVO {

  /** 유저 이메일 (로그인 ID) */
  private String email;

  /** 유저 패스워드 */
  private String password;

  /** 유저 닉네임 */
  private String nickName;

  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }

  public String getPassword() {
    return password;
  }

  public void setPassword(String password) {
    this.password = password;
  }

  public String getNickName() {
    return nickName;
  }

  public void setNickName(String nickName) {
    this.nickName = nickName;
  }
}
