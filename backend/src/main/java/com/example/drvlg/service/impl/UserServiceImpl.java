package com.example.drvlg.service.impl;

import com.example.drvlg.mapper.UserMapper;
import com.example.drvlg.service.UserService;
import com.example.drvlg.vo.UserVO;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {

  private final UserMapper userMapper;
  private final BCryptPasswordEncoder passwordEncoder;

  public UserServiceImpl(UserMapper userMapper, BCryptPasswordEncoder passwordEncoder) {
    this.userMapper = userMapper;
    this.passwordEncoder = passwordEncoder;
  }

  @Override
  public void register(UserVO user) {
    String encodedPassword = passwordEncoder.encode(user.getPassword());
    user.setPassword(encodedPassword);
    userMapper.insertUser(user);
  }

  @Override
  public UserVO login(UserVO user) {
    UserVO storedUser = userMapper.selectUserByEmail(user.getEmail());

    if (storedUser != null && passwordEncoder.matches(user.getPassword(), storedUser.getPassword())) {
      return storedUser;
    }

    return null;
  }
}