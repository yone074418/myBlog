package com.myblog.security;

import com.myblog.entity.User;
import com.myblog.mapper.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserDetailsServiceImpl implements UserDetailsService {

    private final UserMapper userMapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userMapper.selectOne(
                Wrappers.<User>lambdaQuery().eq(User::getUsername, username));
        if (user == null) {
            throw new UsernameNotFoundException("user not found: " + username);
        }
        return toUserDetails(user);
    }

    public UserDetails loadUserById(Long id) {
        User user = userMapper.selectById(id);
        if (user == null) {
            throw new UsernameNotFoundException("user not found: " + id);
        }
        return toUserDetails(user);
    }

    private UserDetails toUserDetails(User user) {
        String role = switch (user.getRole()) {
            case 0 -> "ROLE_ADMIN";
            case 1 -> "ROLE_BLOGGER";
            default -> "ROLE_USER";
        };
        return new org.springframework.security.core.userdetails.User(
                user.getId().toString(),
                user.getPassword(),
                user.getStatus() == 1,
                true, true, true,
                List.of(new SimpleGrantedAuthority(role))
        );
    }
}
