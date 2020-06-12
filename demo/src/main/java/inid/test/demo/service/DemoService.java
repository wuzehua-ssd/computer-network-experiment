package inid.test.demo.service;

import inid.test.demo.dto.response.LoginResponse;

/**
 * @author wzh
 * @date 2020/6/4 20:29
 */
public interface DemoService {
    void reg(String userName, String pwd, int level);

    LoginResponse login(String userName, String pwd);
}
