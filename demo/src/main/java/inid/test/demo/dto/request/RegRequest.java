package inid.test.demo.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * @author wzh
 * @date 2020/6/4 20:14
 */
public class RegRequest {
    @JsonProperty("userName")
    private String userName;

    @JsonProperty("password")
    private String password;

    @JsonProperty("level")
    private int level;

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
}
