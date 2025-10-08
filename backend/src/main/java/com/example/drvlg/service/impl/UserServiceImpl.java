package com.example.drvlg.service.impl;

import com.example.drvlg.config.jwt.JwtTokenProvider;
import com.example.drvlg.mapper.UserMapper;
import com.example.drvlg.service.UserService;
import com.example.drvlg.vo.UserVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserServiceImpl implements UserService {

  private final UserMapper userMapper;
  private final PasswordEncoder passwordEncoder;
  private final JwtTokenProvider jwtTokenProvider;

  @Autowired
  public UserServiceImpl(UserMapper userMapper, PasswordEncoder passwordEncoder, JwtTokenProvider jwtTokenProvider) {
    this.userMapper = userMapper;
    this.passwordEncoder = passwordEncoder;
    this.jwtTokenProvider = jwtTokenProvider;
  }

  @Override
  public void register(UserVO user) {
    String encodedPassword = passwordEncoder.encode(user.getPassword());
    user.setPassword(encodedPassword);
    userMapper.insertUser(user);
  }

  @Override
  @Transactional
  public UserVO login(UserVO user) {
    UserVO storedUser = userMapper.selectUserByEmail(user.getEmail());

    if (storedUser != null && passwordEncoder.matches(user.getPassword(), storedUser.getPassword())) {
      String refreshToken = jwtTokenProvider.createRefreshToken(storedUser.getEmail());

      storedUser.setRefreshToken(refreshToken);
      storedUser.setRefreshTokenExpiresAt(jwtTokenProvider.getRefreshTokenExpiryDate());

      userMapper.updateRefreshToken(storedUser);

      return storedUser;
    }

    return null;
  }

  @Override
  public UserVO getUserByEmail(String email) {
    return userMapper.selectUserByEmail(email);
  }
}