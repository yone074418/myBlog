package com.myblog.service;

import com.myblog.entity.Category;

import java.util.List;

public interface CategoryService {
    List<Category> listAll();
    Category getById(Long id);
    Category create(String name, String description);
    void delete(Long id);
}
