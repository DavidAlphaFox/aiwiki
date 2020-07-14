
import jwtDecode from "jwt-decode";

class AuthToken {
  constructor(token) {
    this.decodedToken = { email: "", exp: 0 };
    try {
      if (token) this.decodedToken = jwtDecode(token);
    } catch (e) {}
  }

  expiresAt() {
    return new Date(this.decodedToken.exp * 1000);
  }

  isExpired() {
    return new Date() > this.expiresAt;
  }

  isAuthenticated() {
    return !this.isExpired;
  }

  authorizationString() {
    return `Bearer ${this.token}`;
  }
}


function login(inputs: LoginInputs): Promise<string | void> {
  const data = new URLSearchParams(inputs);
  const config: AxiosRequestConfig = {
    baseURL: "http://localhost:1323",
  };
  const res: any = await axios.post("/api/login", data, config).catch(catchAxiosError);
  if (res.error) {
    return res.error;
  } else if (!res.data || !res.data.token) {
    return "Something went wrong!";
  }
  const { token } = res.data;

  // store the token into cookies
  Cookie.set(COOKIES.authToken, token);
  await Router.push("/dashboard");
}


export {
  AuthToken,
  
};
