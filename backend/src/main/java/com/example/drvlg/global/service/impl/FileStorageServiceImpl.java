package com.example.drvlg.global.service.impl;

import com.example.drvlg.global.service.FileStorageService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.PostConstruct;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Service
public class FileStorageServiceImpl implements FileStorageService {

  private final Path fileStorageLocation;

  public FileStorageServiceImpl(@Value("${file.upload.dir}") String uploadDir) {
    this.fileStorageLocation = Paths.get(uploadDir).toAbsolutePath().normalize();
  }

  @PostConstruct
  public void init() {
    try {
      Files.createDirectories(this.fileStorageLocation);
    } catch (Exception ex) {
      throw new RuntimeException("파일을 업로드할 디렉토리를 생성할 수 없습니다.", ex);
    }
  }

  @Override
  public String storeFile(MultipartFile file) {
    if (file == null || file.isEmpty()) {
      throw new RuntimeException("업로드할 파일을 선택해주세요.");
    }

    String originalFileName = StringUtils.cleanPath(file.getOriginalFilename());

    try {
      if (originalFileName.contains("..")) {
        throw new RuntimeException("파일명에 부적합한 문자가 포함되어 있습니다: " + originalFileName);
      }

      String fileExtension = "";
      try {
        fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
      } catch (Exception e) {
        fileExtension = "";
      }

      String uniqueFileName = UUID.randomUUID().toString() + fileExtension;

      Path targetLocation = this.fileStorageLocation.resolve(uniqueFileName);
      Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);

      return uniqueFileName;
    } catch (IOException ex) {
      throw new RuntimeException("파일 " + originalFileName + "을(를) 저장할 수 없습니다. 다시 시도해 주세요.", ex);
    }
  }
}
