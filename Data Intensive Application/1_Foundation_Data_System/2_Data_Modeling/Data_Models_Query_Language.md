### Data Models

Layer 1: Application developer: People, Organisations, Sensors models/Objects in DSA/ API Representation
Layer 2: MODELS/OBJECTS Stored in JSON/ XML, TABLES in DB
Layer 3: JSON/XML stored as BYTES IN memory, disk
Layer 4: bytes in electric current, pulses of light, magnetic field 

#### Model
Hierarchicahl model
* Every record has one parent
Network Model
* Every record has more than one parent
* Tree like structure
* link between record are like pointers
* accessing record was to follow path from root record along these chains
Relational Model
* relation row of tuples
* query optimizer optimises using access path created by it

### Object - Relation mismatch
impedence mismatch : Model in DB is different from Model in Application. So Layer is required to clean up

ORM (Hibernate or Active Record) -> Hides boiler plate code

1. Traditional Normalization is to put postion eduacation other models in seperate table
2. Later XML/JSON multivalued data stored in single row with quering and index support inside the documents
3. Third is to encode jobs/eductation/contact as JSON/XML document store it on text column in DB

### Localization / Locality
* Single Document Contails all Data - accessible easy
* Multi Document with data accross tables - accessible slow
Locality on JSON/XML is more than multi-table schema

### Normalization
Removing Duplication accross table is the key idea behind normalization in DB

### Comparison to document databases
*representing many-to-one and many-to-many relation‐
ships, relational and document databases are not fundamentally different:

### Notes
Normalization
Denormalization

### Models
Many to Many -> Denormalization -> multiple joins application code by api
Many to Many -> Nornmalization -> joins in RDBMS

### Schema flexibility in the document model
homogeneous  - consistent object
hetrogeneous - different object
* schema on read (runtime type like python)
* schema on write(compile type like java)

### MapReduceQuery
Model to proceess large amount of data accross multiple computers
for
### Graph like Data Models
* Many to Many relation huge so model data as graph
Algorithm
* Car navigation - shortest path
* Page rank - 