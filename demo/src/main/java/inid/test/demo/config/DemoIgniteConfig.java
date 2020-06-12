package inid.test.demo.config;

import inid.test.demo.User;
import org.apache.ignite.Ignite;
import org.apache.ignite.Ignition;
import org.apache.ignite.configuration.CacheConfiguration;
import org.apache.ignite.configuration.IgniteConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @author wzh
 * @date 2020/6/4 20:43
 */
@Configuration
public class DemoIgniteConfig {
    /**
     * Creating Apache Ignite instance bean. A bean will be passed
     * to IgniteRepositoryFactoryBean to initialize all Ignite based Spring Data      * repositories and connect to a cluster.
     */
    @Bean
    public Ignite igniteInstance() {
        // 配置一个节点的Configuration
        IgniteConfiguration cfg = new IgniteConfiguration();

        // 设置该节点名称
        cfg.setIgniteInstanceName("springDataNode");

        // 启用Peer类加载器
        cfg.setPeerClassLoadingEnabled(true);

        // 创建一个Cache的配置，名称为 UserCache
        CacheConfiguration ccfg = new CacheConfiguration("UserCache");

        // 设置这个Cache的键值对模型
        ccfg.setIndexedTypes(Long.class, User.class);


        // 把这个Cache放入springDataNode这个Node中
        cfg.setCacheConfiguration(ccfg);

        // 启动这个节点
        return Ignition.start(cfg);
    }
}
