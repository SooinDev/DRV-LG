package com.example.drvlg.vo;

import java.util.Date;

public class UserVO {

  /** 사용자 고유 ID */
  private Long userId;

  /** 사용자 이메일 (로그인 ID) */
  private String email;

  /** 사용자 패스워드 */
  private String password;

  /** 사용자 닉네임 */
  private String nickName;

  /** 사용자 회원가입일 */
  private Date createdAt;

  /** 사용자 수정일 */
  private Date updatedAt;

  /** 사용자 토큰 */
  private String refreshToken;

  /** 사용자 토큰 만료일 */
  private Date refreshTokenExpiresAt;

  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

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

  public String getRefreshToken() {
    return refreshToken;
  }

  public void setRefreshToken(String refreshToken) {
    this.refreshToken = refreshToken;
  }

  public Date getRefreshTokenExpiresAt() {
    return refreshTokenExpiresAt;
  }

  public void setRefreshTokenExpiresAt(Date refreshTokenExpiresAt) {
    this.refreshTokenExpiresAt = refreshTokenExpiresAt;
  }
}
