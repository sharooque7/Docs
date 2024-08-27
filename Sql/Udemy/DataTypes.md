### Data Types

### Boolean

TRUE FALSE and NULL

#### True

> TRUE, 'true', 't', 'f', 'yes', '1'

### False

> FALSE, 'false', 'f', 'n', 'no', '0'

### Character

Text , number and symbols

| Character Types                  | Notes                             |
| -------------------------------- | --------------------------------- |
| Character(n), CHAR(n)            | fixed-length, blank padded        |
| Character varying(n), VARCHAR(n) | variable-length with length limit |
| Text, VARCHAR                    | variable unlimited lenght         |

### Numeric

#### Integer
> Whole numbers , positive and negative
> smallint, integer , bigint
* ### Serial Auto increment
  * smallserial
  * serial
  * bigserial
Two format of fractions of whole numbers
### Fixed-point
> numeric(precision,scale)
> decimal(precisi on,scale)
### Floating point
>real - 6 precision
> double - 15 precison

### Date and Time
> Date - Only Date
> Time - Only Time
> Timestamp - Date and Time
> Timestampz - Date , Time and timestamp
> Interval - store values

### Date
Default format - YYYY-MM-DD
CURRENT_DATE
### Time
Default format - HH:MM:SS
HH:MM:SS.pppppp
HHMMSS.ppppppp
### Interval
> interval 'n type'
> type - seconds, mintues, hours, days, weeks, month, year
### Timestamp and tz
timestamp with out timezone
timestamptz with timezone

Stores in UTC internally

### UUID
> Universally Unique Identifier

### Array

phones text []

### hstore key value
create extension
### JSON

### Network Address
> Cidr
> inet
> macaddr
> macaddr8
