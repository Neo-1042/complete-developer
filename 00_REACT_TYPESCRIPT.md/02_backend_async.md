# Asynchronous Code and `fetch()`

When fetching data from a backend, we are dealing with
asynchronous code, which refers to code that does not run
immediately; it may take a while before it's done fetching.

`fetch('http://localhost:3000')` ---> returns a **Promise**,
which lets us wait for asynchronous code to finish.
A Promise has a method:  

`.then((response) => {} )` ---> this code runs when the client
finally gets the response from the backend, the code inside
`then()` is executed. 

`response` has a method called `json()` ---> returns the data
that is attached to the response. However, `response.json()`
is also asynchronous, so we cannot save it in a variable.
Instead, this is yet another `Promise`.

```jsx
fetch('http://localhost:3000/api/products')
    .then((response) => {
        response.json()
            .then((data) => {
                console.log(data);
            });
    });
```

## Axios = cleaner requests to the backend

`npm install axios@1.8.4`

```jsx
import axios from 'axios';

axios.get('http://localhost:3000/api/products')
    .then((response) => {
        console.log(response.data);
    });
```

## Axios + useEffect

`useEffect()` lets us control *when* some code runs.

```jsx
import { useEffect, useState } from 'react';

const [products, setProducts] = useState([]); // [currentValue, updater function]

// By default, this code will run every time the component is
// created or updated, but you can add a dependency array[]
useEffect(() => {
    axios.get('http://localhost:3000/api/products')
        .then((response) => {
            setProducts(response.data);
        });
}, []); //empty dependency array -> will only run ONCE.
```

## Update the cart counter

```jsx
import { useEffect, useState } from 'react';

const [products, setProducts] = useState([]); // [currentValue, updater function]
const [cart, setCart] = useState([]);

// By default, this code will run every time the component is
// created or updated, but you can add a dependency array[]
useEffect(() => {
    axios.get('http://localhost:3000/api/products')
        .then((response) => {
            setProducts(response.data);
        });
    // Update the cart
    axios.get('http://localhost:3000/api/cart-items')
        .then((response) => {
            setCart(response.data);
        });
    // <Header cart={cart}>


}, []); //empty dependency array -> will only run ONCE.
```

Pass the cart information to the Header.jsx file:
```jsx
export function Header({ cart }) {

    let totalQuantity = 0;

    cart.forEach((cartItem) => {
        totalQuantity += cartItem.quantity;
    });

    return(
        <h1>HTML Code for the Header</h1>
    );
}
// This is a shortcut for:
export function Header(props) {
    const cart = props.cart;
}
```

### Server Proxy Configuration

File = vite.config.js
```javascript
export default defineConfig({
    plugins: [react()],
    server: {
        proxy: {
            '/api': {
                target: 'http://localhost:3000'
            },
            '/images': {
                target: 'http://localhost:3000'
            }
        }
    }
})
```

## Expand the cart with Product Details

```jsx
function App() {
    const [cart, setCart] = useState([]);

    useEffect(() => {
        axios.get('/api/cart-items?expand=product')
            .then((response) => {
                setCart(response.data);
            });
    }, []);
}
```

## Delivery Options with useEffect

```jsx
export function CheckoutPage(props) {
    const cart = props.cart;

    const [deliveryOptions, setDeliveryOptions] = useState([]);
    // Add State for the payment summary
    const [paymentSummary, setPaymentSummary] = useState(null);


    useEffect(() => {
        axios.get('/api/delivery-options')
            .then((response) => {
                setDeliveryOptions(response.data);
            });
        // Get the payment summary
        axios.get('/api/payment-summary')
            .then((response) => {
                setPaymentSummary(response.data);
            });
    }, []);


}
```

```bash
npm install dayjs@1.11.13
```

```jsx
const selectedDeliveryOption = deliveryOptions
    .find((deliveryOption) => {
        // find() will loop through every option
        // The first function that returns true will
        // be saved in 'deliveryOption'
        return deliveryOption.id === cartItem.deliveryOptionId;
    });
```

# Just React Book

## async/await

JavaScript is a single-threaded programming language. This
language can only process one line of code at a time.

### Synchronous JavaScript

```javascript
function getContent() {
    return "React";
}

function display() {
    const what = getContent();
    console.log(what);
}

console.log("Learning");
display();
```

### Emulating Asynchronous Code

```javascript
// setTimeOut() emulates waiting for the server response
function getContent() {
    setTimeOut(() => {
        return "React"
    }, 2000);
}

function display() {
    const what = getContent();
    console.log(what);
}

console.log("Learning");
display();
```

## async + await

```javascript
function getContent() {
    return new Promise((resolve, reject) => {
        setTimeOut(() => resolve("React"), 1000);
    });
}

async function display() {
    const what = await getContent();
    console.log(what);
}

console.log("Learning");
display();
```