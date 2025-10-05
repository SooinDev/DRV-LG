package com.example.drvlg.service;

import com.example.drvlg.vo.UserVO;

public interface UserService {

  void register(UserVO user);

  UserVO login(UserVO user);
}
