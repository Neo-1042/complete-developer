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
import { useEffect } from 'react';

// By default, this code will run every time the component is
// created or updated, but you can add a dependency array[]
useEffect(() => {
    axios.get('http://localhost:3000/api/products')
        .then((response) => {
            console.log(response.data);
        });
}, []); //empty dependency array -> will only run ONCE.
```