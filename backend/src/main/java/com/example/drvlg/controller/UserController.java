package com.example.drvlg.controller;

import com.example.drvlg.config.jwt.JwtTokenProvider;
import com.example.drvlg.service.UserService;
import com.example.drvlg.vo.UserVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collections;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
public class UserController {

  private final UserService userService;
  private final JwtTokenProvider jwtTokenProvider;

  @Autowired
  public UserController(UserService userService, JwtTokenProvider jwtTokenProvider) {
    this.userService = userService;
    this.jwtTokenProvider = jwtTokenProvider;
  }

  @PostMapping("/register")
  public ResponseEntity<String> register(@RequestBody UserVO userVO) {
    try {
      userService.register(userVO);
      return ResponseEntity.ok("회원가입이 성공적으로 완료되었습니다.");
    } catch (Exception e) {
      return ResponseEntity.badRequest().body("회원가입에 실패했습니다: " + e.getMessage());
    }
  }

  @PostMapping("/login")
  public ResponseEntity<?> login(@RequestBody UserVO userVO) {
    UserVO loginUser = userService.login(userVO);

    if (loginUser != null) {
      String token = jwtTokenProvider.createToken(loginUser.getEmail());
      Map<String, String> response = Collections.singletonMap("token", token);
      return ResponseEntity.ok(response);
    } else {
      return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인에 실패했습니다.");
    }
  }
}