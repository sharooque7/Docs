Excellent 👏 — knowing **all key Hibernate (and JPA) annotations** is absolutely essential if you want to work at a **senior Java backend level**.

Below is a **complete, categorized list** of **Hibernate + JPA annotations**, including lesser-known but *interview-critical* ones, explained clearly.

---

## 🧩 1. Core Entity Mapping Annotations

| Annotation                                              | Description                                                                                              |
| ------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| `@Entity`                                               | Marks a class as a persistent entity. Maps to a DB table.                                                |
| `@Table(name = "table_name")`                           | Defines the database table name and schema for the entity.                                               |
| `@Id`                                                   | Declares the primary key field.                                                                          |
| `@GeneratedValue(strategy = …)`                         | Specifies how the primary key is generated — `AUTO`, `IDENTITY`, `SEQUENCE`, or `TABLE`.                 |
| `@Column(name = "column_name")`                         | Customizes column name, type, nullability, uniqueness, etc.                                              |
| `@Transient`                                            | Field not persisted to the database.                                                                     |
| `@Enumerated(EnumType.STRING/ORDINAL)`                  | Stores enums as strings or integers.                                                                     |
| `@Lob`                                                  | Marks a field as a large object (CLOB/BLOB).                                                             |
| `@Temporal(TemporalType.DATE/TIME/TIMESTAMP)`           | Defines how Java `Date`/`Calendar` is stored. *(Deprecated in Hibernate 6; use `@JdbcTypeCode` instead)* |
| `@Basic(fetch = FetchType.LAZY/EAGER, optional = true)` | Configures fetching and nullability for simple fields.                                                   |
| `@Access(AccessType.FIELD/PROPERTY)`                    | Defines whether mapping uses field or getter/setter access.                                              |

---

## ⚙️ 2. Relationship Mapping Annotations

### 🔸 One-to-One

| Annotation                          | Description                                                                     |
| ----------------------------------- | ------------------------------------------------------------------------------- |
| `@OneToOne`                         | Defines one-to-one relationship between entities.                               |
| `@JoinColumn(name = "foreign_key")` | Defines foreign key column in one-to-one or many-to-one mapping.                |
| `@MapsId`                           | Indicates that the child’s primary key is the same as the parent’s (shared PK). |
| `@PrimaryKeyJoinColumn`             | Defines PK-based join instead of FK.                                            |

---

### 🔸 One-to-Many / Many-to-One

| Annotation                                                          | Description                                                       |
| ------------------------------------------------------------------- | ----------------------------------------------------------------- |
| `@OneToMany(mappedBy = "field")`                                    | Defines one-to-many relationship (parent → list of children).     |
| `@ManyToOne`                                                        | Defines many-to-one relationship (child → parent).                |
| `@JoinColumn`                                                       | Specifies foreign key column in `@ManyToOne`.                     |
| `@OnDelete(action = OnDeleteAction.CASCADE)` *(Hibernate specific)* | Enforces cascade delete at database level (not just ORM cascade). |

---

### 🔸 Many-to-Many

| Annotation                                                                     | Description                                           |
| ------------------------------------------------------------------------------ | ----------------------------------------------------- |
| `@ManyToMany`                                                                  | Defines many-to-many relationship between entities.   |
| `@JoinTable(name = "join_table", joinColumns = ..., inverseJoinColumns = ...)` | Defines custom join table for many-to-many relations. |

---

### 🔸 Relationship Tuning

| Annotation                                                                      | Description                                         |
| ------------------------------------------------------------------------------- | --------------------------------------------------- |
| `@Fetch(FetchMode.JOIN/SELECT/SUBSELECT)` *(Hibernate specific)*                | Controls fetch strategy explicitly.                 |
| `@BatchSize(size = n)` *(Hibernate specific)*                                   | Reduces N+1 problems by batch fetching collections. |
| `@LazyCollection(LazyCollectionOption.EXTRA/TRUE/FALSE)` *(Hibernate specific)* | Fine-tuned lazy loading for collections.            |

---

## 🧱 3. Identifier and Key Generation

| Annotation                                                    | Description                                                    |
| ------------------------------------------------------------- | -------------------------------------------------------------- |
| `@GeneratedValue(strategy = GenerationType.IDENTITY)`         | DB auto-increment (MySQL).                                     |
| `@SequenceGenerator(name, sequenceName, allocationSize)`      | Defines DB sequence (PostgreSQL, Oracle).                      |
| `@TableGenerator(name, table, pkColumnName, valueColumnName)` | Uses a table to manage sequence numbers.                       |
| `@GenericGenerator(name, strategy)` *(Hibernate specific)*    | Defines custom ID generation strategy (UUID, Snowflake, etc.). |
| `@UuidGenerator` *(Hibernate 6+)*                             | Simplified way to generate UUIDs.                              |

---

## 🧩 4. Cascade and Fetch Configuration

| Annotation                                                        | Description                                                     |
| ----------------------------------------------------------------- | --------------------------------------------------------------- |
| `cascade = {CascadeType.PERSIST, MERGE, REMOVE, REFRESH, DETACH}` | Defines cascade operations between entities.                    |
| `fetch = FetchType.LAZY / EAGER`                                  | Controls whether associated entity loads immediately or lazily. |

---

## 🧬 5. Inheritance Mapping

