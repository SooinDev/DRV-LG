package com.example.drvlg.domain.user.service;

import com.example.drvlg.domain.user.vo.UserVO;

public interface UserService {

  void register(UserVO user);

  UserVO login(UserVO user);

  UserVO getUserByEmail(String email);

}
