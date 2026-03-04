## **All Ways to Make APIs Idempotent - Complete Guide** 🔐

---

## **1. Idempotency Key Pattern (Most Common)**

**How it works:** Client sends unique key, server caches response

```
POST /orders
Idempotency-Key: 123e4567-e89b-12d3-a456-426614174000
```

**Storage:** Redis, DynamoDB, PostgreSQL with TTL
**Best for:** Payment, Order creation, Any write operation

---

## **2. Natural Business Keys**

**How it works:** Use existing unique field in data

```json
POST /invoices
{
    "invoiceNumber": "INV-2024-001",  // Natural key
    "amount": 100.00
}
```

**Database:** Unique constraint on invoiceNumber
**Best for:** Invoices, Transaction IDs, Reference numbers

---

## **3. Conditional Requests (ETag)**

**How it works:** Version-based updates

```
GET /products/123
Response: { "id": 123, "name": "Laptop", "version": 1 }
ETag: "v1"

PUT /products/123
If-Match: "v1"
{
    "name": "Gaming Laptop"
}
```

**Best for:** Updates, Editing, Concurrency control

---

## **4. PUT Method (Full Update)**

**How it works:** Replace entire resource

```
PUT /users/123
{
    "name": "John",
    "email": "john@email.com"
}
// Same request 100x = same result
```

**Best for:** Full resource updates, Configuration

---

## **5. Database Unique Constraints**

**How it works:** Let DB prevent duplicates

```sql
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    request_id VARCHAR(255) UNIQUE,  -- 👈 Prevents duplicates
    order_data JSONB
);
```

**INSERT with ON CONFLICT:**

```sql
INSERT INTO orders (request_id, order_data)
VALUES ('req-123', '{"product":"laptop"}')
ON CONFLICT (request_id) DO NOTHING;
```

**Best for:** Simple apps, When you want DB-level guarantees

---

## **6. Optimistic Locking**

**How it works:** Version number prevents double-processing

```sql
UPDATE orders
SET status = 'PROCESSED', version = version + 1
WHERE id = 123 AND version = 5;
-- Returns 0 if already updated
```

**Best for:** State machines, Workflow engines

---

## **7. Token-Based Idempotency**

**How it works:** Server issues single-use tokens

```
1. GET /request-token
   Response: { "token": "abc-123", "expires": "5min" }

2. POST /orders
   Idempotency-Token: abc-123
   { "product": "laptop" }
```

**Best for:** High-security, Multi-step operations

---

## **8. Request Hashing**

**How it works:** Hash of request = idempotency key

```python
import hashlib
import json

# Client generates key from request
request_data = {"product": "laptop", "qty": 1}
key = hashlib.sha256(
    json.dumps(request_data, sort_keys=True).encode()
).hexdigest()

# Same request = same key = idempotent
```

**Best for:** Caching layers, Proxy servers

---

## **9. Timestamp Window**

**How it works:** Same operation within time window = duplicate

```json
POST /api/orders
{
    "userId": "user123",
    "amount": 99.99,
    "timestamp": "2024-01-01T10:00:00Z"
}

// Any identical request within 5 minutes = duplicate
```

**Best for:** Mobile apps, Offline scenarios

---

## **10. Idempotent by Design (Natural)**

**Some operations are naturally idempotent:**

| Operation               | Why Idempotent                    |
| ----------------------- | --------------------------------- |
| `DELETE /users/123`     | Delete twice = same result (gone) |
| `GET /products`         | Read-only, no side effects        |
| `HEAD /health`          | No state change                   |
| `PUT /config`           | Full replace = same result        |
| `PATCH with full state` | If patch is deterministic         |

---

## **11. Composite Key Pattern**

**How it works:** Combine multiple fields

```json
POST /transfers
{
    "fromAccount": "ACC-123",
    "toAccount": "ACC-456",
    "amount": 100.00,
    "date": "2024-01-01",
    "sequence": "1"  // Composite key: from+to+amount+date+sequence
}
```

**Best for:** Financial transfers, Scheduled jobs

---

## **12. Event Sourcing**

**How it works:** Store events, rebuild state

```
┌────────┐     ┌──────────────┐     ┌─────────┐
│Command │────▶│ Event Store  │────▶│ Projector│
└────────┘     │ (idempotent) │     └─────────┘
               └──────────────┘
```

**Event with ID:**

```json
{
  "eventId": "evt-456",
  "type": "OrderCreated",
  "data": { "product": "laptop" }
}
// Same eventId ignored if replayed
```

**Best for:** Complex domains, Audit trails

---

## **13. Comparison Matrix**

| Method                 | Complexity | Storage       | Best For        | When to Use        |
| ---------------------- | ---------- | ------------- | --------------- | ------------------ |
| **Idempotency Key**    | Low        | Redis/DB      | Any API         | Default choice     |
| **Business Keys**      | Low        | DB only       | Invoices        | Natural keys exist |
| **Conditional (ETag)** | Medium     | None          | Updates         | Concurrent edits   |
| **PUT Method**         | Low        | None          | Full updates    | REST APIs          |
| **DB Constraints**     | Low        | DB only       | Simple apps     | Small scale        |
| **Optimistic Lock**    | Medium     | DB only       | State machines  | Workflows          |
| **Token-Based**        | High       | Token service | High security   | Banking            |
| **Request Hashing**    | Medium     | Cache         | Proxies         | CDN/caching        |
| **Timestamp Window**   | Medium     | Time series   | Mobile          | Offline apps       |
| **Event Sourcing**     | High       | Event store   | Complex domains | Audit required     |

---

## **14. Decision Tree**

```
Need idempotent API?
        │
        ▼
┌───────────────────┐
│ Is operation      │
│ naturally         │───Yes──→ Use natural method
│ idempotent?       │         (GET/DELETE/PUT)
└───────────────────┘
        │ No
        ▼
┌───────────────────┐
│ Have business     │
│ unique key?       │───Yes──→ DB unique constraint
└───────────────────┘
        │ No
        ▼
┌───────────────────┐
│ Scale?            │
├─────────┬─────────┤
│   Low   │  High   │
│   ▼     │   ▼     │
│PostgreSQL│  Redis │
│+ index  │ Cluster│
└─────────┴─────────┘
```

---

## **15. Production Checklist** ✅

- [ ] Choose method based on use case (not just popularity)
- [ ] Define TTL for stored keys (24h default, 90d for payments)
- [ ] Handle key reuse with different requests (409 Conflict)
- [ ] Monitor cache hit ratio
- [ ] Clean up expired records
- [ ] Document idempotency requirements for clients
- [ ] Test retry scenarios in QA
- [ ] Have fallback for storage failure

---

## **16. Quick Interview Answer**

> **"Idempotent APIs can be implemented multiple ways: Idempotency Keys (client-generated UUIDs with server-side caching) is most common. Natural business keys with DB constraints work when available. Conditional requests with ETags for updates. PUT methods are naturally idempotent. For financial systems, token-based or timestamp window patterns add extra safety. Choice depends on your use case, scale, and existing data model."**
