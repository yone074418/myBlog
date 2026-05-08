package com.myblog.service.impl;

import com.myblog.common.exception.BusinessException;
import com.myblog.entity.Tag;
import com.myblog.mapper.TagMapper;
import com.myblog.service.TagService;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TagServiceImpl implements TagService {

    private final TagMapper tagMapper;

    @Override
    public List<Tag> listAll() {
        return tagMapper.selectList(null);
    }

    @Override
    public Tag getById(Long id) {
        Tag tag = tagMapper.selectById(id);
        if (tag == null) {
            throw new BusinessException(404, "tag not found");
        }
        return tag;
    }

    @Override
    public Tag create(String name, String color) {
        if (tagMapper.selectCount(
                Wrappers.<Tag>lambdaQuery().eq(Tag::getName, name)) > 0) {
            throw new BusinessException("tag already exists");
        }
        Tag tag = new Tag();
        tag.setName(name);
        tag.setColor(color != null ? color : "#3B82F6");
        tagMapper.insert(tag);
        return tag;
    }

    @Override
    public void delete(Long id) {
        tagMapper.deleteById(id);
    }
}
