package com.example.drvlg.config.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.security.Key;
import java.util.Base64;
import java.util.Date;

@Component
public class JwtTokenProvider {

  @Value("${jwt.secret}")
  private String secretKey;
  private final long accessTokenValidTime = 30 * 60 * 1000L; // 30분
  private final long refreshTokenValidTime = 14 * 24 * 60 * 60 * 1000L; // 14일
  private Key key;

  private final UserDetailsService userDetailsService;

  @Autowired
  public JwtTokenProvider(UserDetailsService userDetailsService) {
    this.userDetailsService = userDetailsService;
  }

  @PostConstruct
  protected void init() {
    byte[] keyBytes = Base64.getEncoder().encode(secretKey.getBytes());
    this.key = Keys.hmacShaKeyFor(keyBytes);
  }

  public String createAccessToken(String userEmail) {
    Claims claims = Jwts.claims().setSubject(userEmail);
    Date now = new Date();
    return Jwts.builder()
            .setClaims(claims)
            .setIssuedAt(now)
            .setExpiration(new Date(now.getTime() + accessTokenValidTime))
            .signWith(key, SignatureAlgorithm.HS256)
            .compact();
  }

  public String createRefreshToken(String userEmail) {
    Claims claims = Jwts.claims().setSubject(userEmail);
    Date now = new Date();
    return Jwts.builder()
            .setClaims(claims)
            .setIssuedAt(now)
            .setExpiration(new Date(now.getTime() + refreshTokenValidTime))
            .signWith(key, SignatureAlgorithm.HS256)
            .compact();
  }

  public Date getRefreshTokenExpiryDate() {
    Date now = new Date();
    return new Date(now.getTime() + refreshTokenValidTime);
  }

  public Authentication getAuthentication(String token) {
    UserDetails userDetails = userDetailsService.loadUserByUsername(this.getUserEmail(token));
    return new UsernamePasswordAuthenticationToken(userDetails, "", userDetails.getAuthorities());
  }

  public String getUserEmail(String token) {
    return Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token).getBody().getSubject();
  }

  public boolean validateToken(String token) {
    try {
      Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token);
      return true;
    } catch (JwtException | IllegalArgumentException e) {
      return false;
    }
  }
}