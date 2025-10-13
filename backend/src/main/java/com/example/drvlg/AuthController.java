package com.example.drvlg;

import com.example.drvlg.config.jwt.JwtTokenProvider;
import com.example.drvlg.domain.user.service.UserService;
import com.example.drvlg.domain.user.vo.UserVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

  private final JwtTokenProvider jwtTokenProvider;
  private final UserService userService;

  @Autowired
  public AuthController(JwtTokenProvider jwtTokenProvider, UserService userService) {
    this.jwtTokenProvider = jwtTokenProvider;
    this.userService = userService;
  }

  @PostMapping("/reissue")
  public ResponseEntity<?> reissue(@RequestBody TokenRequestDTO tokenRequestDTO) {
    String refreshToken = tokenRequestDTO.getRefreshToken();

    if (refreshToken != null && jwtTokenProvider.validateToken(refreshToken)) {
      String userEmail = jwtTokenProvider.getUserEmail(refreshToken);
      UserVO user = userService.getUserByEmail(userEmail);

      if (user != null && refreshToken.equals(user.getRefreshToken())) {
        String newAccessToken = jwtTokenProvider.createAccessToken(userEmail);
        TokenDTO tokenDTO = new TokenDTO("Bearer", newAccessToken, refreshToken);
        return ResponseEntity.ok(tokenDTO);
      }
    }

    return ResponseEntity.badRequest().body("유효하지 않은 리프레시 토큰입니다.");
  }
}