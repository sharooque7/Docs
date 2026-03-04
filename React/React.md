## **📋 TABLE OF CONTENTS**

1. [What is React?](#1-what-is-react)
2. [React vs Traditional DOM Manipulation](#2-react-vs-traditional-dom-manipulation)
3. [Core Concepts](#3-core-concepts)
4. [JSX Deep Dive](#4-jsx-deep-dive)
5. [Components](#5-components)
6. [Props vs State](#6-props-vs-state)
7. [React Hooks](#7-react-hooks)
8. [useState Hook](#8-usestate-hook)
9. [useEffect Hook](#9-useeffect-hook)
10. [useContext Hook](#10-usecontext-hook)
11. [useReducer Hook](#11-usereducer-hook)
12. [useMemo & useCallback](#12-usememo--usecallback)
13. [useRef Hook](#13-useref-hook)
14. [Custom Hooks](#14-custom-hooks)
15. [React 19 New Hooks](#15-react-19-new-hooks)
16. [Component Lifecycle](#16-component-lifecycle)
17. [Event Handling](#17-event-handling)
18. [Conditional Rendering](#18-conditional-rendering)
19. [Lists and Keys](#19-lists-and-keys)
20. [Forms in React](#20-forms-in-react)
21. [Refs in React](#21-refs-in-react)
22. [Context API](#22-context-api)
23. [React Router](#23-react-router)
24. [Higher-Order Components (HOCs)](#24-higher-order-components-hocs)
25. [React Fiber](#25-react-fiber)
26. [Performance Optimization](#26-performance-optimization)
27. [Code Splitting](#27-code-splitting)
28. [Testing in React](#28-testing-in-react)
29. [Styling in React](#29-styling-in-react)
30. [React for Java Developers](#30-react-for-java-developers)
31. [Common Interview Questions](#31-common-interview-questions)
32. [Quick Reference Cheat Sheet](#32-quick-reference-cheat-sheet)

---

## **1. WHAT IS REACT?**

> **Concept:** React is a JavaScript library for building user interfaces, developed by Facebook (Meta). It focuses on building reusable UI components and efficiently updating the DOM when data changes .

```javascript
// Simple React component
function Welcome() {
  return <h1>Hello, World!</h1>;
}

// Rendering to DOM
const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(<Welcome />);
```

### **Key Characteristics **

| Characteristic                 | Description                                                              |
| ------------------------------ | ------------------------------------------------------------------------ |
| **Component-Based**            | Build encapsulated components that manage their own state                |
| **Declarative**                | Describe what the UI should look like, React handles updates             |
| **Learn Once, Write Anywhere** | React can render on server (Next.js), mobile (React Native), and desktop |
| **Virtual DOM**                | Efficient updates via in-memory representation of the DOM                |

### **Why React? **

| Benefit                 | Explanation                                |
| ----------------------- | ------------------------------------------ |
| **Reusable Components** | Build once, use everywhere, consistent UI  |
| **Fast Updates**        | No page reloads, content changes instantly |
| **React Native**        | Use same skills for mobile apps            |
| **Huge Ecosystem**      | Rich set of libraries and tools            |
| **Strong Community**    | Backed by Meta, widely adopted             |

---

## **2. REACT VS TRADITIONAL DOM MANIPULATION**

> **Concept:** React's declarative approach differs fundamentally from imperative DOM manipulation .

### **Traditional DOM Manipulation (Imperative)**

```javascript
// You tell the browser WHAT to do and HOW to do it
const element = document.getElementById("root");
element.innerHTML = "<h1>Hello, world!</h1>";

// Every update requires manual DOM queries and changes
function incrementCounter() {
  const counter = document.getElementById("counter");
  const value = parseInt(counter.textContent);
  counter.textContent = value + 1;
}
```

### **React Approach (Declarative) **

```javascript
// You describe WHAT the UI should look like
function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  );
}
```

### **Key Differences**

| Aspect                | Traditional DOM           | React                           |
| --------------------- | ------------------------- | ------------------------------- |
| **Approach**          | Imperative (step-by-step) | Declarative (describe outcome)  |
| **Updates**           | Manual DOM manipulation   | Automatic re-rendering          |
| **Code Organization** | Separate HTML/JS/CSS      | Component-based                 |
| **Performance**       | Full DOM updates          | Virtual DOM diffing             |
| **Learning Curve**    | Lower initially           | Higher initially, scales better |

### **Java Comparison for Context **

For Java developers, think of it this way:

```java
// Java (imperative) - you write steps to achieve result
public void incrementCounter() {
    int current = Integer.parseInt(counterField.getValue());
    counterField.setValue(String.valueOf(current + 1));
}
```

```javascript
// React (declarative) - you describe the result
function Counter() {
  const [count, setCount] = useState(0);
  return <button onClick={() => setCount(count + 1)}>{count}</button>;
}
```

---

## **3. CORE CONCEPTS**

> **Concept:** React is built on several fundamental concepts that work together .

### **React's Mental Model**

```
┌─────────────────────────────────────────────┐
│              REACT APPLICATION                │
├─────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │ Component│  │ Component│  │ Component│  │  Reusable building blocks
│  └──────────┘  └──────────┘  └──────────┘  │
│         │            │            │         │
│  ┌──────▼──────┬─────▼──────┬─────▼──────┐ │
│  │    Props    │    State   │   Context  │ │  Data flow
│  └─────────────┘ ───────────┘ ───────────┘ │
│         │            │            │         │
│  ┌──────▼──────┬─────▼──────┬─────▼──────┐ │
│  │  Virtual DOM│   Hooks    │   Effects  │ │  Rendering & side effects
│  └─────────────┘ ───────────┘ ───────────┘ │
└─────────────────────────────────────────────┘
```

### **Fundamental Concepts**

| Concept        | Description                    | Example                                 |
| -------------- | ------------------------------ | --------------------------------------- |
| **Components** | Reusable UI pieces             | `<Button />`, `<UserProfile />`         |
| **JSX**        | HTML-like syntax in JavaScript | `<div className="container">`           |
| **Props**      | Data passed to components      | `<User name="John" age={30} />`         |
| **State**      | Internal component data        | `const [count, setCount] = useState(0)` |
| **Hooks**      | Functions for state/effects    | `useEffect(() => {...}, [])`            |

---

## **4. JSX DEEP DIVE**

> **Concept:** JSX is a syntax extension that lets you write HTML-like code inside JavaScript files. It's transformed into React.createElement calls .

### **JSX Rules **

| Rule                       | Correct                        | Incorrect                   |
| -------------------------- | ------------------------------ | --------------------------- |
| **Single Root Element**    | `<div>...</div>` or `<>...</>` | `<h1>Title</h1><p>Text</p>` |
| **Close All Tags**         | `<img />`, `<br />`            | `<img>`, `<br>`             |
| **camelCase Attributes**   | `className`, `onClick`         | `class`, `onclick`          |
| **JavaScript Expressions** | `{variable}`                   | `${variable}`               |

### **JSX Examples**

```javascript
// Basic JSX
const element = <h1>Hello, world!</h1>;

// With JavaScript expressions (curly braces)
function Greeting({ name, items }) {
  return (
    <div>
      <h1>Hello, {name}!</h1>
      <p>You have {items.length} items</p>
      <ul>
        {items.map((item) => (
          <li key={item.id}>{item.text}</li>
        ))}
      </ul>
    </div>
  );
}

// JSX is just function calls
const element = (
  <div className="container">
    <h1>Title</h1>
  </div>
);

// Transpiles to:
const element = React.createElement(
  "div",
  { className: "container" },
  React.createElement("h1", null, "Title"),
);
```

### **JSX vs HTML Differences **

| HTML                 | JSX                        | Reason                              |
| -------------------- | -------------------------- | ----------------------------------- |
| `class`              | `className`                | `class` is JavaScript reserved word |
| `for`                | `htmlFor`                  | `for` is JavaScript reserved word   |
| `style="color: red"` | `style={{ color: 'red' }}` | Style as object                     |
| `onclick`            | `onClick`                  | camelCase convention                |
| `tabindex`           | `tabIndex`                 | camelCase convention                |

### **Embedding Expressions **

```javascript
function Example({ user, isLoggedIn }) {
  const style = {
    backgroundColor: isLoggedIn ? "green" : "red",
    fontSize: user?.preferences?.fontSize || "16px",
  };

  return (
    <div style={style}>
      {/* Variable reading */}
      <h1>Hello, {user.name}!</h1>

      {/* Ternary for conditional */}
      <p>{isLoggedIn ? "Welcome back!" : "Please log in"}</p>

      {/* Map for lists */}
      <ul>
        {user.favorites.map((item) => (
          <li key={item.id}>{item.name}</li>
        ))}
      </ul>

      {/* Short-circuit evaluation */}
      {user.isAdmin && <AdminPanel />}
    </div>
  );
}
```

### **JSX Security **

```javascript
// JSX automatically escapes content to prevent XSS attacks
const userContent = '<script>alert("hack")</script>';
const safe = <div>{userContent}</div>; // Renders as text, not script

// When you NEED to render HTML (be careful!)
const htmlContent = "<strong>Important</strong>";
const dangerous = <div dangerouslySetInnerHTML={{ __html: htmlContent }} />;
```

---

## **5. COMPONENTS**

> **Concept:** Components are the building blocks of React applications. They can be functions or classes that return JSX .

### **Types of Components**

#### **Functional Components (Modern) **

```javascript
// Simple functional component
function Welcome({ name }) {
  return <h1>Hello, {name}!</h1>;
}

// With hooks (state, effects)
function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  );
}

// Arrow function syntax
const Button = ({ onClick, children }) => (
  <button onClick={onClick}>{children}</button>
);
```

#### **Class Components (Legacy) **

```javascript
class Welcome extends React.Component {
  render() {
    return <h1>Hello, {this.props.name}!</h1>;
  }
}

class Counter extends React.Component {
  constructor(props) {
    super(props);
    this.state = { count: 0 };
  }

  increment = () => {
    this.setState({ count: this.state.count + 1 });
  };

  render() {
    return (
      <div>
        <p>Count: {this.state.count}</p>
        <button onClick={this.increment}>Increment</button>
      </div>
    );
  }
}
```

### **Functional vs Class Components **

| Aspect             | Functional       | Class                           |
| ------------------ | ---------------- | ------------------------------- |
| **Syntax**         | Simple function  | Class extending React.Component |
| **State**          | `useState` hook  | `this.state`, `this.setState`   |
| **Lifecycle**      | `useEffect` hook | Lifecycle methods               |
| **`this` binding** | Not needed       | Required                        |
| **Code size**      | Smaller          | Larger                          |
| **Performance**    | Better           | Good                            |
| **Modern React**   | Recommended      | Legacy                          |

**Interview Tip:** "Modern React uses functional components with hooks. Class components are still seen in older codebases and for error boundaries (no hook equivalent yet). Always use functional components for new code."

### **Component Composition**

```javascript
// Components can be composed like HTML
function App() {
  return (
    <div className="app">
      <Header />
      <Sidebar>
        <Navigation />
      </Sidebar>
      <MainContent>
        <Article title="Hello" content="World" />
      </MainContent>
      <Footer />
    </div>
  );
}

// Passing components as children
function Card({ title, children }) {
  return (
    <div className="card">
      <h2>{title}</h2>
      <div className="card-content">{children}</div>
    </div>
  );
}

// Usage
<Card title="User Info">
  <p>Name: John</p>
  <p>Email: john@example.com</p>
</Card>;
```

---

## **6. PROPS VS STATE**

> **Concept:** Two core concepts for managing data in React components. Props are read-only data passed from parent, state is mutable data owned by the component .

### **Props (Properties) **

```javascript
// Parent passing props
function Parent() {
  return (
    <Child
      name="Alice" // string
      age={30} // number
      isAdmin={true} // boolean
      user={{ id: 1, name: "Alice" }} // object
      onClick={() => alert("clicked")} // function
    />
  );
}

// Child receiving props
function Child(props) {
  return (
    <div>
      <h1>Hello, {props.name}</h1>
      <p>Age: {props.age}</p>
      <button onClick={props.onClick}>Click me</button>
    </div>
  );
}

// Destructuring props (modern style)
function Child({ name, age, isAdmin, user, onClick }) {
  return (
    <div>
      <h1>Hello, {name}</h1>
      <p>Age: {age}</p>
      {isAdmin && <AdminPanel user={user} />}
    </div>
  );
}

// Default props
function Button({ text = "Click me", color = "blue" }) {
  return <button style={{ backgroundColor: color }}>{text}</button>;
}
```

### **State **

```javascript
import { useState } from "react";

function Counter() {
  // useState returns [currentState, setterFunction]
  const [count, setCount] = useState(0);

  const increment = () => {
    setCount(count + 1); // Update state
  };

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={increment}>+</button>
    </div>
  );
}

// State with objects
function UserForm() {
  const [user, setUser] = useState({
    name: "",
    email: "",
    age: 0,
  });

  const updateName = (name) => {
    setUser({ ...user, name }); // Spread to preserve other fields
  };

  return (
    <div>
      <input value={user.name} onChange={(e) => updateName(e.target.value)} />
    </div>
  );
}
```

### **Props vs State Comparison **

| Aspect         | Props                    | State                    |
| -------------- | ------------------------ | ------------------------ |
| **Definition** | Data passed from parent  | Data owned by component  |
| **Mutability** | Read-only (immutable)    | Mutable via setter       |
| **Ownership**  | Parent component         | Component itself         |
| **Changes**    | Parent re-renders        | Component calls setState |
| **Purpose**    | Configuration, callbacks | Dynamic data, user input |

### **Lifting State Up **

When multiple components need to share state, lift it to their common parent.

```javascript
function Parent() {
  const [sharedValue, setSharedValue] = useState("");

  return (
    <div>
      <ChildA value={sharedValue} onChange={setSharedValue} />
      <ChildB value={sharedValue} />
    </div>
  );
}

function ChildA({ value, onChange }) {
  return <input value={value} onChange={(e) => onChange(e.target.value)} />;
}

function ChildB({ value }) {
  return <p>Current value: {value}</p>;
}
```

---

## **7. REACT HOOKS**

> **Concept:** Hooks are functions that let you use React features (state, lifecycle, context) in functional components. Introduced in React 16.8 .

### **Hooks Rules **

1. **Call hooks at the top level** – Never inside loops, conditions, or nested functions
2. **Call hooks from React functions only** – From React components or custom hooks
3. **Same order every render** – React relies on consistent hook order

```javascript
// ✅ Correct - hooks at top level
function Counter() {
  const [count, setCount] = useState(0); // Hook 1
  const [name, setName] = useState(""); // Hook 2
  useEffect(() => {
    // Hook 3
    document.title = `Count: ${count}`;
  }, [count]);

  // ❌ Wrong - hook in condition
  if (count > 0) {
    // useEffect(() => { ... });  // Don't do this!
  }

  return <div>...</div>;
}
```

### **Why Hooks?**

| Problem with Classes                               | Hook Solution                    |
| -------------------------------------------------- | -------------------------------- |
| Complex lifecycle methods                          | `useEffect` for all side effects |
| `this` binding confusion                           | No `this` in functions           |
| Logic reuse requires patterns (HOCs, render props) | Custom hooks for reusable logic  |
| Large components                                   | Split with multiple hooks        |

### **Built-in Hooks Overview**

| Hook                  | Purpose                | When to Use                           |
| --------------------- | ---------------------- | ------------------------------------- |
| `useState`            | Local state management | Form inputs, toggles, counters        |
| `useEffect`           | Side effects           | API calls, subscriptions, DOM updates |
| `useContext`          | Context consumption    | Theme, auth, global state             |
| `useReducer`          | Complex state logic    | State with multiple sub-values        |
| `useCallback`         | Memoize functions      | Prevent unnecessary re-renders        |
| `useMemo`             | Memoize values         | Expensive computations                |
| `useRef`              | Mutable references     | DOM access, instance variables        |
| `useLayoutEffect`     | Synchronous effects    | DOM measurements, animations          |
| `useImperativeHandle` | Customize ref value    | When exposing methods to parent       |
| `useDebugValue`       | Custom hook labeling   | DevTools debugging                    |

---

## **8. USESTATE HOOK**

> **Concept:** `useState` adds state variables to functional components. It returns an array with the current state and a function to update it .

### **Basic Usage**

```javascript
import { useState } from "react";

function Counter() {
  // Syntax: const [state, setState] = useState(initialValue)
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>Click me</button>
    </div>
  );
}
```

### **Different Data Types **

```javascript
function StateExamples() {
  // Primitives
  const [count, setCount] = useState(0);
  const [name, setName] = useState("");
  const [isActive, setIsActive] = useState(false);

  // Objects
  const [user, setUser] = useState({
    name: "",
    email: "",
    age: 0,
  });

  const updateUser = (field, value) => {
    setUser({ ...user, [field]: value }); // Must create new object
  };

  // Arrays
  const [items, setItems] = useState([]);

  const addItem = (item) => {
    setItems([...items, item]); // Must create new array
  };

  const removeItem = (index) => {
    setItems(items.filter((_, i) => i !== index));
  };

  return <div>...</div>;
}
```

### **Important Rules **

```javascript
function StateRules() {
  const [count, setCount] = useState(0);

  // ❌ Wrong - direct mutation doesn't trigger re-render
  const wrongIncrement = () => {
    count++; // This won't work!
  };

  // ✅ Correct - use setter
  const correctIncrement = () => {
    setCount(count + 1);
  };

  // ✅ Functional update (when new state depends on previous)
  const safeIncrement = () => {
    setCount((prevCount) => prevCount + 1);
  };

  // ⚠️ Important: setState doesn't update immediately in current render
  const logAfterSet = () => {
    setCount(5);
    console.log(count); // Still old value!
  };

  // ✅ Solution for multiple updates
  const handleMultipleUpdates = () => {
    setCount((prev) => prev + 1);
    setCount((prev) => prev + 1);
    setCount((prev) => prev + 1); // Final: +3
  };

  return <div>...</div>;
}
```

### **Lazy Initialization **

For expensive initial state calculations:

```javascript
// ❌ Expensive calculation runs every render
const [state, setState] = useState(expensiveComputation());

// ✅ Runs only once (initial render)
const [state, setState] = useState(() => {
  const initialData = expensiveComputation();
  return initialData;
});
```

### **State Best Practices**

| Practice                | Why                           | Example                      |
| ----------------------- | ----------------------------- | ---------------------------- |
| **Multiple state vars** | Simpler updates, less merging | `useState` for each field    |
| **Object state**        | Related data together         | `setUser({ ...user, name })` |
| **Functional updates**  | Avoids stale closures         | `setCount(c => c + 1)`       |
| **Lazy initialization** | Expensive computations        | `useState(() => compute())`  |

---

## **9. USEEFFECT HOOK**

> **Concept:** `useEffect` lets you perform side effects in functional components. It runs after rendering and can clean up after itself .

### **Basic Usage**

```javascript
import { useEffect, useState } from "react";

function Example() {
  const [count, setCount] = useState(0);

  // Runs after every render
  useEffect(() => {
    document.title = `You clicked ${count} times`;
  });

  return <button onClick={() => setCount(count + 1)}>Click</button>;
}
```

### **Effect Dependencies **

```javascript
// 1. No dependency array - runs after EVERY render
useEffect(() => {
  console.log("Runs after every render");
});

// 2. Empty array [] - runs ONCE after initial mount
useEffect(() => {
  console.log("Runs only once (on mount)");
  // Perfect for API calls on load
  fetchData();
}, []);

// 3. With dependencies - runs when dependencies change
useEffect(() => {
  console.log("Runs when count changes");
}, [count]);

// 4. Multiple dependencies
useEffect(() => {
  console.log("Runs when count or name changes");
}, [count, name]);
```

### **Cleanup Function **

```javascript
function Timer() {
  const [seconds, setSeconds] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      setSeconds((s) => s + 1);
    }, 1000);

    // Cleanup function - runs on unmount and before next effect
    return () => {
      clearInterval(interval);
      console.log("Timer cleaned up");
    };
  }, []); // Empty array = cleanup on unmount only

  return <div>Seconds: {seconds}</div>;
}
```

### **Common Use Cases **

```javascript
// 1. Data fetching
function UserProfile({ userId }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    fetch(`/api/users/${userId}`)
      .then((res) => res.json())
      .then((data) => {
        setUser(data);
        setLoading(false);
      });
  }, [userId]); // Re-fetch when userId changes

  if (loading) return <div>Loading...</div>;
  return <div>{user.name}</div>;
}

// 2. Event listeners
function WindowWidth() {
  const [width, setWidth] = useState(window.innerWidth);

  useEffect(() => {
    const handleResize = () => setWidth(window.innerWidth);

    window.addEventListener("resize", handleResize);

    return () => {
      window.removeEventListener("resize", handleResize);
    };
  }, []); // Setup once, cleanup on unmount

  return <div>Window width: {width}</div>;
}

// 3. Subscriptions
function ChatRoom({ roomId }) {
  const [messages, setMessages] = useState([]);

  useEffect(() => {
    const subscription = chatAPI.subscribe(roomId, (message) => {
      setMessages((prev) => [...prev, message]);
    });

    return () => {
      subscription.unsubscribe();
    };
  }, [roomId]);

  return <div>Messages: {messages.length}</div>;
}
```

### **useEffect vs Lifecycle Methods**

| Class Component                 | Functional with useEffect                                    |
| ------------------------------- | ------------------------------------------------------------ |
| `componentDidMount`             | `useEffect(() => {...}, [])`                                 |
| `componentDidUpdate`            | `useEffect(() => {...})` or `useEffect(() => {...}, [deps])` |
| `componentWillUnmount`          | `useEffect(() => { return () => {...} }, [])`                |
| `componentDidUpdate(prevProps)` | Use ref or compare in effect                                 |

### **Common Pitfalls**

```javascript
// ❌ Infinite loop (updates state in effect without deps)
useEffect(() => {
  setCount(count + 1); // Causes re-render -> runs again
});

// ✅ Correct - empty deps or functional update
useEffect(() => {
  setCount((c) => c + 1);
}, []);

// ❌ Missing dependencies
useEffect(() => {
  console.log(name); // 'name' changes but effect doesn't track it
}, []); // Should include [name]

// ✅ Correct - include all dependencies
useEffect(() => {
  console.log(name);
}, [name]);
```

### **Effect Patterns**

| Pattern           | Code                                          | Use Case                        |
| ----------------- | --------------------------------------------- | ------------------------------- |
| **Run once**      | `useEffect(() => {...}, [])`                  | Initial data fetch              |
| **Run on change** | `useEffect(() => {...}, [dep])`               | React to prop/state changes     |
| **Cleanup**       | `useEffect(() => { return () => {...} }, [])` | Remove listeners, subscriptions |
| **Skip on mount** | Use ref to track first render                 | Avoid initial effect            |

---

## **10. USECONTEXT HOOK**

> **Concept:** `useContext` provides a way to pass data through the component tree without manually passing props at every level .

### **When to Use Context **

- **Theme** (light/dark mode)
- **User authentication** (current user, login state)
- **Language/Locale** (i18n)
- **Global UI state** (notifications, modals)

### **Context vs Props **

| Aspect           | Props                        | Context                          |
| ---------------- | ---------------------------- | -------------------------------- |
| **Passing data** | Explicit (parent → child)    | Implicit (any level)             |
| **Boilerplate**  | Prop drilling for deep trees | Provider setup required          |
| **Performance**  | Natural, predictable         | Can cause unnecessary re-renders |
| **When to use**  | Local, shallow data          | Global, frequently accessed data |

### **Basic Usage**

```javascript
// 1. Create context
import { createContext, useContext, useState } from "react";

const ThemeContext = createContext();

// 2. Create provider component
function ThemeProvider({ children }) {
  const [theme, setTheme] = useState("light");

  const toggleTheme = () => {
    setTheme((prev) => (prev === "light" ? "dark" : "light"));
  };

  // Value provided to all consumers
  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

// 3. Consume in child component
function ThemedButton() {
  const { theme, toggleTheme } = useContext(ThemeContext);

  return (
    <button
      onClick={toggleTheme}
      style={{
        backgroundColor: theme === "light" ? "#fff" : "#333",
        color: theme === "light" ? "#333" : "#fff",
      }}
    >
      Current theme: {theme}
    </button>
  );
}

// 4. Wrap app with provider
function App() {
  return (
    <ThemeProvider>
      <div>
        <h1>My App</h1>
        <ThemedButton />
        <ThemedButton />
        {/* All buttons share same theme state */}
      </div>
    </ThemeProvider>
  );
}
```

### **Multiple Contexts**

```javascript
// Create multiple contexts
const ThemeContext = createContext();
const UserContext = createContext();
const ConfigContext = createContext();

// Nest providers
function App() {
  return (
    <ThemeProvider>
      <UserProvider>
        <ConfigProvider>
          <MainContent />
        </ConfigProvider>
      </UserProvider>
    </ThemeProvider>
  );
}

// Consume multiple contexts
function MainContent() {
  const theme = useContext(ThemeContext);
  const user = useContext(UserContext);
  const config = useContext(ConfigContext);

  return (
    <div>
      <h1>Welcome, {user.name}</h1>
      <p>Theme: {theme}</p>
      <p>Config: {config.mode}</p>
    </div>
  );
}
```

### **Custom Hook for Context**

```javascript
// Create custom hook for better encapsulation
function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error("useTheme must be used within ThemeProvider");
  }
  return context;
}

// Usage is cleaner
function ThemedButton() {
  const { theme, toggleTheme } = useTheme(); // Much cleaner!
  return <button onClick={toggleTheme}>{theme}</button>;
}
```

### **Context vs Redux **

| Feature            | Context API                | Redux                    |
| ------------------ | -------------------------- | ------------------------ |
| **Purpose**        | Simple prop drilling       | Complex state management |
| **Boilerplate**    | Minimal                    | More setup required      |
| **Middleware**     | Not built-in               | Supports middleware      |
| **DevTools**       | Basic                      | Excellent DevTools       |
| **Performance**    | Can cause extra re-renders | Optimized by default     |
| **Learning curve** | Gentle                     | Steeper                  |

**Interview Tip:** "Use Context for simple global state (theme, auth). Use Redux for complex state with frequent updates, middleware needs, or when you need time-travel debugging."

---

## **11. USEREDUCER HOOK**

> **Concept:** `useReducer` is an alternative to `useState` for managing complex state logic that involves multiple sub-values or when next state depends on previous .

### **When to Use useReducer**

- Complex state objects with multiple fields
- State transitions that depend heavily on previous state
- State logic that is difficult to manage with multiple `useState` calls
- When you want to centralize state update logic

### **Basic Syntax**

```javascript
const [state, dispatch] = useReducer(reducer, initialState);

// reducer function: (state, action) => newState
// dispatch: sends action to reducer
```

### **Simple Counter with useReducer**

```javascript
import { useReducer } from "react";

// Reducer function
function counterReducer(state, action) {
  switch (action.type) {
    case "INCREMENT":
      return { count: state.count + 1 };
    case "DECREMENT":
      return { count: state.count - 1 };
    case "RESET":
      return { count: 0 };
    case "SET":
      return { count: action.payload };
    default:
      return state;
  }
}

function Counter() {
  const [state, dispatch] = useReducer(counterReducer, { count: 0 });

  return (
    <div>
      <p>Count: {state.count}</p>
      <button onClick={() => dispatch({ type: "INCREMENT" })}>+</button>
      <button onClick={() => dispatch({ type: "DECREMENT" })}>-</button>
      <button onClick={() => dispatch({ type: "RESET" })}>Reset</button>
      <button onClick={() => dispatch({ type: "SET", payload: 10 })}>
        Set to 10
      </button>
    </div>
  );
}
```

### **Complex Form Example**

```javascript
const initialState = {
  name: "",
  email: "",
  age: "",
  errors: {},
  isSubmitting: false,
  isSubmitted: false,
};

function formReducer(state, action) {
  switch (action.type) {
    case "FIELD_CHANGE":
      return {
        ...state,
        [action.field]: action.value,
        errors: { ...state.errors, [action.field]: null },
      };
    case "SET_ERRORS":
      return { ...state, errors: action.errors };
    case "SUBMIT_START":
      return { ...state, isSubmitting: true, errors: {} };
    case "SUBMIT_SUCCESS":
      return { ...state, isSubmitting: false, isSubmitted: true };
    case "SUBMIT_FAILURE":
      return { ...state, isSubmitting: false, errors: action.errors };
    case "RESET":
      return initialState;
    default:
      return state;
  }
}

function UserForm() {
  const [state, dispatch] = useReducer(formReducer, initialState);

  const handleSubmit = async (e) => {
    e.preventDefault();
    dispatch({ type: "SUBMIT_START" });

    try {
      // Validate
      const errors = {};
      if (!state.name) errors.name = "Name required";
      if (!state.email) errors.email = "Email required";

      if (Object.keys(errors).length > 0) {
        dispatch({ type: "SET_ERRORS", errors });
        return;
      }

      // Submit API call
      await submitForm(state);
      dispatch({ type: "SUBMIT_SUCCESS" });
    } catch (error) {
      dispatch({ type: "SUBMIT_FAILURE", errors: { api: error.message } });
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        value={state.name}
        onChange={(e) =>
          dispatch({
            type: "FIELD_CHANGE",
            field: "name",
            value: e.target.value,
          })
        }
      />
      {state.errors.name && <span>{state.errors.name}</span>}

      <button type="submit" disabled={state.isSubmitting}>
        {state.isSubmitting ? "Submitting..." : "Submit"}
      </button>
    </form>
  );
}
```

### **useState vs useReducer **

| Aspect             | useState                     | useReducer                 |
| ------------------ | ---------------------------- | -------------------------- |
| **State type**     | Simple (primitives, objects) | Complex (objects, arrays)  |
| **Transitions**    | Few update patterns          | Many update patterns       |
| **Logic location** | In event handlers            | Centralized in reducer     |
| **Testing**        | Harder (UI-dependent)        | Easy (pure function)       |
| **Debugging**      | Harder                       | Easier (action logging)    |
| **Performance**    | Good                         | Better for complex updates |

### **Combining useReducer with Context**

```javascript
// Create context + reducer combo (mini Redux)
const AppContext = createContext();

function AppProvider({ children }) {
  const [state, dispatch] = useReducer(appReducer, initialState);

  return (
    <AppContext.Provider value={{ state, dispatch }}>
      {children}
    </AppContext.Provider>
  );
}

// Custom hooks for accessing context
function useAppState() {
  return useContext(AppContext).state;
}

function useAppDispatch() {
  return useContext(AppContext).dispatch;
}

// Usage in components
function UserProfile() {
  const state = useAppState();
  const dispatch = useAppDispatch();

  return (
    <div>
      <h1>{state.user.name}</h1>
      <button onClick={() => dispatch({ type: "LOGOUT" })}>Logout</button>
    </div>
  );
}
```

---

## **12. USEMEMO & USECALLBACK**

> **Concept:** Performance optimization hooks that memoize values and functions to prevent unnecessary re-renders .

### **Why Memoization?**

```javascript
// Without memoization - expensive calculation runs on EVERY render
function ExpensiveComponent({ data }) {
  const processedData = data.map((item) => {
    // Expensive operation
    return heavyComputation(item);
  });

  return <div>{processedData}</div>;
}

// With useMemo - only recalculates when data changes
function OptimizedComponent({ data }) {
  const processedData = useMemo(() => {
    return data.map((item) => heavyComputation(item));
  }, [data]); // Only re-run if 'data' changes

  return <div>{processedData}</div>;
}
```

### **useMemo - Memoize Values**

```javascript
import { useMemo } from "react";

function ShoppingCart({ items, discount }) {
  // Memoize expensive calculation
  const total = useMemo(() => {
    console.log("Calculating total...");
    const sum = items.reduce(
      (acc, item) => acc + item.price * item.quantity,
      0,
    );
    return discount ? sum * (1 - discount) : sum;
  }, [items, discount]); // Recalculate when items or discount changes

  // Memoize derived data
  const itemCategories = useMemo(() => {
    return items.reduce((acc, item) => {
      acc[item.category] = (acc[item.category] || 0) + 1;
      return acc;
    }, {});
  }, [items]);

  return (
    <div>
      <p>Total: ${total}</p>
      <p>Categories: {JSON.stringify(itemCategories)}</p>
    </div>
  );
}
```

### **useCallback - Memoize Functions**

```javascript
import { useCallback } from "react";

function ParentComponent() {
  const [count, setCount] = useState(0);

  // Without useCallback - new function created every render
  const handleClick = () => {
    console.log("Clicked");
  };

  // With useCallback - same function reference between renders
  const memoizedHandleClick = useCallback(() => {
    console.log("Clicked, count:", count);
  }, [count]); // Recreate when count changes

  return (
    <div>
      <button onClick={() => setCount((c) => c + 1)}>Count: {count}</button>
      <ChildComponent onClick={memoizedHandleClick} />
    </div>
  );
}

// ChildComponent wrapped with React.memo - only re-renders if props change
const ChildComponent = React.memo(({ onClick }) => {
  console.log("Child rendered");
  return <button onClick={onClick}>Child Button</button>;
});
```

### **useMemo vs useCallback**

| Aspect           | useMemo                              | useCallback                            |
| ---------------- | ------------------------------------ | -------------------------------------- |
| **Returns**      | Memoized value                       | Memoized function                      |
| **Syntax**       | `useMemo(() => value, deps)`         | `useCallback(fn, deps)`                |
| **Use case**     | Expensive calculations, derived data | Passing callbacks to memoized children |
| **Dependencies** | Array of values                      | Array of values                        |

### **When to Use **

| Scenario                                      | Use           |
| --------------------------------------------- | ------------- |
| **Expensive calculations**                    | `useMemo`     |
| **Referential equality for child components** | `useCallback` |
| **Avoiding re-renders with React.memo**       | `useCallback` |
| **Derived data from props/state**             | `useMemo`     |
| **Functions in useEffect dependencies**       | `useCallback` |

### **When NOT to Use**

```javascript
// ❌ Over-optimization - simple operation doesn't need memo
const add = useMemo(() => a + b, [a, b]); // Overkill
// ✅ Just compute directly
const sum = a + b;

// ❌ Functions that don't cause re-renders
const handleClick = useCallback(() => {
  console.log("clicked");
}, []); // Not needed unless passed to memoized child

// ❌ Dependencies missing
const memoizedFn = useCallback(() => {
  doSomething(count); // Missing count dependency!
}, []); // Bug! Uses stale count
```

### **React.memo for Components**

```javascript
// Regular component - re-renders when parent re-renders
function RegularComponent({ name }) {
  return <div>{name}</div>;
}

// Memoized component - only re-renders if props change
const MemoizedComponent = React.memo(function Memoized({ name }) {
  console.log("Memoized rendered");
  return <div>{name}</div>;
});

// With custom comparison
const CustomMemo = React.memo(
  function Custom({ user }) {
    return <div>{user.name}</div>;
  },
  (prevProps, nextProps) => {
    // Only re-render if user.id changes
    return prevProps.user.id === nextProps.user.id;
  },
);
```

---

## **13. USEREF HOOK**

> **Concept:** `useRef` provides a way to access DOM elements directly and persist mutable values across renders without causing re-renders .

### **Basic Usage - DOM Access**

```javascript
import { useRef, useEffect } from "react";

function TextInput() {
  const inputRef = useRef(null);

  useEffect(() => {
    // Focus input on mount
    inputRef.current.focus();
  }, []);

  return <input ref={inputRef} type="text" />;
}
```

### **Persisting Values Across Renders**

```javascript
function Timer() {
  const [count, setCount] = useState(0);
  const intervalRef = useRef(null);

  const startTimer = () => {
    intervalRef.current = setInterval(() => {
      setCount((c) => c + 1);
    }, 1000);
  };

  const stopTimer = () => {
    clearInterval(intervalRef.current);
  };

  useEffect(() => {
    return () => clearInterval(intervalRef.current); // Cleanup
  }, []);

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={startTimer}>Start</button>
      <button onClick={stopTimer}>Stop</button>
    </div>
  );
}
```

### **useRef vs useState**

| Aspect                             | useRef                         | useState               |
| ---------------------------------- | ------------------------------ | ---------------------- |
| **Re-renders on change**           | No                             | Yes                    |
| **Value persists between renders** | Yes                            | Yes                    |
| **Mutable**                        | Yes (`.current`)               | Via setter only        |
| **Use case**                       | DOM access, instance variables | UI state, dynamic data |

### **Tracking Previous Values**

```javascript
function PreviousValue({ value }) {
  const prevValueRef = useRef();

  useEffect(() => {
    prevValueRef.current = value;
  }, [value]);

  const prevValue = prevValueRef.current;

  return (
    <div>
      <p>Current: {value}</p>
      <p>Previous: {prevValue}</p>
    </div>
  );
}
```

### **Avoiding Closure Issues**

```javascript
function DelayedLogger() {
  const [count, setCount] = useState(0);
  const countRef = useRef(count);

  // Keep ref in sync
  useEffect(() => {
    countRef.current = count;
  }, [count]);

  const logAfterDelay = () => {
    setTimeout(() => {
      // This would use stale count without ref
      console.log("Count (via ref):", countRef.current);
      console.log("Count (direct):", count); // Stale!
    }, 3000);
  };

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount((c) => c + 1)}>Increment</button>
      <button onClick={logAfterDelay}>Log after delay</button>
    </div>
  );
}
```

### **ForwardRef - Passing Refs to Children**

```javascript
// Child component with forwardRef
const FancyInput = React.forwardRef((props, ref) => {
  return <input ref={ref} className="fancy" {...props} />;
});

// Parent component
function Parent() {
  const inputRef = useRef(null);

  const focusInput = () => {
    inputRef.current.focus();
  };

  return (
    <div>
      <FancyInput ref={inputRef} placeholder="Type here" />
      <button onClick={focusInput}>Focus Input</button>
    </div>
  );
}
```

### **Common useRef Patterns**

| Pattern                     | Code                                    | Use Case                |
| --------------------------- | --------------------------------------- | ----------------------- |
| **DOM access**              | `const ref = useRef(); <div ref={ref}>` | Focus, measurements     |
| **Instance variables**      | `const intervalRef = useRef()`          | Timers, subscriptions   |
| **Previous values**         | Track with useEffect + ref              | Comparing changes       |
| **Avoid closure staleness** | Keep value in sync                      | Async callbacks         |
| **Forward refs**            | `React.forwardRef`                      | Custom input components |

---

## **14. CUSTOM HOOKS**

> **Concept:** Custom hooks let you extract component logic into reusable functions. They're JavaScript functions whose names start with `use` and can call other hooks .

### **Why Custom Hooks?**

| Benefit                    | Description                          |
| -------------------------- | ------------------------------------ |
| **Reusability**            | Share logic between components       |
| **Separation of concerns** | Move complex logic out of components |
| **Readability**            | Clean, focused components            |
| **Testability**            | Test logic independently             |

### **Basic Custom Hook**

```javascript
// useWindowSize.js
import { useState, useEffect } from "react";

function useWindowSize() {
  const [size, setSize] = useState({
    width: window.innerWidth,
    height: window.innerHeight,
  });

  useEffect(() => {
    const handleResize = () => {
      setSize({
        width: window.innerWidth,
        height: window.innerHeight,
      });
    };

    window.addEventListener("resize", handleResize);
    return () => window.removeEventListener("resize", handleResize);
  }, []);

  return size;
}

// Usage in component
function ResponsiveComponent() {
  const { width, height } = useWindowSize();

  return (
    <div>
      <p>
        Window size: {width} x {height}
      </p>
      {width < 768 ? <MobileView /> : <DesktopView />}
    </div>
  );
}
```

### **Data Fetching Hook**

```javascript
// useFetch.js
import { useState, useEffect } from "react";

function useFetch(url, options = {}) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const abortController = new AbortController();

    const fetchData = async () => {
      setLoading(true);
      try {
        const response = await fetch(url, {
          ...options,
          signal: abortController.signal,
        });

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const result = await response.json();
        setData(result);
        setError(null);
      } catch (err) {
        if (err.name !== "AbortError") {
          setError(err.message);
        }
      } finally {
        setLoading(false);
      }
    };

    fetchData();

    return () => abortController.abort();
  }, [url, JSON.stringify(options)]);

  return { data, loading, error };
}

// Usage
function UserProfile({ userId }) {
  const { data: user, loading, error } = useFetch(`/api/users/${userId}`);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;
  if (!user) return null;

  return (
    <div>
      <h1>{user.name}</h1>
      <p>Email: {user.email}</p>
    </div>
  );
}
```

### **Local Storage Hook**

```javascript
// useLocalStorage.js
import { useState, useEffect } from "react";

function useLocalStorage(key, initialValue) {
  // Get stored value or use initial
  const [storedValue, setStoredValue] = useState(() => {
    try {
      const item = window.localStorage.getItem(key);
      return item ? JSON.parse(item) : initialValue;
    } catch (error) {
      console.error(error);
      return initialValue;
    }
  });

  // Update localStorage when value changes
  useEffect(() => {
    try {
      window.localStorage.setItem(key, JSON.stringify(storedValue));
    } catch (error) {
      console.error(error);
    }
  }, [key, storedValue]);

  return [storedValue, setStoredValue];
}

// Usage
function Settings() {
  const [theme, setTheme] = useLocalStorage("theme", "light");
  const [user, setUser] = useLocalStorage("user", null);

  return (
    <div>
      <select value={theme} onChange={(e) => setTheme(e.target.value)}>
        <option value="light">Light</option>
        <option value="dark">Dark</option>
      </select>
      <button onClick={() => setUser({ name: "John" })}>Save User</button>
    </div>
  );
}
```

### **Form Handling Hook**

```javascript
// useForm.js
import { useState } from "react";

function useForm(initialValues, validate) {
  const [values, setValues] = useState(initialValues);
  const [errors, setErrors] = useState({});
  const [touched, setTouched] = useState({});

  const handleChange = (e) => {
    const { name, value } = e.target;
    setValues({ ...values, [name]: value });

    if (validate) {
      const validationErrors = validate({ ...values, [name]: value });
      setErrors(validationErrors);
    }
  };

  const handleBlur = (e) => {
    const { name } = e.target;
    setTouched({ ...touched, [name]: true });
  };

  const resetForm = () => {
    setValues(initialValues);
    setErrors({});
    setTouched({});
  };

  return {
    values,
    errors,
    touched,
    handleChange,
    handleBlur,
    resetForm,
  };
}

// Usage
function LoginForm() {
  const validate = (values) => {
    const errors = {};
    if (!values.email) errors.email = "Email required";
    if (!values.password) errors.password = "Password required";
    return errors;
  };

  const form = useForm(
    {
      email: "",
      password: "",
    },
    validate,
  );

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log(form.values);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        name="email"
        value={form.values.email}
        onChange={form.handleChange}
        onBlur={form.handleBlur}
      />
      {form.touched.email && form.errors.email && (
        <span>{form.errors.email}</span>
      )}

      <input
        type="password"
        name="password"
        value={form.values.password}
        onChange={form.handleChange}
        onBlur={form.handleBlur}
      />

      <button type="submit">Submit</button>
    </form>
  );
}
```

### **Custom Hook Rules**

| Rule                       | Explanation                                  |
| -------------------------- | -------------------------------------------- |
| **Name starts with `use`** | Required for linting                         |
| **Can call other hooks**   | Use built-in hooks inside                    |
| **Independent state**      | Each hook instance has its own state         |
| **Reusable**               | Same hook can be used in multiple components |
| **Pure**                   | Should not have side effects directly        |

---

## **15. REACT 19 NEW HOOKS**

> **Concept:** React 19 introduced several new hooks to improve performance and developer experience, especially for form handling and mutations .

### **useActionState Hook**

`useActionState` simplifies handling async actions with loading and error states, replacing the verbose pattern of multiple `useState` calls .

```javascript
import { useActionState } from "react";

// ❌ The old way - verbose and error-prone
function UserFormOld() {
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);
  const [user, setUser] = useState(null);

  const handleSubmit = async (formData) => {
    setIsLoading(true);
    setError(null);

    try {
      const result = await createUser(formData);
      setUser(result);
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  };

  return <form action={handleSubmit}>...</form>;
}

// ✅ The new way - clean and performant
function UserForm() {
  const [state, formAction] = useActionState(createUserAction, {
    user: null,
    error: null,
  });

  return (
    <form action={formAction}>
      <input name="name" placeholder="Name" />
      <input name="email" placeholder="Email" />

      {state.error && <div className="error">{state.error}</div>}

      <button disabled={state.pending}>
        {state.pending ? "Creating..." : "Create User"}
      </button>

      {state.user && <div>Welcome, {state.user.name}!</div>}
    </form>
  );
}

// Action function
async function createUserAction(prevState, formData) {
  try {
    const user = await createUser(formData);
    return { user, error: null };
  } catch (error) {
    return {
      user: null,
      error: error.message,
    };
  }
}
```

### **Performance Benefits of useActionState **

| Benefit                       | Description                                    |
| ----------------------------- | ---------------------------------------------- |
| **Fewer renders**             | Batches updates into single render cycle       |
| **Race condition prevention** | Automatically prevents concurrent executions   |
| **Built-in accessibility**    | Proper ARIA attributes from pending state      |
| **Progressive enhancement**   | Works without JavaScript (with Server Actions) |

### **Optimistic Updates**

```javascript
async function toggleFavoriteAction(prevState, formData) {
  const postId = formData.get("postId");
  const currentlyFavorited = prevState.favorited;

  // Optimistic update - assume success
  const optimisticState = {
    ...prevState,
    favorited: !currentlyFavorited,
    error: null,
  };

  try {
    await toggleFavorite(postId);
    return optimisticState;
  } catch (error) {
    // Revert on failure
    return {
      ...prevState,
      error: "Failed to update favorite",
    };
  }
}

function FavoriteButton({ postId, initialFavorited }) {
  const [state, formAction] = useActionState(toggleFavoriteAction, {
    favorited: initialFavorited,
    error: null,
  });

  return (
    <form action={formAction}>
      <input type="hidden" name="postId" value={postId} />
      <button disabled={state.pending}>
        {state.favorited ? "❤️" : "🤍"}
        {state.pending && " (updating...)"}
      </button>
    </form>
  );
}
```

---

## **16. COMPONENT LIFECYCLE**

> **Concept:** Components go through lifecycle phases: mounting (adding to DOM), updating (re-rendering), and unmounting (removing from DOM) .

### **Lifecycle Phases**

```
Mounting → Updating → Unmounting
   │          │           │
   ▼          ▼           ▼
constructor → render → cleanup
```

### **Phases in Functional Components (with Hooks) **

| Phase          | Hook Equivalent                   | When It Runs             |
| -------------- | --------------------------------- | ------------------------ |
| **Mounting**   | `useEffect(fn, [])`               | After first render       |
| **Updating**   | `useEffect(fn, [deps])`           | When dependencies change |
| **Unmounting** | `useEffect(() => fn, [])` cleanup | Before component removal |

### **Class Component Lifecycle Methods**

```javascript
class LifecycleExample extends React.Component {
  constructor(props) {
    super(props);
    this.state = { count: 0 };
    console.log("1. Constructor");
  }

  static getDerivedStateFromProps(props, state) {
    console.log("2. getDerivedStateFromProps");
    return null;
  }

  render() {
    console.log("3. Render");
    return <div>{this.state.count}</div>;
  }

  componentDidMount() {
    console.log("4. componentDidMount");
    // API calls, subscriptions
  }

  shouldComponentUpdate(nextProps, nextState) {
    console.log("5. shouldComponentUpdate");
    return true;
  }

  getSnapshotBeforeUpdate(prevProps, prevState) {
    console.log("6. getSnapshotBeforeUpdate");
    return null;
  }

  componentDidUpdate(prevProps, prevState, snapshot) {
    console.log("7. componentDidUpdate");
  }

  componentWillUnmount() {
    console.log("8. componentWillUnmount");
    // Cleanup
  }
}
```

### **Lifecycle with Hooks **

```javascript
function LifecycleWithHooks() {
  const [count, setCount] = useState(0);

  // Mount & Update
  useEffect(() => {
    console.log("Runs after every render");
  });

  // Mount only
  useEffect(() => {
    console.log("Mounted");
    return () => {
      console.log("Will unmount");
    };
  }, []);

  // Update when count changes
  useEffect(() => {
    console.log("Count changed to:", count);
  }, [count]);

  return <button onClick={() => setCount((c) => c + 1)}>{count}</button>;
}
```

---

## **17. EVENT HANDLING**

> **Concept:** React normalizes events across browsers using SyntheticEvents, providing a consistent API and performance optimizations .

### **Basic Event Handling**

```javascript
function EventExample() {
  const handleClick = (e) => {
    e.preventDefault(); // Prevent default browser behavior
    console.log("Button clicked", e);
  };

  const handleChange = (e) => {
    console.log("Input value:", e.target.value);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log("Form submitted");
  };

  return (
    <div>
      <button onClick={handleClick}>Click me</button>
      <input onChange={handleChange} placeholder="Type here" />
      <form onSubmit={handleSubmit}>
        <button type="submit">Submit</button>
      </form>
    </div>
  );
}
```

### **Common Events**

| Event            | Description         | Handler                           |
| ---------------- | ------------------- | --------------------------------- |
| **onClick**      | Element clicked     | `onClick={handleClick}`           |
| **onChange**     | Input value changes | `onChange={handleChange}`         |
| **onSubmit**     | Form submitted      | `onSubmit={handleSubmit}`         |
| **onFocus**      | Element focused     | `onFocus={handleFocus}`           |
| **onBlur**       | Element loses focus | `onBlur={handleBlur}`             |
| **onMouseEnter** | Mouse enters        | `onMouseEnter={handleMouseEnter}` |
| **onMouseLeave** | Mouse leaves        | `onMouseLeave={handleMouseLeave}` |
| **onKeyDown**    | Key pressed         | `onKeyDown={handleKeyDown}`       |
| **onScroll**     | Element scrolled    | `onScroll={handleScroll}`         |

### **Passing Arguments to Event Handlers**

```javascript
function ItemList() {
  const handleItemClick = (id, e) => {
    console.log("Item clicked:", id, e);
  };

  return (
    <ul>
      {items.map((item) => (
        <li key={item.id}>
          {/* Arrow function (creates new function each render) */}
          <button onClick={(e) => handleItemClick(item.id, e)}>
            {item.name}
          </button>

          {/* Bind (also creates new function) */}
          <button onClick={handleItemClick.bind(null, item.id)}>
            {item.name}
          </button>
        </li>
      ))}
    </ul>
  );
}

// Optimized version with useCallback
function OptimizedList() {
  const handleItemClick = useCallback((id) => {
    console.log("Item clicked:", id);
  }, []);

  return (
    <ul>
      {items.map((item) => (
        <li key={item.id}>
          <button onClick={() => handleItemClick(item.id)}>{item.name}</button>
        </li>
      ))}
    </ul>
  );
}
```

### **Synthetic Events vs Native Events **

| Feature                | Synthetic Events       | Native Events     |
| ---------------------- | ---------------------- | ----------------- |
| **Cross-browser**      | Normalized behavior    | Browser-specific  |
| **Event Pooling**      | Reused for performance | Created per event |
| **Delegation**         | Root-level delegation  | Element-level     |
| **Default prevention** | `e.preventDefault()`   | `return false`    |
| **API**                | Consistent             | Varies by browser |

### **Event Pooling **

```javascript
// Before React 17 - events were pooled
function EventPoolingExample() {
  const handleClick = (e) => {
    console.log(e.type); // Works

    setTimeout(() => {
      console.log(e.type); // Before React 17: null (pooled)
      // Solution: e.persist() needed
    }, 100);
  };

  // React 17+ - no pooling, event properties persist
  return <button onClick={handleClick}>Click</button>;
}
```

---

## **18. CONDITIONAL RENDERING**

> **Concept:** Render different UI based on conditions using JavaScript expressions .

### **Techniques **

| Technique             | Syntax                                       | Use Case                          |
| --------------------- | -------------------------------------------- | --------------------------------- |
| **if statement**      | `if (cond) { return A; } else { return B; }` | Complex conditions, early returns |
| **Ternary operator**  | `cond ? <A /> : <B />`                       | Simple if/else in JSX             |
| **Logical AND**       | `cond && <Component />`                      | Show/hide without else            |
| **Switch/Case**       | Function returning component                 | Multiple conditions               |
| **Element variables** | Store JSX in variables                       | Complex conditional blocks        |

### **If Statement (Early Return)**

```javascript
function UserProfile({ user }) {
  // Early return for loading/error states
  if (!user) {
    return <div>Loading...</div>;
  }

  if (user.isBlocked) {
    return <div>Access denied</div>;
  }

  // Normal rendering
  return (
    <div>
      <h1>{user.name}</h1>
      <p>Email: {user.email}</p>
    </div>
  );
}
```

### **Ternary Operator **

```javascript
function Greeting({ isLoggedIn }) {
  return <div>{isLoggedIn ? <Dashboard /> : <LoginForm />}</div>;
}

// Inline with styles
function StatusIndicator({ status }) {
  return (
    <div
      style={{
        color: status === "error" ? "red" : "green",
      }}
    >
      {status === "loading" ? "Loading..." : "Ready"}
    </div>
  );
}
```

### **Logical AND (&&) Operator **

```javascript
function Notification({ messages }) {
  return (
    <div>
      <h1>Messages</h1>

      {/* Show only if condition true */}
      {messages.length > 0 && <div>You have {messages.length} messages</div>}

      {messages.map((msg) => (
        <div key={msg.id}>{msg.text}</div>
      ))}

      {/* Common pattern for conditional rendering */}
      {isAdmin && <AdminPanel />}
    </div>
  );
}
```

### **Switch/Case Pattern**

```javascript
function getComponent(type) {
  switch (type) {
    case "success":
      return <SuccessIcon />;
    case "warning":
      return <WarningIcon />;
    case "error":
      return <ErrorIcon />;
    default:
      return <InfoIcon />;
  }
}

function Alert({ type, message }) {
  return (
    <div className={`alert alert-${type}`}>
      {getComponent(type)}
      <span>{message}</span>
    </div>
  );
}
```

### **Element Variables**

```javascript
function Dashboard({ user, permissions }) {
  let content;

  if (user.isAdmin) {
    content = <AdminDashboard user={user} />;
  } else if (permissions.includes("edit")) {
    content = <EditorDashboard user={user} />;
  } else if (user.isLoggedIn) {
    content = <UserDashboard user={user} />;
  } else {
    content = <PublicDashboard />;
  }

  return (
    <div>
      <Header user={user} />
      {content}
      <Footer />
    </div>
  );
}
```

### **Conditional Rendering Patterns**

| Pattern            | Example                      | Best For          |
| ------------------ | ---------------------------- | ----------------- |
| **Guard clause**   | `if (!data) return null`     | Loading states    |
| **Toggle UI**      | `isOpen && <Modal />`        | Modals, dropdowns |
| **Two-way toggle** | `isOn ? <On /> : <Off />`    | Switches, toggles |
| **Multi-way**      | Function returning component | Tabbed interfaces |
| **HOC**            | `withAuth(Component)`        | Permission checks |

---

## **19. LISTS AND KEYS**

> **Concept:** Rendering lists of data and using keys to help React identify which items changed .

### **Basic List Rendering**

```javascript
function SimpleList() {
  const items = ["Apple", "Banana", "Cherry"];

  return (
    <ul>
      {items.map((item, index) => (
        <li key={index}>{item}</li>
      ))}
    </ul>
  );
}
```

### **Why Keys Matter **

Keys help React identify which items have changed, been added, or removed during reconciliation .

```javascript
// ❌ Bad - using index as key (can cause UI bugs)
function TodoList({ todos }) {
  return (
    <ul>
      {todos.map((todo, index) => (
        <TodoItem key={index} todo={todo} />
      ))}
    </ul>
  );
}

// ✅ Good - using unique id
function TodoList({ todos }) {
  return (
    <ul>
      {todos.map((todo) => (
        <TodoItem key={todo.id} todo={todo} />
      ))}
    </ul>
  );
}
```

### **Key Selection Guidelines **

| Key Source      | Example                     | Recommendation            |
| --------------- | --------------------------- | ------------------------- |
| **Unique ID**   | `key={item.id}`             | ✅ Best choice            |
| **Database ID** | `key={user.userId}`         | ✅ Excellent              |
| **Combination** | `key={item.type + item.id}` | ✅ Good for unique needs  |
| **Index**       | `key={index}`               | ❌ Only if list is static |

### **Dynamic Lists with State**

```javascript
function DynamicList() {
  const [items, setItems] = useState([
    { id: 1, text: "Learn React" },
    { id: 2, text: "Build project" },
  ]);

  const addItem = () => {
    const newItem = {
      id: Date.now(),
      text: `Item ${items.length + 1}`,
    };
    setItems([...items, newItem]);
  };

  const removeItem = (id) => {
    setItems(items.filter((item) => item.id !== id));
  };

  return (
    <div>
      <button onClick={addItem}>Add Item</button>
      <ul>
        {items.map((item) => (
          <li key={item.id}>
            {item.text}
            <button onClick={() => removeItem(item.id)}>❌</button>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

### **Nested Lists**

```javascript
function NestedList() {
  const categories = [
    {
      id: 1,
      name: "Fruits",
      items: ["Apple", "Banana", "Orange"],
    },
    {
      id: 2,
      name: "Vegetables",
      items: ["Carrot", "Broccoli", "Spinach"],
    },
  ];

  return (
    <div>
      {categories.map((category) => (
        <div key={category.id}>
          <h3>{category.name}</h3>
          <ul>
            {category.items.map((item, index) => (
              <li key={`${category.id}-${index}`}>{item}</li>
            ))}
          </ul>
        </div>
      ))}
    </div>
  );
}
```

---

## **20. FORMS IN REACT**

> **Concept:** Two approaches to handling forms: controlled components (React state manages inputs) and uncontrolled components (DOM manages inputs) .

### **Controlled Components **

```javascript
function ControlledForm() {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    age: "",
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log("Form data:", formData);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        name="name"
        value={formData.name}
        onChange={handleChange}
        placeholder="Name"
      />
      <input
        name="email"
        value={formData.email}
        onChange={handleChange}
        placeholder="Email"
        type="email"
      />
      <input
        name="age"
        value={formData.age}
        onChange={handleChange}
        placeholder="Age"
        type="number"
      />
      <button type="submit">Submit</button>
    </form>
  );
}
```

### **Uncontrolled Components **

```javascript
import { useRef } from "react";

function UncontrolledForm() {
  const nameRef = useRef();
  const emailRef = useRef();

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log("Name:", nameRef.current.value);
    console.log("Email:", emailRef.current.value);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input ref={nameRef} placeholder="Name" />
      <input ref={emailRef} placeholder="Email" type="email" />
      <button type="submit">Submit</button>
    </form>
  );
}
```

### **Controlled vs Uncontrolled **

| Aspect                   | Controlled           | Uncontrolled        |
| ------------------------ | -------------------- | ------------------- |
| **State source**         | React state          | DOM                 |
| **Value access**         | `formData.field`     | `ref.current.value` |
| **Real-time validation** | Easy                 | Harder              |
| **Instant feedback**     | Possible             | Requires events     |
| **Form reset**           | Set state to initial | DOM manipulation    |

### **Form Validation Example**

```javascript
function ValidatedForm() {
  const [values, setValues] = useState({
    email: "",
    password: "",
  });

  const [errors, setErrors] = useState({});
  const [touched, setTouched] = useState({});

  const validate = (fieldValues = values) => {
    const temp = { ...errors };

    if ("email" in fieldValues) {
      temp.email = fieldValues.email ? null : "Email is required";
    }

    if ("password" in fieldValues) {
      temp.password =
        fieldValues.password?.length >= 6
          ? null
          : "Password must be at least 6 characters";
    }

    setErrors(temp);
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setValues({ ...values, [name]: value });
    validate({ [name]: value });
  };

  const handleBlur = (e) => {
    setTouched({ ...touched, [e.target.name]: true });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    validate();

    if (Object.values(errors).every((x) => x === null)) {
      console.log("Valid form:", values);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <input
          name="email"
          value={values.email}
          onChange={handleChange}
          onBlur={handleBlur}
        />
        {touched.email && errors.email && (
          <span className="error">{errors.email}</span>
        )}
      </div>

      <div>
        <input
          type="password"
          name="password"
          value={values.password}
          onChange={handleChange}
          onBlur={handleBlur}
        />
        {touched.password && errors.password && (
          <span className="error">{errors.password}</span>
        )}
      </div>

      <button type="submit">Submit</button>
    </form>
  );
}
```

### **Form Libraries**

| Library             | Description                | When to Use                |
| ------------------- | -------------------------- | -------------------------- |
| **React Hook Form** | Performant, flexible forms | Complex forms, large forms |
| **Formik**          | Popular, feature-rich      | Enterprise applications    |
| **Final Form**      | Subscription-based         | Performance-critical forms |

---

## **21. REFS IN REACT**

> **Concept:** Refs provide a way to access DOM nodes or React elements directly, and to persist values between renders without causing re-renders .

### **When to Use Refs**

- Managing focus, text selection, or media playback
- Triggering imperative animations
- Integrating with third-party DOM libraries
- Storing mutable values that shouldn't trigger re-renders

### **Creating Refs **

```javascript
import { useRef } from "react";

function TextInput() {
  const inputRef = useRef(null);

  const focusInput = () => {
    inputRef.current.focus();
  };

  return (
    <div>
      <input ref={inputRef} type="text" />
      <button onClick={focusInput}>Focus Input</button>
    </div>
  );
}
```

### **Refs vs State **

| Aspect                   | Refs                      | State             |
| ------------------------ | ------------------------- | ----------------- |
| **Re-renders on change** | No                        | Yes               |
| **Mutable**              | Yes (`.current`)          | Via setter only   |
| **Used for**             | DOM access, instance vars | UI state          |
| **Read/write**           | Anytime                   | Only after render |

### **Forwarding Refs **

```javascript
// Parent component
function Parent() {
  const buttonRef = useRef(null);

  return (
    <div>
      <FancyButton ref={buttonRef}>Click me</FancyButton>
      <button onClick={() => buttonRef.current.click()}>Trigger click</button>
    </div>
  );
}

// Child with forwarded ref
const FancyButton = React.forwardRef((props, ref) => {
  return <button ref={ref} className="fancy-button" {...props} />;
});
```

### **Ref Callbacks**

```javascript
function MeasureExample() {
  const [height, setHeight] = useState(0);

  const measuredRef = useCallback((node) => {
    if (node !== null) {
      setHeight(node.getBoundingClientRect().height);
    }
  }, []);

  return (
    <div>
      <h1 ref={measuredRef}>Hello, world</h1>
      <p>The above header is {Math.round(height)}px tall</p>
    </div>
  );
}
```

### **useImperativeHandle**

```javascript
// Custom input with imperative methods
const CustomInput = React.forwardRef((props, ref) => {
  const inputRef = useRef(null);

  useImperativeHandle(ref, () => ({
    focus: () => {
      inputRef.current.focus();
    },
    clear: () => {
      inputRef.current.value = "";
    },
    getValue: () => {
      return inputRef.current.value;
    },
  }));

  return <input ref={inputRef} {...props} />;
});

// Usage
function Parent() {
  const inputRef = useRef(null);

  return (
    <div>
      <CustomInput ref={inputRef} />
      <button onClick={() => inputRef.current.focus()}>Focus</button>
      <button onClick={() => inputRef.current.clear()}>Clear</button>
    </div>
  );
}
```

---

## **22. CONTEXT API**

> **Concept:** Context provides a way to pass data through the component tree without manually passing props at every level .

### **When to Use Context **

- **Theme** (light/dark mode)
- **User authentication** (current user, login state)
- **Language/Locale** (i18n)
- **Global UI state** (notifications, modals)
- **Any data that many components need**

### **Basic Implementation **

```javascript
import { createContext, useContext, useState } from "react";

// 1. Create context
const ThemeContext = createContext();

// 2. Create provider component
function ThemeProvider({ children }) {
  const [theme, setTheme] = useState("light");

  const toggleTheme = () => {
    setTheme((prev) => (prev === "light" ? "dark" : "light"));
  };

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

// 3. Custom hook for consuming
function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error("useTheme must be used within ThemeProvider");
  }
  return context;
}

// 4. Consumer component
function ThemedButton() {
  const { theme, toggleTheme } = useTheme();

  return (
    <button
      onClick={toggleTheme}
      style={{
        backgroundColor: theme === "light" ? "#fff" : "#333",
        color: theme === "light" ? "#333" : "#fff",
      }}
    >
      Current theme: {theme}
    </button>
  );
}

// 5. App wrapper
function App() {
  return (
    <ThemeProvider>
      <ThemedButton />
    </ThemeProvider>
  );
}
```

### **Multiple Contexts **

```javascript
// Create multiple contexts
const UserContext = createContext();
const ThemeContext = createContext();
const LanguageContext = createContext();

// Nested providers
function App() {
  return (
    <UserContext.Provider value={user}>
      <ThemeContext.Provider value={theme}>
        <LanguageContext.Provider value={language}>
          <MainApp />
        </LanguageContext.Provider>
      </ThemeContext.Provider>
    </UserContext.Provider>
  );
}

// Consuming multiple contexts
function Profile() {
  const user = useContext(UserContext);
  const theme = useContext(ThemeContext);
  const language = useContext(LanguageContext);

  return (
    <div style={{ color: theme.text }}>
      <h1>{user.name}</h1>
      <p>Language: {language}</p>
    </div>
  );
}
```

### **Context vs Prop Drilling **

| Aspect           | Prop Drilling         | Context                 |
| ---------------- | --------------------- | ----------------------- |
| **Passing data** | Through every level   | Direct to any level     |
| **Boilerplate**  | Minimal per component | Provider setup          |
| **Performance**  | Good                  | Can cause extra renders |
| **Debugging**    | Easy to trace         | Harder to trace         |
| **Use case**     | Shallow trees         | Deep trees, global data |

### **Context Performance Optimization**

```javascript
// ❌ Causes all consumers to re-render on any change
function App() {
  const [user, setUser] = useState(null);
  const [theme, setTheme] = useState("light");

  return (
    <AppContext.Provider value={{ user, setUser, theme, setTheme }}>
      <MainApp />
    </AppContext.Provider>
  );
}

// ✅ Split into separate contexts
function App() {
  return (
    <UserProvider>
      <ThemeProvider>
        <MainApp />
      </ThemeProvider>
    </UserProvider>
  );
}
```

---

## **23. REACT ROUTER**

> **Concept:** React Router enables navigation between views in a React application, managing the URL and rendering the appropriate components .

### **Basic Setup**

```javascript
import { BrowserRouter, Routes, Route, Link } from "react-router-dom";

function App() {
  return (
    <BrowserRouter>
      <nav>
        <Link to="/">Home</Link>
        <Link to="/about">About</Link>
        <Link to="/users">Users</Link>
      </nav>

      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/about" element={<About />} />
        <Route path="/users" element={<Users />} />
        <Route path="*" element={<NotFound />} />
      </Routes>
    </BrowserRouter>
  );
}
```

### **Route Parameters **

```javascript
// App.js
<Routes>
  <Route path="/users/:userId" element={<UserProfile />} />
  <Route path="/posts/:postId/comments/:commentId" element={<Comment />} />
</Routes>;

// UserProfile.js
import { useParams } from "react-router-dom";

function UserProfile() {
  const { userId } = useParams();

  return <div>Viewing user: {userId}</div>;
}
```

### **Navigation **

```javascript
import { useNavigate } from "react-router-dom";

function LoginButton() {
  const navigate = useNavigate();

  const handleLogin = async () => {
    await login();
    navigate("/dashboard", { replace: true });
  };

  return <button onClick={handleLogin}>Login</button>;
}
```

### **Query Parameters**

```javascript
import { useSearchParams } from "react-router-dom";

function SearchResults() {
  const [searchParams, setSearchParams] = useSearchParams();
  const query = searchParams.get("q") || "";
  const page = Number(searchParams.get("page")) || 1;

  const updatePage = (newPage) => {
    setSearchParams({ q: query, page: newPage });
  };

  return (
    <div>
      <p>Searching for: {query}</p>
      <p>Page: {page}</p>
      <button onClick={() => updatePage(page + 1)}>Next</button>
    </div>
  );
}
```

### **Nested Routes**

```javascript
function App() {
  return (
    <Routes>
      <Route path="/" element={<Layout />}>
        <Route index element={<Home />} />
        <Route path="products" element={<Products />}>
          <Route path=":productId" element={<ProductDetail />} />
        </Route>
      </Route>
    </Routes>
  );
}

function Layout() {
  return (
    <div>
      <Header />
      <Outlet /> {/* Child routes render here */}
      <Footer />
    </div>
  );
}
```

### **Protected Routes**

```javascript
function PrivateRoute({ children }) {
  const { user } = useAuth();
  const location = useLocation();

  if (!user) {
    return <Navigate to="/login" state={{ from: location }} replace />;
  }

  return children;
}

// Usage
<Routes>
  <Route
    path="/dashboard"
    element={
      <PrivateRoute>
        <Dashboard />
      </PrivateRoute>
    }
  />
</Routes>;
```

---

## **24. HIGHER-ORDER COMPONENTS (HOCs)**

> **Concept:** HOCs are functions that take a component and return a new component with enhanced functionality. They're a pattern for reusing component logic .

### **Basic HOC Pattern **

```javascript
// Basic HOC syntax
const EnhancedComponent = higherOrderComponent(WrappedComponent);

// Example
function withLogger(WrappedComponent) {
  return function Enhanced(props) {
    console.log("Rendering:", WrappedComponent.name);
    return <WrappedComponent {...props} />;
  };
}

// Usage
const ButtonWithLogger = withLogger(Button);
```

### **Practical HOC Example **

```javascript
// withLoading.js
function withLoading(WrappedComponent) {
  return function WithLoading({ isLoading, ...props }) {
    if (isLoading) {
      return <div className="spinner">Loading...</div>;
    }
    return <WrappedComponent {...props} />;
  };
}

// Usage
const UserListWithLoading = withLoading(UserList);

function App() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchUsers().then((data) => {
      setUsers(data);
      setLoading(false);
    });
  }, []);

  return <UserListWithLoading isLoading={loading} users={users} />;
}
```

### **HOC for Data Fetching**

```javascript
function withData(WrappedComponent, dataSource) {
  return function WithData(props) {
    const [data, setData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
      fetch(dataSource)
        .then((res) => res.json())
        .then(setData)
        .catch(setError)
        .finally(() => setLoading(false));
    }, [dataSource]);

    return (
      <WrappedComponent
        {...props}
        data={data}
        loading={loading}
        error={error}
      />
    );
  };
}

// Usage
const UserListWithData = withData(UserList, "/api/users");
const ProductListWithData = withData(ProductList, "/api/products");
```

### **Authentication HOC**

```javascript
function withAuth(WrappedComponent) {
  return function WithAuth(props) {
    const { user } = useAuth();
    const navigate = useNavigate();

    useEffect(() => {
      if (!user) {
        navigate("/login");
      }
    }, [user, navigate]);

    if (!user) {
      return <div>Loading...</div>;
    }

    return <WrappedComponent {...props} user={user} />;
  };
}

// Usage
const DashboardWithAuth = withAuth(Dashboard);
const SettingsWithAuth = withAuth(Settings);
```

### **HOC Best Practices**

| Practice                            | Reason                         |
| ----------------------------------- | ------------------------------ |
| **Don't mutate original component** | Functional composition         |
| **Pass unrelated props through**    | Maintain flexibility           |
| **Maximize composability**          | Make HOCs reusable             |
| **Wrap display name for debugging** | `WrappedComponent.displayName` |
| **Don't use inside render**         | Performance issues             |

### **HOCs vs Hooks **

| Aspect           | HOCs                    | Hooks              |
| ---------------- | ----------------------- | ------------------ |
| **Syntax**       | Wrapper components      | Function calls     |
| **Reusability**  | Component-level         | Function-level     |
| **Composition**  | Can be chained          | Can be combined    |
| **Performance**  | Extra component in tree | No wrapper         |
| **Modern React** | Legacy pattern          | Preferred approach |

---

## **25. REACT FIBER**

> **Concept:** React Fiber is a complete rewrite of React's core reconciliation algorithm, introduced in React 16 to enable incremental rendering and better scheduling of updates .

### **What Fiber Does **

| Feature                   | Description                                   |
| ------------------------- | --------------------------------------------- |
| **Incremental Rendering** | Splits rendering work into chunks             |
| **Prioritization**        | Can prioritize important updates (user input) |
| **Pause/Resume**          | Can pause work and resume later               |
| **Concurrency**           | Prepares for concurrent rendering             |

### **How Fiber Improves Performance **

```javascript
// Before Fiber - synchronous rendering
// Large updates would block the main thread, freezing UI

// With Fiber - incremental rendering
// React can pause rendering to handle user input
// then resume where it left off
```

### **Fiber Architecture**

```
Work Loop (Scheduler)
        │
        ▼
┌───────────────────┐
│  Task Queue       │  High priority (user input)
│  ┌─────────────┐  │  Medium priority (data fetch)
│  │ Task 1 (Hi) │  │  Low priority (off-screen)
│  │ Task 2 (Lo) │  │
│  │ Task 3 (Hi) │  │
│  └─────────────┘  │
└───────────────────┘
        │
        ▼
 Reconciliation Engine
        │
        ▼
    Commit Phase
```

### **Benefits of Fiber**

| Benefit                  | User Impact                          |
| ------------------------ | ------------------------------------ |
| **Smooth animations**    | UI remains responsive during updates |
| **Prioritized updates**  | User input feels instant             |
| **Concurrent rendering** | Prepares for future React features   |
| **Better Suspense**      | Enables fallback UI while loading    |

---

## **26. PERFORMANCE OPTIMIZATION**

> **Concept:** Techniques to optimize React application performance, ensuring smooth UI and fast load times .

### **Optimization Techniques **

| Technique                 | Description               | When to Use                            |
| ------------------------- | ------------------------- | -------------------------------------- |
| **Memoization**           | Cache component outputs   | Pure components with same props        |
| **Code Splitting**        | Lazy load components      | Large apps, route-based loading        |
| **Virtualization**        | Render only visible items | Long lists, tables                     |
| **Throttling/Debouncing** | Limit function calls      | Search inputs, scroll handlers         |
| **useMemo/useCallback**   | Memoize values/functions  | Expensive calculations, callback props |

### **React.memo for Components**

```javascript
// Regular component - re-renders when parent re-renders
function RegularComponent({ name }) {
  console.log("Regular rendered");
  return <div>{name}</div>;
}

// Memoized component - only re-renders if props change
const MemoizedComponent = React.memo(function Memoized({ name }) {
  console.log("Memoized rendered");
  return <div>{name}</div>;
});

// With custom comparison
const CustomMemo = React.memo(
  function Custom({ user }) {
    return <div>{user.name}</div>;
  },
  (prevProps, nextProps) => {
    // Only re-render if user.id changes
    return prevProps.user.id === nextProps.user.id;
  },
);
```

### **useMemo for Expensive Calculations**

```javascript
function ProductList({ products, filter }) {
  // ❌ Expensive calculation runs on every render
  const filteredProducts = products.filter(
    (p) => p.name.includes(filter) || p.category.includes(filter),
  );

  // ✅ Memoized - only recalculates when products or filter change
  const filteredMemo = useMemo(() => {
    return products.filter(
      (p) => p.name.includes(filter) || p.category.includes(filter),
    );
  }, [products, filter]);

  return (
    <ul>
      {filteredMemo.map((product) => (
        <li key={product.id}>{product.name}</li>
      ))}
    </ul>
  );
}
```

### **Virtualization for Long Lists**

```javascript
import { FixedSizeList as List } from "react-window";

const Row = ({ index, style }) => <div style={style}>Item {index + 1}</div>;

function VirtualizedList({ items }) {
  return (
    <List height={400} itemCount={items.length} itemSize={35} width={300}>
      {Row}
    </List>
  );
}
```

### **Throttling and Debouncing**

```javascript
import { debounce } from "lodash";

function SearchComponent() {
  const [query, setQuery] = useState("");

  // Debounced search (waits for typing to finish)
  const debouncedSearch = useMemo(
    () =>
      debounce((searchTerm) => {
        // API call
        searchAPI(searchTerm);
      }, 300),
    [],
  );

  const handleChange = (e) => {
    setQuery(e.target.value);
    debouncedSearch(e.target.value);
  };

  useEffect(() => {
    return () => {
      debouncedSearch.cancel();
    };
  }, [debouncedSearch]);

  return <input value={query} onChange={handleChange} />;
}
```

### **Performance Checklist**

| Area                       | Check                                      |
| -------------------------- | ------------------------------------------ |
| **Renders**                | Are components re-rendering unnecessarily? |
| **List keys**              | Are keys stable and unique?                |
| **Bundle size**            | Is code splitting implemented?             |
| **Images**                 | Are images optimized?                      |
| **State management**       | Is state localized appropriately?          |
| **useEffect dependencies** | Are all dependencies listed?               |

---

## **27. CODE SPLITTING**

> **Concept:** Code splitting allows you to split your bundle into smaller chunks that can be loaded on demand, improving initial load time .

### **React.lazy and Suspense**

```javascript
import { lazy, Suspense } from "react";

// Lazy load components
const Home = lazy(() => import("./Home"));
const About = lazy(() => import("./About"));
const Dashboard = lazy(() => import("./Dashboard"));

function App() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/about" element={<About />} />
        <Route path="/dashboard" element={<Dashboard />} />
      </Routes>
    </Suspense>
  );
}
```

### **Route-Based Code Splitting **

```javascript
import { lazy, Suspense } from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";

// Each route loads separately
const Home = lazy(() => import("./routes/Home"));
const Products = lazy(() => import("./routes/Products"));
const Checkout = lazy(() => import("./routes/Checkout"));
const Admin = lazy(() => import("./routes/Admin"));

function App() {
  return (
    <BrowserRouter>
      <Suspense fallback={<Loading />}>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/products/*" element={<Products />} />
          <Route path="/checkout" element={<Checkout />} />
          <Route
            path="/admin"
            element={
              <AuthCheck>
                <Admin />
              </AuthCheck>
            }
          />
        </Routes>
      </Suspense>
    </BrowserRouter>
  );
}
```

### **Component-Level Code Splitting**

```javascript
import { lazy, Suspense, useState } from "react";

const HeavyComponent = lazy(() => import("./HeavyComponent"));

function Dashboard() {
  const [showChart, setShowChart] = useState(false);

  return (
    <div>
      <h1>Dashboard</h1>
      <button onClick={() => setShowChart(true)}>Show Analytics Chart</button>

      {showChart && (
        <Suspense fallback={<div>Loading chart...</div>}>
          <HeavyComponent />
        </Suspense>
      )}
    </div>
  );
}
```

### **Named Exports with lazy**

```javascript
// Component with named export
export const AdminPanel = () => { ... };
export const UserSettings = () => { ... };

// Lazy load with named export
const AdminPanel = lazy(() =>
  import('./admin').then(module => ({
    default: module.AdminPanel
  }))
);
```

---

## **28. TESTING IN REACT**

> **Concept:** Testing React components ensures they work correctly and helps prevent regressions .

### **Testing Approaches **

| Approach                | Description                  | Tools                       |
| ----------------------- | ---------------------------- | --------------------------- |
| **Unit Testing**        | Test components in isolation | Jest, React Testing Library |
| **Integration Testing** | Test component interactions  | React Testing Library       |
| **Snapshot Testing**    | Capture component output     | Jest                        |
| **End-to-End Testing**  | Test full user flows         | Cypress, Playwright         |

### **Jest Setup**

```javascript
// package.json
{
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch"
  }
}

// jest.config.js
module.exports = {
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/src/setupTests.js']
};
```

### **React Testing Library Examples **

```javascript
import { render, screen, fireEvent } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import Counter from "./Counter";

test("counter increments when button clicked", () => {
  // Render component
  render(<Counter />);

  // Find elements
  const button = screen.getByText("Increment");
  const count = screen.getByTestId("count");

  // Initial state
  expect(count).toHaveTextContent("0");

  // Click button
  fireEvent.click(button);

  // Check result
  expect(count).toHaveTextContent("1");
});

test("form submission with userEvent", async () => {
  const handleSubmit = jest.fn();
  render(<LoginForm onSubmit={handleSubmit} />);

  // Type in inputs
  await userEvent.type(screen.getByLabelText(/email/i), "test@example.com");
  await userEvent.type(screen.getByLabelText(/password/i), "password123");

  // Submit form
  await userEvent.click(screen.getByRole("button", { name: /submit/i }));

  expect(handleSubmit).toHaveBeenCalledWith({
    email: "test@example.com",
    password: "password123",
  });
});
```

### **Testing Async Operations**

```javascript
import { render, screen, waitFor } from "@testing-library/react";
import UserProfile from "./UserProfile";

test("loads and displays user", async () => {
  // Mock fetch
  global.fetch = jest.fn().mockResolvedValue({
    ok: true,
    json: () => Promise.resolve({ id: 1, name: "John" }),
  });

  render(<UserProfile userId={1} />);

  // Loading state
  expect(screen.getByText(/loading/i)).toBeInTheDocument();

  // Wait for data
  await waitFor(() => {
    expect(screen.getByText("John")).toBeInTheDocument();
  });

  expect(screen.queryByText(/loading/i)).not.toBeInTheDocument();
});
```

### **Snapshot Testing**

```javascript
import renderer from "react-test-renderer";
import Button from "./Button";

test("Button renders correctly", () => {
  const tree = renderer
    .create(<Button variant="primary">Click me</Button>)
    .toJSON();

  expect(tree).toMatchSnapshot();
});
```

### **Testing Custom Hooks**

```javascript
import { renderHook, act } from "@testing-library/react";
import useCounter from "./useCounter";

test("useCounter increments count", () => {
  const { result } = renderHook(() => useCounter(0));

  expect(result.current.count).toBe(0);

  act(() => {
    result.current.increment();
  });

  expect(result.current.count).toBe(1);
});
```

---

## **29. STYLING IN REACT**

> **Concept:** Multiple approaches to style React components, each with different trade-offs .

### **Styling Approaches**

| Approach            | Description             | Pros                            | Cons                           |
| ------------------- | ----------------------- | ------------------------------- | ------------------------------ |
| **CSS Stylesheets** | Traditional CSS files   | Familiar, separate concerns     | Global scope, naming conflicts |
| **CSS Modules**     | Locally scoped CSS      | Scoped styles, no conflicts     | Learning curve                 |
| **CSS-in-JS**       | Write CSS in JavaScript | Dynamic styles, theming         | Runtime overhead               |
| **Tailwind CSS**    | Utility-first CSS       | Rapid development, small bundle | HTML can get verbose           |

### **CSS Stylesheets**

```javascript
import "./Button.css";

function Button({ children, variant }) {
  return <button className={`btn btn-${variant}`}>{children}</button>;
}
```

### **CSS Modules**

```javascript
// Button.module.css
.button {
  padding: 10px 20px;
  border-radius: 4px;
}
.primary {
  background-color: blue;
  color: white;
}

// Button.js
import styles from './Button.module.css';

function Button({ children, primary }) {
  return (
    <button
      className={`${styles.button} ${primary ? styles.primary : ''}`}
    >
      {children}
    </button>
  );
}
```

### **CSS-in-JS with Styled Components **

```javascript
import styled from "styled-components";

// Create styled components
const Button = styled.button`
  padding: 10px 20px;
  border-radius: 4px;
  background-color: ${(props) => (props.primary ? "blue" : "gray")};
  color: white;
  font-size: ${(props) => props.size || "16px"};

  &:hover {
    opacity: 0.8;
  }
`;

const Container = styled.div`
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
`;

// Usage
function App() {
  return (
    <Container>
      <Button primary size="20px">
        Click me
      </Button>
      <Button>Cancel</Button>
    </Container>
  );
}
```

### **Tailwind CSS**

```javascript
function Card({ title, content }) {
  return (
    <div className="max-w-sm rounded overflow-hidden shadow-lg">
      <div className="px-6 py-4">
        <div className="font-bold text-xl mb-2">{title}</div>
        <p className="text-gray-700 text-base">{content}</p>
      </div>
      <div className="px-6 pt-4 pb-2">
        <span className="inline-block bg-gray-200 rounded-full px-3 py-1 text-sm font-semibold text-gray-700 mr-2 mb-2">
          #react
        </span>
        <span className="inline-block bg-gray-200 rounded-full px-3 py-1 text-sm font-semibold text-gray-700 mr-2 mb-2">
          #tailwind
        </span>
      </div>
    </div>
  );
}
```

---

## **30. REACT FOR JAVA DEVELOPERS**

> **Concept:** Understanding React through the lens of Java concepts helps Java developers transition to frontend development .

### **Java vs React Comparison **

| Java Concept           | React Equivalent     | Key Difference                             |
| ---------------------- | -------------------- | ------------------------------------------ |
| **Class**              | Component            | Components are functions, not classes      |
| **Method parameters**  | Props                | Props are read-only, like final parameters |
| **Instance variables** | State                | State changes trigger re-render            |
| **Constructor**        | `useState(initial)`  | Hooks called at top level                  |
| **Method calls**       | Event handlers       | Pass functions as props                    |
| **Interfaces**         | PropTypes/TypeScript | Runtime vs compile-time                    |
| **Inheritance**        | Composition          | Prefer composition over inheritance        |

### **Java Developer's First React Component **

```java
// Java (imperative) - you write steps to achieve result
public class CounterView extends VerticalLayout {
    private int counter = 0;

    public CounterView() {
        var counterField = new TextField("Counter");
        counterField.setValue(String.valueOf(counter));
        counterField.setReadOnly(true);

        var button = new Button("Increment", e -> {
            counterField.setValue(String.valueOf(++counter));
        });

        add(counterField, button);
    }
}
```

```javascript
// React (declarative) - you describe the result
function CounterView() {
  const [count, setCount] = useState(0);

  return (
    <>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </>
  );
}
```

### **Thinking in Components **

From Java developer perspective, think of components as:

- **Classes** that return JSX instead of objects
- **Props** as constructor parameters
- **State** as instance fields
- **Hooks** as special methods

```javascript
// Java thinking
class UserProfile {
    private String name;
    private int age;

    public UserProfile(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public void render() {
        return new Html("div", "Name: " + name);
    }
}
```

```javascript
// React reality
function UserProfile({ name, age }) {
  // Component "class" is a function
  // Props are parameters
  // Render is the return value
  return <div>Name: {name}</div>;
}
```

### **State Management for Java Developers**

| Java Pattern                  | React Equivalent  |
| ----------------------------- | ----------------- |
| **Bean with getters/setters** | `useState` hook   |
| **Observer pattern**          | `useEffect`       |
| **Singleton**                 | Context API       |
| **Factory pattern**           | Custom hooks      |
| **DAO pattern**               | API service layer |

---

## **31. COMMON INTERVIEW QUESTIONS**

### **Basic Level **

| Question                                | Answer                                                                         |
| --------------------------------------- | ------------------------------------------------------------------------------ |
| **What is React?**                      | JavaScript library for building user interfaces with reusable components       |
| **What is JSX?**                        | Syntax extension that lets you write HTML-like code in JavaScript files        |
| **Difference between state and props?** | Props are read-only data from parent; state is mutable data owned by component |
| **What are components?**                | Reusable building blocks that return JSX                                       |
| **How do you create a React app?**      | `npx create-react-app my-app` or Vite                                          |

### **Intermediate Level **

| Question                       | Answer                                                                                     |
| ------------------------------ | ------------------------------------------------------------------------------------------ |
| **Explain the Virtual DOM**    | In-memory representation of real DOM; React compares changes and updates only what changed |
| **What are hooks?**            | Functions that let you use state and lifecycle in functional components                    |
| **How does useEffect work?**   | Runs side effects after render; dependency array controls when it runs                     |
| **What is Context API?**       | Way to pass data through component tree without prop drilling                              |
| **How do keys work in React?** | Help React identify which items changed; should be stable and unique                       |

### **Advanced Level **

| Question                              | Answer                                                                             |
| ------------------------------------- | ---------------------------------------------------------------------------------- |
| **Explain React Fiber**               | Reconciliation algorithm that enables incremental rendering and prioritization     |
| **What are Higher-Order Components?** | Functions that take a component and return enhanced component                      |
| **How do you optimize performance?**  | useMemo, useCallback, React.memo, code splitting, virtualization                   |
| **What's new in React 19?**           | `useActionState` for form handling, Server Actions, improved performance           |
| **How does useActionState work?**     | Manages async actions with built-in loading/error states, prevents race conditions |

### **Scenario-Based Questions **

**Q: Your React app is slow. How do you optimize it? **

> **A:** Check unnecessary re-renders with React DevTools, use `React.memo` for pure components, implement `useMemo` for expensive calculations, code-split with `React.lazy`, virtualize long lists, and optimize images.

**Q: How do you handle forms in React? **

> **A:** Two approaches: controlled components (React state manages inputs) or uncontrolled components (refs). For complex forms, use libraries like React Hook Form or Formik.

**Q: How do you manage global state? **

> **A:** For simple cases, use Context API. For complex applications, use Redux or Zustand. Consider app size, team familiarity, and performance needs.

**Q: How do you handle authentication in React? **

> **A:** Create auth context, protect routes with wrapper components, store tokens in memory or httpOnly cookies, handle login/logout flows.

---

## **32. QUICK REFERENCE CHEAT SHEET**

### **Component Creation**

```javascript
// Functional component (modern)
function Welcome({ name }) {
  return <h1>Hello, {name}</h1>;
}

// Class component (legacy)
class Welcome extends React.Component {
  render() {
    return <h1>Hello, {this.props.name}</h1>;
  }
}
```

### **Hooks Cheat Sheet**

```javascript
// State
const [count, setCount] = useState(0);

// Effect
useEffect(() => {
  // effect
  return () => {
    /* cleanup */
  };
}, [deps]);

// Context
const value = useContext(MyContext);

// Reducer
const [state, dispatch] = useReducer(reducer, initialState);

// Memoization
const memoValue = useMemo(() => compute(a, b), [a, b]);
const memoCallback = useCallback(() => fn(a, b), [a, b]);

// Ref
const ref = useRef(initialValue);
```

### **React Router**

```javascript
<BrowserRouter>
  <Routes>
    <Route path="/" element={<Home />} />
    <Route path="/about" element={<About />} />
  </Routes>
</BrowserRouter>;

// Navigation
const navigate = useNavigate();
navigate("/path");

// Params
const { id } = useParams();

// Query params
const [searchParams] = useSearchParams();
```

### **Common Patterns**

| Pattern                   | Code                                                      |
| ------------------------- | --------------------------------------------------------- |
| **Conditional rendering** | `{isLoggedIn && <Dashboard />}`                           |
| **Lists with keys**       | `{items.map(item => <li key={item.id}>{item.text}</li>)}` |
| **Event handlers**        | `<button onClick={() => handleClick(id)}>`                |
| **Child components**      | `<Card><p>Child content</p></Card>`                       |
| **Controlled inputs**     | `<input value={value} onChange={handleChange} />`         |

### **React 19 New Features **

```javascript
// useActionState
const [state, formAction] = useActionState(action, initialState);

// Form actions
<form action={formAction}>
  <button disabled={state.pending}>Submit</button>
</form>;
```

---

## **📝 KEY TAKEAWAYS**

1. **React is declarative** – Describe what UI should look like, React handles updates
2. **Component-based** – Build reusable pieces, compose them together
3. **JSX is syntax sugar** – HTML-like in JavaScript, transpiles to `React.createElement`
4. **Props are read-only** – Data flows down, events flow up
5. **State drives UI** – Change state, React re-renders
6. **Hooks are modern** – `useState`, `useEffect`, `useContext` for functional components
7. **Virtual DOM** – Efficient updates via diffing algorithm
8. **Keys matter** – Stable, unique keys for list performance
9. **Think in React** – Component hierarchy, single responsibility
10. **Optimize wisely** – Memoization, code splitting, virtualization

---

_Good luck with your React interview! ⚛️🎉_
