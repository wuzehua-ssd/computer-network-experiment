package inid.test.demo.dao;

import inid.test.demo.User;
import org.apache.ignite.springdata.repository.IgniteRepository;
import org.apache.ignite.springdata.repository.config.Query;
import org.apache.ignite.springdata.repository.config.RepositoryConfig;

/**
 * @author wzh
 * @date 2020/6/4 20:45
 */
@RepositoryConfig(cacheName="UserCache")
public interface DemoDao extends IgniteRepository<User, Long> {

    User findUserByUserName(String userName);
}
