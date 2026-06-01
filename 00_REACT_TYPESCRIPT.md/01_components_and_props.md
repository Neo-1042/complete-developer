# React Components and Props

**Component** = a piece of the website. When building
websites, it's better to split up the website into pieces
or components.

In React, component names must start with Capital Letters:  
`MyReactComponent`

In JSX, embedded HTML code is more strict: every single
element needs to have a closing tab. For example, input:
```jsx
<input>
    <button>Send</button>
</input>;
<!-- Self closing element -->
<input />;
```

### Component Syntax

```jsx
function ChatInput() {
    return (
        <div>
            <input></input>
            <button>Send</button>
        </div>
    );
}

<ChatInput></ChatInput>
<ChatInput />
```

## JavaScript Guard Operator (&&)

```javascript

// If value1 is true, then value2 will be assigned to 'result'
const result = value1 && value2;
```

## State

State ---> Data that is connected to the HTML:
when we update this data, it will update the HTML.

Convert data into a STATE:
```jsx
const array = React.useState();
// A new state gives us 2 values:
const chatMessages = array[0]; // Current data
const setChatMessages = array[1]; // Updater function
```