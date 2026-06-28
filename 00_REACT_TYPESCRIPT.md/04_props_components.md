# Props and Custom Types

## CourseGoal() with JS object de-structuring

File = components/CourseGoal.tsx
```tsx
export default function CourseGoal({ title, description } : {
    title: string;
    description: string;
}) {
    return (
        <article>
            <div>
                <h2>{title}</h2>
                <p>{description}</p>
            </div>
            <button>Delete</button>
        </article>
    );
}
```

File = App.tsx
```tsx
import CourseGoal from './components/CourseGoal.tsx';

export default function App() {

    return (
    <main>
        <CourseGoal 
            title="Learn React + TS" 
            description="Learn it from the ground up"
        />
    </main>
    );
}
```

## Storing the props object as a Custom Type (type alias)

File = components/CourseGoal.tsx
```tsx
// 'type' is a decorator that tells tsc that this can
// be removed, since the browser won't be able to process.
import { type ReactNode } from 'react';

type CourseGoalProps = {
    title: string;
    description: string;
    children: ReactNode;
}

export default function CourseGoal({ title, description} : CourseGoalProps) {

    return (
        <article>
            <div>
                <h2>{title}</h2>
                <p>{description}</p>
            </div>
            <button>Delete</button>
        </article>
    );
}
```

Note* Developers will use `interface` and `type` almost
interchangeably.

### PropsWithChildren (Generic Type)

```tsx
import { type PropsWithChildre, type ReactNode } from 'react';

// PropsWithChildren is a generic type that only works
// in conjunction with another type.

type CourseGoalProps = PropsWithChildren<{ title: string}>;

export default function CourseGoal({
    title,
    chidlren
}: CourseGoalProps) {
    return (
        <article>
            <div>
                <h2>{title}</h2>
                <p>{description}</p>
            </div>
            <button>Delete</button>
        </article>
    );
}
```

## Component Props and the Special "key" Prop

All React components (both built-in and custom) do accept a
special `key` prop which is used by React to track
specific component instances.

For example, the `key` prop should always be set when
outputting a list of components. This `key` prop can be set
on custom components even if you did not specify it in your
props type.

```tsx
type UserProps = {
    name: string;
};

function User({ name }: UserProps) {
    return <li> User: {name}</li>;
}

function App() {

    const users = [{ name: 'John' }, { name: 'Mary'}, { name: 'Luke'}];

    return (
        <>
            <ul>
                {users.map((user, index) => {
                    <User key={user} name={user.name} />
                })
                }
            </ul>
        </>
    );
}
```