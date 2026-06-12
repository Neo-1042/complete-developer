# React

A JavaScript library for web development released by
Facebook in 2013.

## Using React for websites:

- Load React + React DOM

## Using React for mobile apps:
- Load React + ReactNative

File = react-basics.html

```html
<script type="text/babel">
        // DOM = Document Object Model
        const container = document.querySelector('.js-container'); // . --> means a class
        // To setup React, we have to give it an HTML element:
        ReactDOM.createRoot(container).render('Hello, World from React! .js-container');
</script>
```

## Babel + JSX = JavaScript XML or JavaScript Syntax Extension

Babel is a JavaScript compiler (transpiler) which translates
other languages into JavaScript.

When working with React, we don't directly use JavaScript,
instead, we use an enhanced version called
**JSX = JavaScript XML**.

JSX Example:

```jsx
const button = <button>Hello JSX</button>;
```

JavaScript Equivalence:
```javascript
const button = document.createElement('button');
button.innerHTML = 'hello';
```

Web Browsers don't understand JSX, but **Babel** takes care of
this.

```jsx
// It's a good practice to add these parentheses ()
// Notice the JavaScript code inside the curly braces {2+7}
const div = (
    <div>
        <button>Hello, JSX Button</button>
        <p>JSX Paragraph of text {2+7}</p>
    </div>
);

const container = document.querySelector('.js-container');
ReactDOM.createRoot(container).render(div);
```

React elements are immutable, and they make up components.

Elements ---> Components.

## React Components

Classes or functions (more frequently) that output elements.
A single physical file contains all the information necessary
for a component, regardless of the underlying technologies.

# Vite

```bash
npx create-vite@6.0.1
# npm create vite

cd new-project
npm install
npm run dev
```

## ESLint

ESLint is a JavaScript and TypeScript static code analysis
tool.

## Hooks

Hooks allow you to insert React features (e.g. State)
into your component.

```tsx
React.useState(); // [counter, setCounter] Keep track of states
React.useEffect(); // Dependency array. Execute it only once []
React.useRef(); // Automatically save an HTML element from the component.
// It let's you reference a value that is not needed for
// rendering
React.useContext(); // Manage the global state.
```

## Imports

```tsx
// DEFAULT IMPORT
import ChatMessages from './components/ChatMessages';

// NAMED IMPORT
import { ChatInput } from './components/ChatInput';
```