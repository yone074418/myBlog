package com.myblog.common.constant;

public interface AppConstant {
    int ARTICLE_STATUS_DRAFT = 0;
    int ARTICLE_STATUS_PUBLISHED = 1;
    int ARTICLE_STATUS_SCHEDULED = 2;
    int ARTICLE_STATUS_BANNED = 3;

    int USER_ROLE_ADMIN = 0;
    int USER_ROLE_BLOGGER = 1;
    int USER_ROLE_USER = 2;

    int ACTION_LIKE = 1;
    int ACTION_COLLECT = 2;
    int ACTION_FOLLOW = 3;

    int MSG_SYSTEM = 1;
    int MSG_LIKE = 2;
    int MSG_COMMENT = 3;
    int MSG_FOLLOWER = 4;
}
