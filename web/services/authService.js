
import jwtDecode from "jwt-decode";

const COOKIE_NAME = 'aiwiki.authToken';

class AuthToken {
  constructor(token) {
    this.decodedToken = { email: "", exp: 0 };
    this.token = token;
    try {
      if (token) this.decodedToken = jwtDecode(token);
    } catch (e) {}
  }

  expiresAt() {
    return new Date(this.decodedToken.exp * 1000);
  }

  isExpired() {
    return new Date() > this.expiresAt();
  }

  isAuthenticated() {
    return !this.isExpired();
  }

  authorizationString() {
    return `Bearer ${this.token}`;
  }
}



export {
  COOKIE_NAME,
  AuthToken,
};
