package inid.test.demo;

import org.apache.ignite.cache.query.annotations.QuerySqlField;

import java.util.concurrent.atomic.AtomicLong;

/**
 * @author wzh
 * @date 2020/6/4 20:33
 */
public class User {
    private static final AtomicLong ID = new AtomicLong();

    @QuerySqlField(index = true)
    private Long id;

    @QuerySqlField(index = true)
    private String userName;

    @QuerySqlField
    private String password;

    @QuerySqlField
    private int level;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }


    public User(String userName, String pwd, int level) {
        this.id = ID.incrementAndGet();
        this.userName = userName;
        this.password = pwd;
        this.level = level;
    }
}
