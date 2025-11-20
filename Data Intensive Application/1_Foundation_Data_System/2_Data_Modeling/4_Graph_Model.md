# Graph-Like Data Models

## Property Graphs vs Triple Stores

| Feature | Property Graphs | Triple Stores |
|---------|----------------|--------------|
| **Structure** | Vertices + edges with properties | (subject, predicate, object) triples |
| **Query Languages** | Cypher, Gremlin | SPARQL, Datalog |
| **Flexibility** | Schema-less relationships | Uniform data representation |
| **Examples** | Neo4j, ArangoDB | Datomic, AllegroGraph |

## Key Graph Query Languages

### Cypher (Neo4j)
```cypher
MATCH (p:Person)-[:BORN_IN]->(loc)
WHERE loc.name = "Idaho"
RETURN p.name
```

### SPARQL (RDF)
```sparql
PREFIX : <urn:example:>
SELECT ?name WHERE {
 ?p a :Person; :name ?name; :bornIn [ :name "Idaho" ].
}
```

### Datalog (Datomic)
```prolog
born_in(Person, 'Idaho') :- name(Person, Name).
```

## When to Use Graph Models
**Ideal for:**
* Complex many-to-many relationships
* Connected data traversal (e.g., social networks)
* Pathfinding and recommendation systems
* Evolving schemas with new relationship types

**Comparison to Other Models:**
* More flexible than relational for interconnected data
* More structured than document for relationships
* Better path queries than either alternative

## Performance Characteristics
1. **Traversal Efficiency**: Constant-time edge traversals
2. **Scale Challenges**: Distributed graphs are complex
3. **Indexing**: Typically optimized for relationship queries

## Modern Graph Processing
**Emerging Trends:**
* Property graphs gaining wider adoption
* Multi-model databases adding graph capabilities
* Graph neural networks for ML applications

"Graph databases excel at problems where relationships are first-class citizens of your data model."