| Annotation                                                                     | Description                                                                    |
| ------------------------------------------------------------------------------ | ------------------------------------------------------------------------------ |
| `@Inheritance(strategy = InheritanceType.SINGLE_TABLE/JOINED/TABLE_PER_CLASS)` | Defines inheritance strategy.                                                  |
| `@DiscriminatorColumn(name = "type")`                                          | Specifies the column used to differentiate subclasses.                         |
| `@DiscriminatorValue("EMP")`                                                   | Defines the value for a subclass in the discriminator column.                  |
| `@MappedSuperclass`                                                            | Defines a base class whose properties are inherited but not mapped as a table. |

---

## 🧩 6. Lifecycle & Callback Annotations

| Annotation                             | Description                                      |
| -------------------------------------- | ------------------------------------------------ |
| `@PrePersist`                          | Before entity is inserted.                       |
| `@PostPersist`                         | After entity is inserted.                        |
| `@PreUpdate`                           | Before entity update.                            |
| `@PostUpdate`                          | After entity update.                             |
| `@PreRemove`                           | Before entity removal.                           |
| `@PostRemove`                          | After entity removal.                            |
| `@PostLoad`                            | After entity is loaded from DB.                  |
| `@EntityListeners(SomeListener.class)` | Registers a listener class for lifecycle events. |

---

## ⚙️ 7. Caching & Performance Annotations

| Annotation                                                                                                                      | Description                                                                     |
| ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| `@Cacheable`                                                                                                                    | Enables second-level caching for an entity.                                     |
| `@Cache(usage = CacheConcurrencyStrategy.READ_ONLY / READ_WRITE / NONSTRICT_READ_WRITE / TRANSACTIONAL)` *(Hibernate specific)* | Specifies cache strategy.                                                       |
| `@NaturalId` *(Hibernate specific)*                                                                                             | Marks a unique natural key (like username, email).                              |
| `@Immutable` *(Hibernate specific)*                                                                                             | Marks an entity as read-only (cannot be updated).                               |
| `@DynamicInsert` / `@DynamicUpdate` *(Hibernate specific)*                                                                      | Generates SQL dynamically to include only changed columns.                      |
| `@SelectBeforeUpdate` *(Hibernate specific)*                                                                                    | Forces Hibernate to issue a select before updating (for version-less entities). |

---

## 🧩 8. Query & Criteria Related Annotations

| Annotation                                                  | Description                                    |
| ----------------------------------------------------------- | ---------------------------------------------- |
| `@NamedQuery(name, query)`                                  | Defines static JPQL query at entity level.     |
| `@NamedNativeQuery(name, query, resultClass)`               | Defines native SQL query.                      |
| `@SqlResultSetMapping(name, entities = ..., columns = ...)` | Maps native SQL result to entities.            |
| `@Subselect` *(Hibernate specific)*                         | Maps an entity to a database view or subquery. |
| `@Formula("SQL_EXPRESSION")` *(Hibernate specific)*         | Maps a field to a computed SQL expression.     |

---

## 🧩 9. Auditing & Versioning

| Annotation                                  | Description                                               |
| ------------------------------------------- | --------------------------------------------------------- |
| `@Version`                                  | Used for optimistic locking — detects concurrent updates. |
| `@CreationTimestamp` *(Hibernate specific)* | Auto-populates timestamp at entity creation.              |
| `@UpdateTimestamp` *(Hibernate specific)*   | Auto-updates timestamp when entity changes.               |
| `@Audited` *(Hibernate Envers)*             | Enables historical auditing of entity changes.            |
| `@NotAudited` *(Hibernate Envers)*          | Excludes field from audit tracking.                       |

---

## 🧩 10. Multi-tenancy & Filters (Advanced)

| Annotation                                      | Description                                              |
| ----------------------------------------------- | -------------------------------------------------------- |
| `@FilterDef(name, parameters = @ParamDef(...))` | Defines reusable query filter.                           |
| `@Filter(name, condition)`                      | Applies conditional filtering dynamically.               |
| `@Any` / `@ManyToAny` *(Hibernate specific)*    | Polymorphic association — link to multiple entity types. |
| `@Type` / `@JdbcTypeCode` *(Hibernate 6+)*      | Custom type mapping to JDBC type.                        |

---

## 🧩 11. Validation (Bean Validation / JSR 380)

(Technically not Hibernate ORM annotations, but Hibernate Validator is part of Hibernate ecosystem)

| Annotation         | Description                         |
| ------------------ | ----------------------------------- |
| `@NotNull`         | Field cannot be null.               |
| `@Size(min, max)`  | Checks string or collection length. |
| `@Min`, `@Max`     | Range for numeric values.           |
| `@Pattern(regex)`  | Regex pattern for string fields.    |
| `@Email`           | Valid email format.                 |
| `@Past`, `@Future` | Date validation.                    |

---

## 🔥 Most Common in Senior-Level Interviews

✅ Must be able to explain:

* `@Entity`, `@Table`, `@Id`, `@GeneratedValue`
* `@OneToMany`, `@ManyToOne`, `@JoinColumn`, `mappedBy`
* `@Inheritance`, `@DiscriminatorColumn`
* `@Version`, `@Cache`, `@DynamicUpdate`
* `@Formula`, `@Subselect`
* `@Audited`
* `@BatchSize`, `@Fetch(FetchMode.JOIN)`

---

Would you like me to now create a **“Hibernate Annotations Reference Sheet” (Markdown or PDF)** that categorizes all these with **short code examples** (like `@OneToMany` → Java snippet + table structure)?
It’s a great asset for interview prep or documentation.
