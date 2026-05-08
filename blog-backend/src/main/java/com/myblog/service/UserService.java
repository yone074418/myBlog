package com.myblog.service;

import com.myblog.dto.LoginRequest;
import com.myblog.dto.RegisterRequest;
import com.myblog.entity.User;

import java.util.Map;

public interface UserService {
    Map<String, Object> login(LoginRequest request);
    User register(RegisterRequest request);
    User getById(Long id);
    User getCurrentUser();
}
