package com.example.drvlg.service;

import com.example.drvlg.vo.UserVO;

public interface UserService {

  void register(UserVO user);

  String login(UserVO user);

  UserVO getUserByEmail(String email);

}
