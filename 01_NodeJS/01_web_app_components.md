## FRONTEND

Runs on the client. Typically, a web browser.

## MIDDLEWARE

Connects an application's frontend and backend, and performs actions such as:
- Integrating with 3rd party services
- Transferring and updating data
- Serving the correct data for a particular URL
- Handling DB connections
- Performing authorization

(Think of employees on the company floor)

As full-stack developers, we often write middleware for **routing our applications**.
e.g. google.com => The middleware asks the server for landing the page's HTML code.
Then, a different part of the middleware checks whether the user is logged in, and if so,
which personal data it should show. Meanwhile, a third part of the middleware consolidates 
the information from each of these data streams and then answers the server's request with the
correct HTML.

JavaScript-driven development relies on two primary
architectural frameworks for creating APIs:
1. REST
2. GraphQL.

The middleware layer can be written in any programming
language.

## BACKEND

In a JavaScript-driven app, the backend runs on a server,
typically **Express.js, Apache or NGINX**.