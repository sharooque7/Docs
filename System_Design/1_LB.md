# 🌐 Load Balancer (LB) - System Design

## 📌 What is a Load Balancer?
A Load Balancer distributes incoming network traffic across multiple servers to:
- Prevent overload on a single server
- Enable fault tolerance and failover
- Improve system availability and scalability

---

## 🔢 Types of Load Balancers

### 🔹 L4 Load Balancer (Transport Layer)
- Works on TCP/UDP layer
- Routes based on IP address and port
- Doesn't look into the HTTP request

**Examples**:
- HAProxy (TCP mode)
- Nginx (Stream module)
- AWS NLB (Network Load Balancer)

```nginx
# Nginx L4 Load Balancing (for MySQL)
stream {
  upstream mysql_backend {
    server 192.168.1.101:3306;
    server 192.168.1.102:3306;
  }
  
  server {
    listen 3306;
    proxy_pass mysql_backend;
  }
}
```

### 🔸 L7 Load Balancer (Application Layer)
* Understands HTTP/HTTPS
* Can route based on URL path, headers, cookies, user ID, etc.
* Enables advanced routing logic

**Examples**:
* Nginx (HTTP module)
* AWS ALB (Application Load Balancer)
* Traefik, Envoy

```nginx
# Nginx L7 Load Balancing
http {
  upstream web_backend {
    server 192.168.1.201;
    server 192.168.1.202;
  }
  
  server {
    listen 80;
    location / {
      proxy_pass http://web_backend;
    }
  }
}
```

## 🔐 HTTPS Workflow

### Step-by-Step
1. Client sends `HTTPS` request to server (port 443)
2. TLS Handshake:
   * Client sends `Client Hello`
   * Server replies with `Server Hello` + SSL certificate
   * Client verifies certificate via CA
   * Client generates session key → encrypts with server's public key
   * Server decrypts → shared session key established
3. Encrypted HTTP traffic starts

## 💥 What if Load Balancer Fails?

### ❗ Problem
* Entire service goes down (SPOF - Single Point of Failure)

### ✅ Solutions

#### 🔁 1. **Redundant LBs**
* Active-Passive: one standby LB
* Active-Active: both handle traffic, monitored via health checks
* Use Floating IP or Virtual IP (VIP)

#### 🌐 2. **DNS Load Balancing**
* Multiple A records returned by DNS
* Clients resolve one of them
* Works best with low DNS TTL

#### ☁️ 3. **Cloud Managed LBs**
* AWS ELB/ALB, GCP Load Balancer, Azure LB
* Auto-failover, health checks, global distribution

## ✅ Key Benefits of LB

| Feature | Benefit |
|---------|---------|
| Scalability | Add more backend servers |
| High Availability | Prevent service downtime |
| Flexibility | Route based on custom logic (L7) |
| Security | Hide backend servers (Private IPs) |

## 🧠 Bonus Tip
Always **monitor and alert** LB health via:
* Uptime Robot, Prometheus, Grafana, etc.
* Set up alerts if latency or 5xx errors increase