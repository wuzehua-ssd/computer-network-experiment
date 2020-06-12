package inid.test.demo.service.Impl;

import inid.test.demo.User;
import inid.test.demo.dao.DemoDao;
import inid.test.demo.dao.TokenCache;
import inid.test.demo.dto.response.LoginResponse;
import inid.test.demo.service.DemoService;
import inid.test.demo.utils.JwtUtil;
import org.apache.ignite.Ignition;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import javax.annotation.Resource;

/**
 * @author wzh
 * @date 2020/6/4 20:29
 */
@Service
public class DemoServiceImpl implements DemoService {

    private static final Logger logger = LoggerFactory.getLogger(DemoService.class);
    @Autowired
    private DemoDao demoDao;

    @Autowired
    private TokenCache tokenCache;

    @Override
    public void reg(String userName, String pwd, int level) {
        User newUser = new User(userName, pwd, level);
        System.out.println(newUser.getUserName());
        try{
            demoDao.save(newUser.getId(), newUser);
        }catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public LoginResponse login(String userName, String pwd) {
        User user = null;
        //System.out.println(userName);
        try{
            logger.info("开始查询用户");
            System.out.println(userName);
            user = demoDao.findUserByUserName(userName);
            System.out.println(user.getUserName());
        }catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("登录失败，请重试");
        }

        if(StringUtils.isEmpty(user)) {
            logger.warn("无此用户");
            throw new RuntimeException("无此用户");
        }

        // 判断密码
        logger.info("成功查询用户");
        String password = user.getPassword();
        logger.info("开始判断密码");
        if(!password.equals(pwd)) {
            logger.warn("密码不正确");
            throw new RuntimeException("密码不正确");
        }

        String userId = getUserId(userName);

        String token = null;

        try {
            // 生成 token
            logger.info("生成token");
            token = JwtUtil.createToken(userId, user.getLevel());
            // token => ignite
            logger.info("缓存token");
            tokenCache.putToken(userId, token);
        }
        catch (Exception e) {
            e.printStackTrace();
            logger.info("登录失败，请重试");
            throw new RuntimeException("登录失败，请重试");
        }
        logger.info("登录成功");
        // ret token + userid
        return new LoginResponse(userId, token);
    }


    private String getUserId(String userName) {
        logger.info("加密前：" + userName);
        char [] chars = userName.toCharArray();
        String res = "";
        for(char c : chars) {
            res += c + 9;
        }
        logger.info("加密后：" + res);
        return res;
    }
}
