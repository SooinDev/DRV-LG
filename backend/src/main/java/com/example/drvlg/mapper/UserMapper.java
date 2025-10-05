package com.example.drvlg.mapper;

import com.example.drvlg.vo.UserVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper {

  void insertUser(UserVO user);

  UserVO selectUserByEmail(String email);
}