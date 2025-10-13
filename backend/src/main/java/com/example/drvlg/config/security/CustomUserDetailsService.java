package com.example.drvlg.config.security;

import com.example.drvlg.domain.user.mapper.UserMapper;
import com.example.drvlg.domain.user.vo.UserVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;

@Service
public class CustomUserDetailsService implements UserDetailsService {

  private final UserMapper userMapper;

  @Autowired
  public CustomUserDetailsService(UserMapper userMapper) {
    this.userMapper = userMapper;
  }

  @Override
  public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
    UserVO user = userMapper.selectUserByEmail(email);
    if (user == null) {
      throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + email);
    }

    return new User(user.getEmail(), user.getPassword(), new ArrayList<>());
  }
}