package com.myblog.service.impl;

import com.myblog.common.exception.BusinessException;
import com.myblog.entity.Category;
import com.myblog.mapper.CategoryMapper;
import com.myblog.service.CategoryService;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CategoryServiceImpl implements CategoryService {

    private final CategoryMapper categoryMapper;

    @Override
    public List<Category> listAll() {
        return categoryMapper.selectList(
                Wrappers.<Category>lambdaQuery().orderByAsc(Category::getSortOrder));
    }

    @Override
    public Category getById(Long id) {
        Category category = categoryMapper.selectById(id);
        if (category == null) {
            throw new BusinessException(404, "category not found");
        }
        return category;
    }

    @Override
    public Category create(String name, String description) {
        if (categoryMapper.selectCount(
                Wrappers.<Category>lambdaQuery().eq(Category::getName, name)) > 0) {
            throw new BusinessException("category already exists");
        }
        Category category = new Category();
        category.setName(name);
        category.setDescription(description);
        categoryMapper.insert(category);
        return category;
    }

    @Override
    public void delete(Long id) {
        categoryMapper.deleteById(id);
    }
}
