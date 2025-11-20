# Query Languages for Data

## Imperative vs Declarative Approaches

### Imperative (How)
```javascript
function getSharks() {
  var sharks = [];
  for (var i = 0; i < animals.length; i++) {
    if (animals[i].family === "Sharks") {
      sharks.push(animals[i]);
    }
  }
  return sharks;
}
```


### Delcarative 
```
SELECT * FROM animals WHERE family = 'Sharks';
```

# Imperative vs Declarative Querying

---

## 🔑 Key Differences

| Characteristic   | Imperative                     | Declarative                          |
|------------------|--------------------------------|--------------------------------------|
| **Focus**        | Step-by-step instructions      | Desired result pattern               |
| **Optimization** | Hard-coded by developer        | Handled by query engine              |
| **Parallelization** | Difficult                    | Easier                               |
| **Flexibility**  | Brittle to schema changes      | More adaptable                       |

---

## 🧪 MapReduce: A Hybrid Approach

### 📦 MongoDB Example: Counting Sharks Per Month

```javascript
db.observations.mapReduce(
  function map() {
    emit(this.observationTimestamp.getMonth(), this.numAnimals);
  },
  function reduce(key, values) {
    return Array.sum(values);
  },
  { query: { family: "Sharks" } }
);
```

### SQL 
```
SELECT 
  EXTRACT(MONTH FROM observation_timestamp) AS month,
  SUM(num_animals) AS total
FROM observations
WHERE family = 'Sharks'
GROUP BY month;

```