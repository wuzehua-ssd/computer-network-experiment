package inid.test.demo.dao;

import org.apache.ignite.Ignite;
import org.apache.ignite.IgniteCache;
import org.apache.ignite.Ignition;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;

/**
 * @author wzh
 * @date 2020/6/4 21:06
 */
@Component
public class TokenCache {

    @Resource(name = "igniteInstance")
    private Ignite ignite;

    public String getToken(String userId) {
        IgniteCache<String, String> igniteCache = ignite.getOrCreateCache("UserCache");
        return igniteCache.get(userId);
    }

    public void putToken(String userId, String token) {
        IgniteCache<String, String> igniteCache = ignite.getOrCreateCache("UserCache");
        igniteCache.put(userId, token);
    }
}
