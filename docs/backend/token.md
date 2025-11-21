# Token Authentication Flow

This document outlines how authentication tokens work in a mobile application, covering both backend API and frontend mobile client interactions.

## Token Types

### Access Token

- **Purpose**: Short-lived token used to authenticate API requests
- **Lifespan**: 15 minutes to 1 hour
- **Storage**: Memory (frontend) / JWT payload (backend)

### Refresh Token

- **Purpose**: Long-lived token used to obtain new access tokens
- **Lifespan**: 7-30 days
- **Storage**: Secure storage (frontend) / Database (backend)

## Backend Flow

### 1. Login/Registration

- User provides credentials (email + password)
- Backend validates credentials
- Backend generates **access token** (JWT) + **refresh token** (random string)
- Refresh token is stored in database (Auth table)
- Both tokens returned to client

### 2. Protected Route Access

- Client sends access token in request header: `Authorization: Bearer <access_token>`
- Backend middleware validates token signature and expiration
- If valid, request proceeds; if invalid/expired, returns 401 Unauthorized

### 3. Token Refresh

- Client sends refresh token to `/refresh` endpoint
- Backend validates refresh token against database
- If valid, generates new access token (and optionally new refresh token)
- Returns new tokens to client

### 4. Logout

- Client sends request to logout endpoint
- Backend invalidates/deletes refresh token from database
- Client clears stored tokens

## Frontend (Mobile) Flow

### 1. Initial Authentication

- User enters credentials in login screen
- App sends credentials to backend `/login` endpoint
- Receives access token + refresh token
- **Access token**: Stored in memory/state
- **Refresh token**: Stored in secure storage (Keychain on iOS, Keystore on Android)

### 2. Making API Requests

- App attaches access token to all API requests in Authorization header
- If request fails with 401 error, trigger token refresh flow

### 3. Automatic Token Refresh

- Before token expires (or after 401 response):
  - Retrieve refresh token from secure storage
  - Send to `/refresh` endpoint
  - Receive new access token
  - Update in-memory token
  - Retry original request

### 4. App Restart

- On app launch, check if refresh token exists in secure storage
- If exists, automatically refresh to get new access token
- If refresh fails (expired/invalid), redirect to login screen

### 5. Logout

- Call logout API endpoint
- Clear access token from memory
- Remove refresh token from secure storage
- Redirect to login screen

## Security Best Practices

### Backend

- Sign JWTs with strong secret key
- Set appropriate token expiration times
- Store refresh tokens securely (hashed in database)
- Implement refresh token rotation (issue new refresh token on each refresh)
- Validate token on every protected route

### Frontend

- Never store tokens in plain text or shared preferences
- Use platform-specific secure storage (Keychain/Keystore)
- Clear tokens immediately on logout
- Implement automatic token refresh before expiration
- Handle token expiration gracefully (redirect to login)

## Example Request Flow

```
1. User logs in
   → POST /api/auth/login
   ← { accessToken, refreshToken }

2. User fetches events
   → GET /api/events (Header: Authorization: Bearer <accessToken>)
   ← { events: [...] }

3. Access token expires
   → GET /api/events
   ← 401 Unauthorized

4. App auto-refreshes
   → POST /api/auth/refresh (Body: { refreshToken })
   ← { accessToken, refreshToken }

5. Retry original request
   → GET /api/events (Header: Authorization: Bearer <newAccessToken>)
   ← { events: [...] }
```

## Token Storage Summary

| Token Type    | Backend Storage   | Frontend Storage           |
| ------------- | ----------------- | -------------------------- |
| Access Token  | Not stored        | Memory/State               |
| Refresh Token | Database (hashed) | Secure Storage (encrypted) |
