package inid.test.demo.dto.response;

/**
 * @author wzh
 * @date 2020/6/4 21:11
 */
public class LoginResponse {
    private String userId;

    private String token;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public LoginResponse(String userId, String token) {
        this.userId = userId;
        this.token = token;
    }
}
