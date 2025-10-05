package com.example.drvlg.service.impl;

import com.example.drvlg.mapper.UserMapper;
import com.example.drvlg.service.UserService;
import com.example.drvlg.vo.UserVO;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {

  private UserMapper userMapper;
  private BCryptPasswordEncoder passwordEncoder;

  @Override
  public void register(UserVO user) {
    String encodedPassword = passwordEncoder.encode(user.getPswd());
    user.setPswd(encodedPassword);
    userMapper.insertUser(user);
  }

  @Override
  public UserVO login(UserVO user) {
    UserVO storedUser = userMapper.selectUserByEmail(user.getEmail());

    if (storedUser != null && passwordEncoder.matches(user.getPswd(), storedUser.getPswd())) {
      return storedUser;
    }

    return null;
  }
}