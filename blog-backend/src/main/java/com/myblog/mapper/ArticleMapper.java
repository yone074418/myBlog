package com.myblog.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.myblog.entity.Article;
import org.apache.ibatis.annotations.Update;

public interface ArticleMapper extends BaseMapper<Article> {

    @Update("UPDATE blog_article SET view_count = view_count + 1 WHERE id = #{articleId}")
    int incrementViewCount(Long articleId);
}
