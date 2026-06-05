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

# A Simple JSX Expression

The entry point of each React application is precisely the
`App()` function:

```tsx
import React from "react";

export default function App() {

    const getElement = (weather: string): JSX.Element => {
        const element = <h1>The weather is {weather}</h1>;
        return element;
    };
    
    return getElement("sunny");
}
```

## A basic React (function) component

```tsx
import React from "react";

export default function App() {

    interface WeatherProps {
        weather: string;
    }

    const clickHandler = (text: string): void => {
        alert(text);
    };

    const WeatherComponent = (props: WeatherProps): JSX.Element => {
        const text = `The weather is ${props.weather}`;

        return (
            <h1 onClick = {() => clickHandler(text)}>
                {text}
            </h1>
        );
    };

    return (<WeatherComponent weather="sunny" />);

}
```

## A Basic React (Class) Component

```tsx
import React from "react";

export default function App() {

    interface WeatherProps {
        weather: string;
    }

    type WeatherState {
        count: number;
    };

    class WeatherComponent extends React.Component<WeatherProps, WeatherState> {
        constructor(props: WheatherProps) {
            super(props);
            this.state = {
                count: 0
            };
        }

        componentDidMount() {
            this.setState({ count: 1});
        }

        clickHandler(): void {
            this.setState({ count: this.state.count + 1 });
        }

        render() {
            return (
                <h1 onClick={() => this.clickHandler()}>
                The weather is {this.props.weather}, and the
                counter shows{" "}
                {this.state.count}
                </h1>
            );
        }
    }

    return (<WeatherComponent weather="Sunny" />);
}
```

## Providing Reusable Behavior with Hooks

```tsx
import React, { useState, useEffect} from "react";

export default function App() {

    interface WeatherProps {
        weather: string;
    }

    const WeatherComponent = ( props: WeatherProps): JSX.Element => {

        const [count, setCount] = useState(0);
        useEffect(() => {
            setCount(1)
        }, []); // Array of dependencies (if empty, code will execute only once).
        
        return (
            <h1 onClick={() => setCount(count+1)}>
                The weather is  {props.weather},
                and the counter shows {count}
            </h1>
        );
    };

    return (
        <WeatherComponent weather="sunny" />
    );
}
```
