
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


export {
	AuthToken,
};
