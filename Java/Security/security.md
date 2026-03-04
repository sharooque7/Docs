# Complete Java Security - The Ultimate Interview Guide 🔒

_Your comprehensive go-to reference for all Java Security concepts with brief explanations and code examples_

---

## **📋 TABLE OF CONTENTS**

- [Complete Java Security - The Ultimate Interview Guide 🔒](#complete-java-security---the-ultimate-interview-guide-)
  - [**📋 TABLE OF CONTENTS**](#-table-of-contents)
  - [**1. JAVA SECURITY OVERVIEW**](#1-java-security-overview)
  - [**2. JVM SECURITY ARCHITECTURE**](#2-jvm-security-architecture)
  - [**3. SANDBOX MODEL**](#3-sandbox-model)
  - [**4. SECURITY MANAGER**](#4-security-manager)
  - [**5. CLASS LOADERS AND SECURITY**](#5-class-loaders-and-security)
  - [**6. BYTECODE VERIFICATION**](#6-bytecode-verification)
  - [**7. CRYPTOGRAPHY IN JAVA**](#7-cryptography-in-java)
    - [**7.1 Hashing**](#71-hashing)
    - [**7.2 Symmetric Encryption (AES)**](#72-symmetric-encryption-aes)
    - [**7.3 Asymmetric Encryption (RSA)**](#73-asymmetric-encryption-rsa)
  - [**8. SECURE RANDOM NUMBER GENERATION**](#8-secure-random-number-generation)
  - [**9. JAVA KEYSTORE (JKS)**](#9-java-keystore-jks)
  - [**10. DIGITAL SIGNATURES**](#10-digital-signatures)
  - [**11. SSL/TLS IN JAVA**](#11-ssltls-in-java)
  - [**12. AUTHENTICATION VS AUTHORIZATION**](#12-authentication-vs-authorization)
  - [**13. SPRING SECURITY OVERVIEW**](#13-spring-security-overview)
    - [**Core Features**](#core-features)
  - [**14. SPRING SECURITY FILTERS**](#14-spring-security-filters)
    - [**Important Filter Classes**](#important-filter-classes)
  - [**15. SECURITY CONTEXT**](#15-security-context)
  - [**16. PASSWORD ENCODING AND HASHING**](#16-password-encoding-and-hashing)
    - [**Password Storage Best Practices**](#password-storage-best-practices)
  - [**17. JWT (JSON WEB TOKENS)**](#17-jwt-json-web-tokens)
    - [**JWT Flow**](#jwt-flow)
  - [**18. OAUTH 2.0**](#18-oauth-20)
    - [**OAuth 2.0 Roles**](#oauth-20-roles)
    - [**Spring Boot OAuth2 Example**](#spring-boot-oauth2-example)
  - [**19. SAML (SECURITY ASSERTION MARKUP LANGUAGE)**](#19-saml-security-assertion-markup-language)
  - [**20. LDAP AUTHENTICATION**](#20-ldap-authentication)
  - [**21. METHOD SECURITY ANNOTATIONS**](#21-method-security-annotations)
  - [**22. CSRF PROTECTION**](#22-csrf-protection)
    - [**CSRF Attack Explained**](#csrf-attack-explained)
  - [**23. CORS CONFIGURATION**](#23-cors-configuration)
  - [**24. SESSION MANAGEMENT**](#24-session-management)
    - [**Session Fixation Protection**](#session-fixation-protection)
  - [**25. HTTPS CONFIGURATION**](#25-https-configuration)
  - [**26. SQL INJECTION PREVENTION**](#26-sql-injection-prevention)
    - [**Additional Prevention**](#additional-prevention)
  - [**27. XSS PREVENTION**](#27-xss-prevention)
  - [**28. SECURE SERIALIZATION**](#28-secure-serialization)
    - [**Serialization Vulnerabilities**](#serialization-vulnerabilities)
  - [**29. INPUT VALIDATION**](#29-input-validation)
  - [**30. DEPENDENCY SECURITY**](#30-dependency-security)
    - [**Best Practices**](#best-practices)
  - [**31. CONTAINER SECURITY**](#31-container-security)
    - [**Kubernetes Security**](#kubernetes-security)
  - [**32. COMMON INTERVIEW QUESTIONS**](#32-common-interview-questions)
  - [**33. QUICK REFERENCE CHEAT SHEET**](#33-quick-reference-cheat-sheet)
  - [**📝 KEY TAKEAWAYS**](#-key-takeaways)

---

## **1. JAVA SECURITY OVERVIEW**

> **Concept:** Java security encompasses platform-level security features, cryptographic APIs, secure coding practices, and application-level security frameworks like Spring Security.

```java
// Java security has three main aspects
public class JavaSecurityOverview {
    public static void main(String[] args) {
        // 1. Platform Security - JVM sandbox, classloaders, bytecode verification
        // 2. Cryptographic APIs - encryption, hashing, digital signatures
        // 3. Application Security - authentication, authorization (Spring Security)
    }
}
```

---

## **2. JVM SECURITY ARCHITECTURE**

> **Concept:** The JVM provides multiple layers of security to ensure safe execution of Java code.

```
Java Security Architecture
┌─────────────────────────────────────┐
│      Java Application Code          │
├─────────────────────────────────────┤
│      Class Loaders                  │
├─────────────────────────────────────┤
│      Bytecode Verifier               │
├─────────────────────────────────────┤
│      Security Manager               │
├─────────────────────────────────────┤
│      JVM + Operating System         │
└─────────────────────────────────────┘
```

```java
// Security components in JVM
public class JVMSecurity {
    // 1. Class Loaders - define separate namespaces
    // 2. Bytecode Verifier - checks code integrity
    // 3. Security Manager - mediates access to resources
    // 4. Access Controller - evaluates permissions
}
```

---

## **3. SANDBOX MODEL**

> **Concept:** The sandbox model restricts untrusted code (like applets) from accessing sensitive system resources. Local code is trusted, remote code runs in a restricted environment.

```
Original Sandbox Model (JDK 1.0)
┌─────────────────────────────────────────────────┐
│                                                  │
│  ┌──────────────┐          ┌──────────────┐    │
│  │   Local      │          │   Remote     │    │
│  │   Code       │          │   Code       │    │
│  │   (Trusted)  │          │ (Untrusted)  │    │
│  └──────┬───────┘          └──────┬───────┘    │
│         │                         │            │
│         ▼                         ▼            │
│  ┌──────────────┐          ┌──────────────┐    │
│  │ Full Access  │          │   Sandbox    │    │
│  │ to Resources │          │  (Restricted)│    │
│  └──────────────┘          └──────────────┘    │
│                                                  │
└─────────────────────────────────────────────────┘
```

```java
// Modern security model - all code can be subject to policy
// java.policy file example
grant codeBase "file:/home/app/lib/*" {
    permission java.io.FilePermission "/tmp/*", "read,write";
    permission java.net.SocketPermission "localhost:8080", "connect";
};
```

---

## **4. SECURITY MANAGER**

> **Concept:** The Security Manager is a class that allows applications to implement a security policy. It checks permissions before allowing access to sensitive operations.

```java
// Enabling Security Manager
// -Djava.security.manager -Djava.security.policy=my.policy

// Programmatic check
public class SecurityManagerDemo {
    public void deleteFile(String filename) {
        SecurityManager security = System.getSecurityManager();

        if (security != null) {
            // Check if permission is granted
            security.checkDelete(filename);
        }

        // If we reach here, permission was granted
        new File(filename).delete();
    }
}

// Custom Security Manager
class CustomSecurityManager extends SecurityManager {
    @Override
    public void checkPermission(Permission perm) {
        // Custom logic
        if (perm.getName().equals("exitVM")) {
            throw new SecurityException("Cannot exit JVM");
        }
        super.checkPermission(perm);
    }
}

// Setting custom security manager
System.setSecurityManager(new CustomSecurityManager());
```

---

## **5. CLASS LOADERS AND SECURITY**

> **Concept:** Class loaders create separate namespaces, preventing untrusted code from interfering with trusted code. They enforce package boundaries and delegation hierarchies.

```java
// Class loader hierarchy
// Bootstrap ClassLoader → Platform/Extension ClassLoader → Application ClassLoader → Custom ClassLoaders

public class SecureClassLoaderDemo {
    public static void main(String[] args) {
        ClassLoader cl = Thread.currentThread().getContextClassLoader();

        // Different class loaders create different namespaces
        // Classes in different namespaces cannot access each other's package-private members
    }
}

// Custom class loader with security checks
class SecureClassLoader extends ClassLoader {
    @Override
    protected Class<?> loadClass(String name, boolean resolve) throws ClassNotFoundException {
        SecurityManager sm = System.getSecurityManager();
        if (sm != null) {
            // Check permission to load this class
            sm.checkPermission(new RuntimePermission("loadClass." + name));
        }
        return super.loadClass(name, resolve);
    }
}
```

---

## **6. BYTECODE VERIFICATION**

> **Concept:** The bytecode verifier ensures that loaded code follows Java language rules and won't violate JVM integrity before execution.

```java
// Bytecode verifier checks for:
// - Correct operand stack usage
// - Proper variable initialization
// - Valid type conversions
// - Access rules (private, protected)
// - No illegal data conversions
// - No stack overflows/underflows

// This verification happens when classes are loaded
// Cannot be bypassed by malicious bytecode modifications
```

---

## **7. CRYPTOGRAPHY IN JAVA**

> **Concept:** Java Cryptography Architecture (JCA) and Java Cryptography Extension (JCE) provide APIs for encryption, decryption, hashing, and digital signatures.

### **7.1 Hashing**

```java
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class HashingExample {
    public static String hashPassword(String password) throws Exception {
        // Avoid MD5, SHA1 - use SHA-256 or stronger
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(password.getBytes());

        // Convert to hex string
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    }

    // For passwords, use bcrypt, PBKDF2, or Argon2 instead
    // Spring Security provides PasswordEncoder implementations
}
```

### **7.2 Symmetric Encryption (AES)**

```java
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import java.security.SecureRandom;

public class AESEncryption {
    public static void main(String[] args) throws Exception {
        // Generate key
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256);
        SecretKey key = keyGen.generateKey();

        // Generate IV
        byte[] iv = new byte[12]; // 12 bytes for GCM
        SecureRandom random = new SecureRandom();
        random.nextBytes(iv);
        GCMParameterSpec spec = new GCMParameterSpec(128, iv);

        // Encrypt (use GCM mode for authenticated encryption)
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        cipher.init(Cipher.ENCRYPT_MODE, key, spec);
        byte[] cipherText = cipher.doFinal("Secret Message".getBytes());

        // Decrypt
        cipher.init(Cipher.DECRYPT_MODE, key, spec);
        byte[] plainText = cipher.doFinal(cipherText);
        System.out.println(new String(plainText));
    }
}
```

### **7.3 Asymmetric Encryption (RSA)**

```java
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import javax.crypto.Cipher;

public class RSAExample {
    public static void main(String[] args) throws Exception {
        // Generate key pair
        KeyPairGenerator keyGen = KeyPairGenerator.getInstance("RSA");
        keyGen.initialize(2048);
        KeyPair pair = keyGen.generateKeyPair();
        PublicKey publicKey = pair.getPublic();
        PrivateKey privateKey = pair.getPrivate();

        // Encrypt with public key
        Cipher cipher = Cipher.getInstance("RSA/ECB/OAEPWithSHA-256AndMGF1Padding");
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        byte[] encrypted = cipher.doFinal("Secret".getBytes());

        // Decrypt with private key
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        byte[] decrypted = cipher.doFinal(encrypted);
        System.out.println(new String(decrypted));
    }
}
```

---

## **8. SECURE RANDOM NUMBER GENERATION**

> **Concept:** Use `SecureRandom` for cryptographic operations instead of `Random`.

```java
import java.security.SecureRandom;

public class SecureRandomExample {
    public static void main(String[] args) {
        // SecureRandom - cryptographically strong
        SecureRandom secureRandom = new SecureRandom();

        // Generate random bytes
        byte[] randomBytes = new byte[32];
        secureRandom.nextBytes(randomBytes);

        // Generate random integers
        int randomInt = secureRandom.nextInt();
        int boundedInt = secureRandom.nextInt(100); // 0-99

        // Generate session ID
        String sessionId = generateSessionId();
    }

    public static String generateSessionId() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[32];
        random.nextBytes(bytes);
        return bytesToHex(bytes);
    }
}
```

---

## **9. JAVA KEYSTORE (JKS)**

> **Concept:** A repository for cryptographic keys and certificates, protected by passwords.

```java
import java.io.FileInputStream;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.security.cert.Certificate;

public class KeyStoreExample {
    public static void main(String[] args) throws Exception {
        // Load keystore
        KeyStore keyStore = KeyStore.getInstance("JKS");
        keyStore.load(new FileInputStream("keystore.jks"), "password".toCharArray());

        // Get private key
        PrivateKey privateKey = (PrivateKey) keyStore.getKey("alias", "keyPassword".toCharArray());

        // Get certificate
        Certificate cert = keyStore.getCertificate("alias");

        // List aliases
        java.util.Enumeration<String> aliases = keyStore.aliases();
        while (aliases.hasMoreElements()) {
            System.out.println(aliases.nextElement());
        }
    }
}
```

**KeyStore Commands:**

```bash
# Generate keystore
keytool -genkey -alias mykey -keystore keystore.jks -storepass password -validity 365

# Export certificate
keytool -export -alias mykey -keystore keystore.jks -file mycert.crt

# Import certificate
keytool -import -alias mykey -keystore keystore.jks -file mycert.crt
```

---

## **10. DIGITAL SIGNATURES**

> **Concept:** Digital signatures ensure data integrity and authenticity.

```java
import java.security.*;

public class DigitalSignatureExample {
    public static void main(String[] args) throws Exception {
        // Generate key pair
        KeyPairGenerator keyGen = KeyPairGenerator.getInstance("RSA");
        keyGen.initialize(2048);
        KeyPair keyPair = keyGen.generateKeyPair();

        // Sign data
        Signature signer = Signature.getInstance("SHA256withRSA");
        signer.initSign(keyPair.getPrivate());
        signer.update("Important message".getBytes());
        byte[] signature = signer.sign();

        // Verify signature
        Signature verifier = Signature.getInstance("SHA256withRSA");
        verifier.initVerify(keyPair.getPublic());
        verifier.update("Important message".getBytes());
        boolean verified = verifier.verify(signature);

        System.out.println("Signature verified: " + verified);
    }
}
```

---

## **11. SSL/TLS IN JAVA**

> **Concept:** SSL/TLS provides secure communication over networks. Java supports SSL through JSSE (Java Secure Socket Extension).

```java
import javax.net.ssl.*;
import java.io.*;
import java.security.KeyStore;

public class SSLExample {
    public static void main(String[] args) throws Exception {
        // Create SSL context
        SSLContext sslContext = SSLContext.getInstance("TLSv1.3");

        // Initialize with truststore
        KeyStore trustStore = KeyStore.getInstance("JKS");
        trustStore.load(new FileInputStream("truststore.jks"), "password".toCharArray());

        TrustManagerFactory tmf = TrustManagerFactory.getInstance("SunX509");
        tmf.init(trustStore);

        sslContext.init(null, tmf.getTrustManagers(), null);

        // Create SSL socket
        SSLSocketFactory factory = sslContext.getSocketFactory();
        SSLSocket socket = (SSLSocket) factory.createSocket("example.com", 443);

        // Enable TLS protocols
        socket.setEnabledProtocols(new String[]{"TLSv1.3", "TLSv1.2"});

        // Use the socket
        PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
        BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

        out.println("GET / HTTP/1.1\r\nHost: example.com\r\n\r\n");

        String line;
        while ((line = in.readLine()) != null) {
            System.out.println(line);
        }

        socket.close();
    }
}
```

---

## **12. AUTHENTICATION VS AUTHORIZATION**

> **Concept:** Authentication verifies identity, authorization determines access rights.

```java
// Authentication - Who are you?
// Authorization - What can you do?

public class AuthExample {
    // Authentication
    public User authenticate(String username, String password) {
        // Verify credentials
        if (userExists(username) && passwordMatches(username, password)) {
            return getUser(username);
        }
        throw new AuthenticationException("Invalid credentials");
    }

    // Authorization
    public boolean hasPermission(User user, String resource, String action) {
        // Check if user has permission
        return user.getRoles().stream()
            .anyMatch(role -> role.canAccess(resource, action));
    }
}
```

**Spring Security Example:**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(authz -> authz
                .requestMatchers("/public/**").permitAll()           // Public
                .requestMatchers("/api/users/**").hasRole("ADMIN")   // Authorization
                .anyRequest().authenticated()                         // Authentication required
            )
            .formLogin(Customizer.withDefaults());                    // Authentication
        return http.build();
    }
}
```

---

## **13. SPRING SECURITY OVERVIEW**

> **Concept:** Spring Security is a powerful authentication and access control framework for Java applications.

```java
@SpringBootApplication
@EnableWebSecurity
public class SecurityApplication {
    public static void main(String[] args) {
        SpringApplication.run(SecurityApplication.class, args);
    }
}

// Basic configuration
@Configuration
@EnableWebSecurity
public class BasicSecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(authz -> authz
                .anyRequest().authenticated()
            )
            .httpBasic(Customizer.withDefaults());
        return http.build();
    }

    @Bean
    public UserDetailsService userDetailsService() {
        UserDetails user = User.withUsername("user")
            .password("{bcrypt}$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG")
            .roles("USER")
            .build();

        return new InMemoryUserDetailsManager(user);
    }
}
```

### **Core Features**

| Feature            | Description                                |
| ------------------ | ------------------------------------------ |
| **Authentication** | Username/password, OAuth2, LDAP, SAML      |
| **Authorization**  | Role-based access control, method security |
| **Protection**     | CSRF, session fixation, clickjacking       |
| **Integration**    | Servlet API, Spring MVC, WebFlux           |

---

## **14. SPRING SECURITY FILTERS**

> **Concept:** Spring Security implements security via a chain of servlet filters.

```
Filter Chain
Request → [DelegatingFilterProxy] → [SecurityContextPersistenceFilter]
        → [UsernamePasswordAuthenticationFilter] → [BasicAuthenticationFilter]
        → [SessionManagementFilter] → [ExceptionTranslationFilter]
        → [FilterSecurityInterceptor] → Controller
```

### **Important Filter Classes**

```java
public class FilterDemo {
    // 1. UsernamePasswordAuthenticationFilter - processes form login
    // 2. BasicAuthenticationFilter - processes HTTP Basic auth
    // 3. SessionManagementFilter - manages sessions
    // 4. SecurityContextPersistenceFilter - stores security context
    // 5. ExceptionTranslationFilter - handles security exceptions
    // 6. FilterSecurityInterceptor - enforces authorization rules
}

// Custom filter example
public class CustomAuthenticationFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain chain) throws IOException, ServletException {
        String token = request.getHeader("X-Auth-Token");

        if (token != null && validateToken(token)) {
            Authentication auth = getAuthentication(token);
            SecurityContextHolder.getContext().setAuthentication(auth);
        }

        chain.doFilter(request, response);
    }
}
```

---

## **15. SECURITY CONTEXT**

> **Concept:** The SecurityContext holds authentication information for the current thread.

```java
@Service
public class SecurityContextDemo {

    public void getCurrentUser() {
        // Get security context
        SecurityContext context = SecurityContextHolder.getContext();

        // Get authentication
        Authentication auth = context.getAuthentication();

        if (auth != null) {
            String username = auth.getName();
            Object principal = auth.getPrincipal();
            Collection<? extends GrantedAuthority> authorities = auth.getAuthorities();

            System.out.println("User: " + username);
            System.out.println("Roles: " + authorities);
        }
    }

    // Set authentication manually
    public void authenticateManually() {
        Authentication auth = new UsernamePasswordAuthenticationToken(
            "user", null, List.of(new SimpleGrantedAuthority("ROLE_USER"))
        );

        SecurityContextHolder.getContext().setAuthentication(auth);
    }

    // Get current user in controller
    @GetMapping("/profile")
    public UserProfile getProfile(@AuthenticationPrincipal UserDetails userDetails) {
        return userService.findByUsername(userDetails.getUsername());
    }
}
```

---

## **16. PASSWORD ENCODING AND HASHING**

> **Concept:** Passwords should never be stored in plain text. Use strong, adaptive hashing algorithms.

```java
@Configuration
public class PasswordEncoderConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        // BCrypt is recommended - adaptive, includes salt
        return new BCryptPasswordEncoder(12); // strength 12
    }
}

@Service
public class UserService {

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private UserRepository userRepository;

    public User registerUser(String username, String rawPassword) {
        String encodedPassword = passwordEncoder.encode(rawPassword);

        User user = new User();
        user.setUsername(username);
        user.setPassword(encodedPassword);

        return userRepository.save(user);
    }

    public boolean authenticate(String username, String rawPassword) {
        User user = userRepository.findByUsername(username);

        if (user == null) return false;

        // Check password
        return passwordEncoder.matches(rawPassword, user.getPassword());
    }
}

// DelegatingPasswordEncoder - supports multiple encodings
@Bean
public PasswordEncoder passwordEncoder() {
    String encodingId = "bcrypt";
    Map<String, PasswordEncoder> encoders = new HashMap<>();
    encoders.put("bcrypt", new BCryptPasswordEncoder());
    encoders.put("pbkdf2", new Pbkdf2PasswordEncoder());
    encoders.put("argon2", new Argon2PasswordEncoder());

    return new DelegatingPasswordEncoder(encodingId, encoders);
}
```

### **Password Storage Best Practices**

| Algorithm   | Status               | Use              |
| ----------- | -------------------- | ---------------- |
| **MD5**     | ❌ Broken            | Never use        |
| **SHA-1**   | ❌ Weak              | Never use        |
| **SHA-256** | ⚠️ Not for passwords | Use with PBKDF2  |
| **BCrypt**  | ✅ Recommended       | Password hashing |
| **PBKDF2**  | ✅ Good              | Password hashing |
| **Argon2**  | ✅ Best              | Modern algorithm |

---

## **17. JWT (JSON WEB TOKENS)**

> **Concept:** JWT is a compact, URL-safe token format for securely transmitting information between parties.

```java
// JWT Structure: Header.Payload.Signature
// eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

import java.security.Key;
import java.util.Date;

@Component
public class JwtTokenProvider {

    private final Key key = Keys.secretKeyFor(SignatureAlgorithm.HS256);
    private final long validityInMs = 3600000; // 1 hour

    public String createToken(String username, List<String> roles) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + validityInMs);

        return Jwts.builder()
            .setSubject(username)
            .claim("roles", roles)
            .setIssuedAt(now)
            .setExpiration(expiry)
            .signWith(key)
            .compact();
    }

    public boolean validateToken(String token) {
        try {
            Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }

    public String getUsername(String token) {
        return Jwts.parserBuilder()
            .setSigningKey(key)
            .build()
            .parseClaimsJws(token)
            .getBody()
            .getSubject();
    }
}

// JWT Authentication Filter
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    @Autowired
    private JwtTokenProvider tokenProvider;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain chain) throws IOException, ServletException {
        String token = extractToken(request);

        if (token != null && tokenProvider.validateToken(token)) {
            String username = tokenProvider.getUsername(token);

            UsernamePasswordAuthenticationToken auth =
                new UsernamePasswordAuthenticationToken(username, null, Collections.emptyList());

            SecurityContextHolder.getContext().setAuthentication(auth);
        }

        chain.doFilter(request, response);
    }

    private String extractToken(HttpServletRequest request) {
        String bearer = request.getHeader("Authorization");
        if (bearer != null && bearer.startsWith("Bearer ")) {
            return bearer.substring(7);
        }
        return null;
    }
}
```

### **JWT Flow**

```
1. User logs in with credentials
2. Server validates credentials
3. Server generates JWT and returns to client
4. Client stores JWT (localStorage, cookie)
5. Client sends JWT in Authorization header for subsequent requests
6. Server validates JWT and processes request
```

---

## **18. OAUTH 2.0**

> **Concept:** OAuth 2.0 is an authorization protocol that enables client applications to access protected resources through an authorization server.

```
┌──────────┐      ┌──────────┐      ┌──────────┐
│   User   │      │  Client  │      │   Auth   │
│ (Owner)  │      │    App   │      │  Server  │
└────┬─────┘      └────┬─────┘      └────┬─────┘
     │                 │                  │
     │  1. Request     │                  │
     │   Authorization │                  │
     │────────────────>│                  │
     │                 │                  │
     │  2. Redirect    │                  │
     │   to Auth       │                  │
     │<────────────────│                  │
     │                 │                  │
     │  3. Authenticate│                  │
     │────────────────>│                  │
     │                 │                  │
     │  4. Return Code │                  │
     │<────────────────│                  │
     │                 │                  │
     │                 │ 5. Exchange      │
     │                 │ Code for Token   │
     │                 │─────────────────>│
     │                 │                  │
     │                 │ 6. Return Token  │
     │                 │<─────────────────│
     │                 │                  │
```

### **OAuth 2.0 Roles**

| Role                     | Description                   |
| ------------------------ | ----------------------------- |
| **Resource Owner**       | User who owns the data        |
| **Client**               | Application requesting access |
| **Authorization Server** | Issues tokens                 |
| **Resource Server**      | Hosts protected resources     |

### **Spring Boot OAuth2 Example**

```yaml
# application.yml
spring:
  security:
    oauth2:
      client:
        registration:
          google:
            client-id: your-client-id
            client-secret: your-client-secret
            scope: profile, email
      resourceserver:
        jwt:
          issuer-uri: https://accounts.google.com
```

```java
@Configuration
@EnableWebSecurity
public class OAuth2SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .oauth2Login(oauth2 -> oauth2
                .loginPage("/oauth2/authorization/google")
                .defaultSuccessUrl("/dashboard")
            )
            .oauth2ResourceServer(oauth2 -> oauth2
                .jwt(Customizer.withDefaults())
            );

        return http.build();
    }
}

@RestController
public class UserController {

    @GetMapping("/userinfo")
    public Map<String, Object> getUserInfo(@AuthenticationPrincipal OAuth2User principal) {
        return principal.getAttributes();
    }
}
```

---

## **19. SAML (SECURITY ASSERTION MARKUP LANGUAGE)**

> **Concept:** SAML is an XML-based authentication protocol often used for Single Sign-On (SSO).

```
SAML Flow:
┌──────┐      ┌──────┐      ┌──────┐
│ User │      │  SP  │      │ IdP  │
└──┬───┘      └──┬───┘      └──┬───┘
   │ 1. Access   │              │
   │────────────>│              │
   │             │ 2. Redirect  │
   │             │─────────────>│
   │ 3. Auth     │              │
   │<────────────│              │
   │             │              │
   │ 4. AuthN    │              │
   │───────────────────────────>│
   │             │              │
   │ 5. SAML     │              │
   │   Assertion │              │
   │<───────────────────────────│
   │             │              │
   │ 6. Access   │              │
   │────────────>│              │
   │             │              │
```

**SP** = Service Provider, **IdP** = Identity Provider

```java
// Spring Security SAML configuration
@Configuration
@EnableSAML
public class SamlSecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(authz -> authz
                .anyRequest().authenticated()
            )
            .saml2Login(saml2 -> saml2
                .relyingPartyRegistration(relyingPartyRegistrations())
            );

        return http.build();
    }

    @Bean
    public RelyingPartyRegistrationRepository relyingPartyRegistrations() {
        // Configure SAML identity provider details
        return new InMemoryRelyingPartyRegistrationRepository(
            RelyingPartyRegistration.withRegistrationId("okta")
                .entityId("https://idp.example.com")
                .assertionConsumerServiceLocation("https://sp.example.com/login/saml2/sso/okta")
                .build()
        );
    }
}
```

---

## **20. LDAP AUTHENTICATION**

> **Concept:** LDAP (Lightweight Directory Access Protocol) is used for centralized authentication and directory services.

```java
@Configuration
public class LdapSecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(authz -> authz
                .anyRequest().authenticated()
            )
            .ldapLogin(ldap -> ldap
                .userDetailsContextMapper(userDetailsContextMapper())
            );

        return http.build();
    }

    @Bean
    public LdapContextSource contextSource() {
        LdapContextSource contextSource = new LdapContextSource();
        contextSource.setUrl("ldap://localhost:8389/dc=springframework,dc=org");
        contextSource.setBase("dc=springframework,dc=org");
        contextSource.setUserDn("cn=admin,dc=springframework,dc=org");
        contextSource.setPassword("password");
        return contextSource;
    }

    @Bean
    public LdapUserDetailsManager userDetailsManager() {
        LdapUserDetailsManager manager = new LdapUserDetailsManager(contextSource());
        manager.setUsernameMapper(DefaultLdapUsernameMapper());
        return manager;
    }
}

// LDAP authentication programmatically
@Service
public class LdapAuthService {

    @Autowired
    private LdapTemplate ldapTemplate;

    public boolean authenticate(String username, String password) {
        AndFilter filter = new AndFilter();
        filter.and(new EqualsFilter("uid", username));

        return ldapTemplate.authenticate(
            DistinguishedName.EMPTY_PATH,
            filter.toString(),
            password
        );
    }
}
```

---

## **21. METHOD SECURITY ANNOTATIONS**

> **Concept:** Spring Security provides annotations for method-level authorization.

```java
@Configuration
@EnableGlobalMethodSecurity(
    prePostEnabled = true,
    securedEnabled = true,
    jsr250Enabled = true
)
public class MethodSecurityConfig {
    // Enable method-level security
}

@Service
public class SecureService {

    // 1. @Secured - simple role check
    @Secured("ROLE_ADMIN")
    public void adminOnly() {
        // Only ADMIN can access
    }

    @Secured({"ROLE_USER", "ROLE_ADMIN"})
    public void userOrAdmin() {
        // USER or ADMIN can access
    }

    // 2. @RolesAllowed - JSR-250 annotation
    @RolesAllowed("ADMIN")
    public void adminOnlyJsr250() {
        // Only ADMIN
    }

    // 3. @PreAuthorize - SpEL expressions
    @PreAuthorize("hasRole('ADMIN')")
    public void adminOnlyPre() {
        // ADMIN only
    }

    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    public void userOrAdminPre() {
        // USER or ADMIN
    }

    @PreAuthorize("#id == authentication.principal.id")
    public void ownDataOnly(Long id) {
        // Users can only access their own data
    }

    @PreAuthorize("hasPermission(#document, 'WRITE')")
    public void writeDocument(Document document) {
        // Custom permission evaluator
    }

    // 4. @PostAuthorize - check after method execution
    @PostAuthorize("returnObject.owner == authentication.name")
    public Document getDocument(Long id) {
        return documentRepository.findById(id);
    }

    // 5. @PreFilter - filter input collections
    @PreFilter("filterObject.owner == authentication.name")
    public void saveDocuments(List<Document> documents) {
        // Only saves documents owned by current user
    }

    // 6. @PostFilter - filter output collections
    @PostFilter("filterObject.owner == authentication.name")
    public List<Document> getAllDocuments() {
        return documentRepository.findAll();
    }
}
```

---

## **22. CSRF PROTECTION**

> **Concept:** Cross-Site Request Forgery (CSRF) is an attack that forces authenticated users to execute unwanted actions. Spring Security provides protection by default.

```java
@Configuration
@EnableWebSecurity
public class CsrfSecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf
                .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
                .ignoringRequestMatchers("/api/public/**")
            )
            .authorizeHttpRequests(authz -> authz
                .anyRequest().authenticated()
            );

        return http.build();
    }
}

// In Thymeleaf template - include CSRF token
<form method="post" action="/transfer">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    <!-- form fields -->
</form>

// In JavaScript with CSRF token
fetch('/api/transfer', {
    method: 'POST',
    headers: {
        'X-CSRF-TOKEN': csrfToken
    },
    body: JSON.stringify(data)
});

// When to disable CSRF (stateless APIs)
@Configuration
public class StatelessApiConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())  // Disable for stateless APIs
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )
            .oauth2ResourceServer(oauth2 -> oauth2
                .jwt(Customizer.withDefaults())
            );

        return http.build();
    }
}
```

### **CSRF Attack Explained**

```
Normal Request:
User → Browser → Bank.com/transfer?amount=1000 (Authenticated)

CSRF Attack:
User → Malicious Site → Hidden Request to Bank.com/transfer?amount=1000
                   (Browser automatically includes cookies!)
```

---

## **23. CORS CONFIGURATION**

> **Concept:** Cross-Origin Resource Sharing (CORS) controls which domains can access your API.

```java
@Configuration
public class CorsConfig {

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/api/**")
                    .allowedOrigins("https://example.com", "https://app.example.com")
                    .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                    .allowedHeaders("*")
                    .allowCredentials(true)
                    .maxAge(3600);
            }
        };
    }
}

// Spring Security CORS integration
@Configuration
@EnableWebSecurity
public class SecurityCorsConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(authz -> authz
                .anyRequest().authenticated()
            );

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(Arrays.asList("https://example.com"));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE"));
        configuration.setAllowedHeaders(Arrays.asList("*"));
        configuration.setAllowCredentials(true);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
```

---

## **24. SESSION MANAGEMENT**

> **Concept:** Managing user sessions securely to prevent session fixation, hijacking, and other attacks.

```java
@Configuration
@EnableWebSecurity
public class SessionManagementConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .sessionManagement(session -> session
                // Session creation policy
                .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)

                // Concurrent session control
                .maximumSessions(1)
                .maxSessionsPreventsLogin(true)
                .expiredUrl("/session-expired")

                // Session fixation protection
                .sessionFixation().migrateSession()
            )
            .authorizeHttpRequests(authz -> authz
                .anyRequest().authenticated()
            );

        return http.build();
    }
}

// Get session information
@RestController
public class SessionController {

    @GetMapping("/session-info")
    public Map<String, Object> getSessionInfo(HttpServletRequest request) {
        HttpSession session = request.getSession();

        return Map.of(
            "sessionId", session.getId(),
            "creationTime", session.getCreationTime(),
            "lastAccessed", session.getLastAccessedTime(),
            "maxInactiveInterval", session.getMaxInactiveInterval()
        );
    }

    @PostMapping("/logout")
    public String logout(HttpServletRequest request) {
        SecurityContextHolder.clearContext();
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return "Logged out";
    }
}
```

### **Session Fixation Protection**

```java
// Spring Security provides three strategies:
// - none: keep the same session
// - newSession: create new clean session
// - migrateSession: create new session and copy attributes (default)
```

---

## **25. HTTPS CONFIGURATION**

> **Concept:** Enabling HTTPS ensures encrypted communication between client and server.

```yaml
# application.yml
server:
  port: 8443
  ssl:
    key-store: classpath:keystore.p12
    key-store-password: password
    key-store-type: PKCS12
    key-alias: tomcat
```

```java
@Configuration
public class HttpsConfig {

    @Bean
    public ServletWebServerFactory servletContainer() {
        TomcatServletWebServerFactory tomcat = new TomcatServletWebServerFactory();
        tomcat.addAdditionalTomcatConnectors(createHttpConnector());
        return tomcat;
    }

    private Connector createHttpConnector() {
        Connector connector = new Connector(TomcatServletWebServerFactory.DEFAULT_PROTOCOL);
        connector.setScheme("http");
        connector.setPort(8080);
        connector.setSecure(false);
        connector.setRedirectPort(8443);  // Redirect to HTTPS
        return connector;
    }
}

// Spring Security HTTPS enforcement
@Configuration
@EnableWebSecurity
public class HttpsSecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .requiresChannel(channel -> channel
                .anyRequest().requiresSecure()
            )
            .authorizeHttpRequests(authz -> authz
                .anyRequest().authenticated()
            );

        return http.build();
    }
}
```

---

## **26. SQL INJECTION PREVENTION**

> **Concept:** SQL injection occurs when untrusted data is concatenated into SQL queries. Always use parameterized queries.

```java
// ❌ BAD - Vulnerable to SQL injection
public User getUserById(String id) {
    String query = "SELECT * FROM users WHERE id = '" + id + "'";
    Statement stmt = connection.createStatement();
    ResultSet rs = stmt.executeQuery(query);  // Dangerous!
}

// ✅ GOOD - Use PreparedStatement
public User getUserById(String id) {
    String query = "SELECT * FROM users WHERE id = ?";
    PreparedStatement stmt = connection.prepareStatement(query);
    stmt.setString(1, id);
    ResultSet rs = stmt.executeQuery();
}

// ✅ GOOD - JPA with parameter binding
@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    @Query("SELECT u FROM User u WHERE u.username = :username")
    User findByUsername(@Param("username") String username);
}

// ✅ GOOD - Named parameters with JdbcTemplate
@Repository
public class UserDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public User findByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(User.class), username);
    }
}

// ✅ GOOD - JPA Criteria API
public List<User> searchUsers(String name) {
    CriteriaBuilder cb = entityManager.getCriteriaBuilder();
    CriteriaQuery<User> query = cb.createQuery(User.class);
    Root<User> root = query.from(User.class);

    query.select(root).where(cb.equal(root.get("name"), name));

    return entityManager.createQuery(query).getResultList();
}
```

### **Additional Prevention**

```java
// Input validation
public boolean isValidUsername(String username) {
    // Whitelist validation
    return username.matches("^[a-zA-Z0-9_]{3,20}$");
}

// Escape dynamic content when PreparedStatement can't be used
String safeInput = ESAPI.encoder().encodeForSQL(new MySQLCodec(), userInput);
```

---

## **27. XSS PREVENTION**

> **Concept:** Cross-Site Scripting (XSS) allows attackers to inject malicious scripts into web pages.

```java
// ❌ BAD - Outputting raw user input
@GetMapping("/profile")
public String profile(@RequestParam String name, Model model) {
    model.addAttribute("name", name);  // Vulnerable to XSS
    return "profile";
}

// ✅ GOOD - Escape output
@Controller
public class SafeController {

    @GetMapping("/profile")
    public String profile(@RequestParam String name, Model model) {
        // Escape HTML
        String safeName = HtmlUtils.htmlEscape(name);
        model.addAttribute("name", safeName);
        return "profile";
    }
}

// ✅ GOOD - Use Thymeleaf (auto-escaping)
<p th:text="${name}">Name here</p>  <!-- Automatically escaped -->

// ✅ GOOD - Content Security Policy headers
@Configuration
@EnableWebSecurity
public class SecurityHeadersConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .headers(headers -> headers
                .contentSecurityPolicy(csp -> csp
                    .policyDirectives("default-src 'self'; script-src 'self'")
                )
                .xssProtection(xss -> xss
                    .headerValue(XXssProtectionHeaderValue.ENABLED_MODE_BLOCK)
                )
            );

        return http.build();
    }
}

// ✅ GOOD - Output encoding utilities
import org.owasp.encoder.Encode;

public String safeOutput(String input) {
    // HTML encoding
    String htmlSafe = Encode.forHtml(input);

    // JavaScript encoding
    String jsSafe = Encode.forJavaScript(input);

    // URL encoding
    String urlSafe = Encode.forUriComponent(input);

    return htmlSafe;
}
```

---

## **28. SECURE SERIALIZATION**

> **Concept:** Java deserialization can lead to remote code execution if not handled carefully.

```java
// ❌ DANGEROUS - Unfiltered deserialization
ObjectInputStream ois = new ObjectInputStream(inputStream);
Object obj = ois.readObject();  // Could execute malicious code

// ✅ GOOD - Use serialization filters (Java 9+)
ObjectInputStream ois = new ObjectInputStream(inputStream);
ois.setObjectInputFilter(filterInfo -> {
    if (filterInfo.serialClass() == null) {
        return ObjectInputFilter.Status.ALLOWED;
    }

    String className = filterInfo.serialClass().getName();

    // Whitelist allowed classes
    if (className.startsWith("com.example.safe.")) {
        return ObjectInputFilter.Status.ALLOWED;
    }

    // Blacklist dangerous classes
    if (className.contains("Runtime") ||
        className.contains("ProcessBuilder")) {
        return ObjectInputFilter.Status.REJECTED;
    }

    return ObjectInputFilter.Status.REJECTED;
});

// ✅ GOOD - Global serialization filter
// JVM parameter: -Djdk.serialFilter=!java.lang.Runtime;!java.lang.ProcessBuilder;com.example.safe.*

// ✅ GOOD - Use safe alternatives to Java serialization
import com.fasterxml.jackson.databind.ObjectMapper;

// JSON serialization (safer)
ObjectMapper mapper = new ObjectMapper();
String json = mapper.writeValueAsString(user);
User user = mapper.readValue(json, User.class);

// ✅ GOOD - Implement readObject safely
private void readObject(ObjectInputStream ois) throws IOException, ClassNotFoundException {
    ois.defaultReadObject();

    // Validate after deserialization
    if (age < 0 || age > 150) {
        throw new InvalidObjectException("Invalid age");
    }
}
```

### **Serialization Vulnerabilities**

```java
// Common vulnerable patterns
// - Apache Commons Collections gadgets
// - Spring Framework gadgets
// - Runtime.exec() through deserialization

// Use dependency checker to identify vulnerable libraries
// OWASP Dependency-Check, Snyk
```

---

## **29. INPUT VALIDATION**

> **Concept:** Always validate input on both client and server side. Use whitelist validation when possible.

```java
@Service
public class ValidationService {

    // Whitelist validation
    public boolean isValidEmail(String email) {
        String regex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
        return email != null && email.matches(regex);
    }

    // Range validation
    public boolean isValidAge(int age) {
        return age >= 18 && age <= 120;
    }

    // Length validation
    public boolean isValidUsername(String username) {
        return username != null &&
               username.length() >= 3 &&
               username.length() <= 20 &&
               username.matches("^[a-zA-Z0-9_]+$");
    }
}

// Bean Validation (JSR-380)
public class User {

    @NotNull(message = "Username is required")
    @Size(min = 3, max = 20, message = "Username must be 3-20 characters")
    @Pattern(regexp = "^[a-zA-Z0-9_]+$", message = "Username must be alphanumeric")
    private String username;

    @NotNull
    @Email(message = "Invalid email format")
    private String email;

    @Min(18)
    @Max(120)
    private int age;

    @Past
    private Date birthDate;

    @Future
    private Date eventDate;
}

@RestController
public class UserController {

    @PostMapping("/users")
    public User createUser(@Valid @RequestBody User user) {
        // Bean validation automatically applied
        return userService.save(user);
    }

    // Manual validation
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegistrationRequest request) {
        List<String> errors = new ArrayList<>();

        if (!isValidEmail(request.getEmail())) {
            errors.add("Invalid email format");
        }

        if (request.getPassword().length() < 8) {
            errors.add("Password too short");
        }

        if (!errors.isEmpty()) {
            return ResponseEntity.badRequest().body(errors);
        }

        return ResponseEntity.ok(userService.register(request));
    }
}
```

---

## **30. DEPENDENCY SECURITY**

> **Concept:** Third-party dependencies can introduce vulnerabilities. Regular scanning and updates are essential.

```xml
<!-- Maven dependency check plugin -->
<plugin>
    <groupId>org.owasp</groupId>
    <artifactId>dependency-check-maven</artifactId>
    <version>8.4.0</version>
    <executions>
        <execution>
            <goals>
                <goal>check</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

```gradle
// Gradle dependency check
plugins {
    id 'org.owasp.dependencycheck' version '8.4.0'
}

dependencyCheck {
    failOnError = true
    scanConfigurations = ['runtimeClasspath']
    format = 'ALL'
}
```

### **Best Practices**

```java
public class DependencySecurity {
    // 1. Regularly update dependencies
    // mvn versions:display-dependency-updates

    // 2. Use Software Bill of Materials (SBOM)
    // Generate SBOM with CycloneDX or SPDX

    // 3. Monitor CVE databases
    // https://nvd.nist.gov/

    // 4. Use trusted repositories only
    // Configure Maven to use internal mirror

    // 5. Verify checksums and signatures
    // mvn -Dmaven.artifact.checksum=sha512
}
```

**Vulnerability Scanning Tools**

| Tool                       | Description                         |
| -------------------------- | ----------------------------------- |
| **OWASP Dependency-Check** | Scans dependencies for CVEs         |
| **Snyk**                   | IDE integration, real-time scanning |
| **Sonatype Nexus**         | Repository firewall                 |
| **JFrog Xray**             | Artifact analysis                   |

---

## **31. CONTAINER SECURITY**

> **Concept:** Secure container images for microservices deployment.

```dockerfile
# Secure Dockerfile for Spring Boot
# Use minimal base image
FROM eclipse-temurin:17-jdk-alpine AS builder
WORKDIR /app
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
RUN ./mvnw dependency:go-offline -B

COPY src src
RUN ./mvnw package -DskipTests

# Final stage - use JRE only
FROM eclipse-temurin:17-jre-alpine
RUN addgroup --system --gid 1000 appuser && \
    adduser --system --uid 1000 --gid 1000 appuser

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

# Run as non-root
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost:8080/actuator/health || exit 1

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### **Kubernetes Security**

```yaml
# Secure pod configuration
apiVersion: v1
kind: Pod
metadata:
  name: secure-app
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    fsGroup: 1000
  containers:
    - name: app
      image: myapp:latest
      securityContext:
        allowPrivilegeEscalation: false
        readOnlyRootFilesystem: true
        capabilities:
          drop:
            - ALL
      env:
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: password
```

---

## **32. COMMON INTERVIEW QUESTIONS**

| Question                                                             | Answer                                                                                                     |
| -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| **What is the Java Security Model?**                                 | Multi-layered security with classloaders, bytecode verifier, security manager, and access controller       |
| **What is the difference between authentication and authorization?** | Authentication verifies identity; authorization determines access rights                                   |
| **How does Spring Security work?**                                   | Through a chain of filters that intercept requests and apply security rules                                |
| **What is JWT and when would you use it?**                           | JSON Web Token for stateless authentication, often in microservices                                        |
| **What is OAuth 2.0?**                                               | Authorization protocol allowing third-party access without sharing credentials                             |
| **How do you prevent SQL injection?**                                | Use PreparedStatement, parameterized queries, input validation                                             |
| **What is CSRF and how does Spring prevent it?**                     | Attack tricking authenticated users to submit unwanted requests; prevented with synchronizer token pattern |
| **How do you store passwords securely?**                             | Use BCrypt, PBKDF2, or Argon2 with salt; never store plain text                                            |
| **What is the SecurityContext?**                                     | Holds authentication information for current thread                                                        |
| **What is CORS and how do you configure it?**                        | Cross-Origin Resource Sharing controls which domains can access API                                        |
| **How do you handle session fixation?**                              | Spring Security migrates session or creates new one after authentication                                   |
| **What is the Security Filter Chain?**                               | Series of filters processing requests before reaching controller                                           |
| **How do you enable HTTPS in Spring Boot?**                          | Configure SSL in application.yml with keystore                                                             |
| **What is the bytecode verifier?**                                   | Checks loaded code for integrity and Java language rules before execution                                  |
| **What is the sandbox model?**                                       | Restricts untrusted code from accessing system resources                                                   |
| **What are common security annotations?**                            | @PreAuthorize, @PostAuthorize, @Secured, @RolesAllowed                                                     |
| **How do you prevent XSS?**                                          | Output encoding, Content Security Policy, input validation                                                 |
| **What is LDAP authentication?**                                     | Using directory service for centralized authentication                                                     |
| **What is SAML?**                                                    | XML-based SSO protocol                                                                                     |
| **How do you secure deserialization?**                               | Use ObjectInputFilter, whitelist allowed classes, prefer JSON                                              |
| **What are common crypto mistakes?**                                 | Hardcoded keys, weak algorithms (MD5, SHA1), ECB mode, static IVs                                          |
| **How do you manage secrets?**                                       | Use Java KeyStore, environment variables, Kubernetes secrets, vault services                               |
| **What is the principle of least privilege?**                        | Grant minimum permissions necessary                                                                        |
| **How do you implement rate limiting?**                              | Use Bucket4j, Resilience4j, or API gateway                                                                 |

---

## **33. QUICK REFERENCE CHEAT SHEET**

```java
// ========== JVM SECURITY ==========
// Enable security manager
-Djava.security.manager -Djava.security.policy=my.policy

// Security context
SecurityContextHolder.getContext().getAuthentication();

// ========== CRYPTOGRAPHY ==========
// Hashing - use BCrypt, not MD5/SHA1
BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
String hash = encoder.encode("password");
encoder.matches("password", hash);

// AES encryption
Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
cipher.init(Cipher.ENCRYPT_MODE, key, new GCMParameterSpec(128, iv));

// SecureRandom
SecureRandom random = new SecureRandom();

// ========== SPRING SECURITY ==========
// Basic configuration
http.authorizeHttpRequests(authz -> authz
    .requestMatchers("/public/**").permitAll()
    .anyRequest().authenticated())
    .formLogin(Customizer.withDefaults());

// Method security
@PreAuthorize("hasRole('ADMIN')")
public void secureMethod() { }

// JWT token
Jwts.builder()
    .setSubject(username)
    .signWith(key)
    .compact();

// Password encoder
@Bean
public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
}

// ========== SECURE CODING ==========
// SQL injection prevention
PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
ps.setString(1, userId);

// XSS prevention
String safe = HtmlUtils.htmlEscape(userInput);

// Input validation
@Valid @RequestBody User user

// Deserialization filter
ois.setObjectInputFilter(filterInfo -> {
    return filterInfo.serialClass().getName().startsWith("com.safe.")
        ? Status.ALLOWED : Status.REJECTED;
});

// ========== HTTPS CONFIG ==========
server.ssl.key-store: classpath:keystore.p12
server.ssl.key-store-password: password

// ========== CORS CONFIG ==========
@Bean
public WebMvcConfigurer corsConfigurer() {
    return new WebMvcConfigurer() {
        @Override
        public void addCorsMappings(CorsRegistry registry) {
            registry.addMapping("/**").allowedOrigins("https://example.com");
        }
    };
}

// ========== CSRF PROTECTION ==========
http.csrf(csrf -> csrf.csrfTokenRepository(
    CookieCsrfTokenRepository.withHttpOnlyFalse()
));

// ========== DEPENDENCY CHECK ==========
// OWASP Dependency-Check Maven plugin
mvn dependency-check:check
```

---

## **📝 KEY TAKEAWAYS**

1. **JVM Security** - Classloaders, bytecode verifier, security manager
2. **Cryptography** - Use strong algorithms (AES-GCM, BCrypt), never roll your own
3. **Spring Security** - Filter chain, authentication, authorization
4. **Authentication** - Verify identity (JWT, OAuth2, SAML, LDAP)
5. **Authorization** - Control access (roles, permissions, method security)
6. **Web Security** - CSRF, CORS, HTTPS, session management
7. **Secure Coding** - Input validation, SQL injection prevention, XSS prevention
8. **Serialization** - Avoid Java serialization or use filters
9. **Password Storage** - BCrypt, PBKDF2, Argon2 with salt
10. **Dependencies** - Regular scanning, keep updated, SBOM

---

_Good luck with your interview! 🎉_
