# React + TypeScript

1. Components, Props & TypeScript
2. Handling Events
3. Working with State
4. Handling Input via Forms & Refs

Reminder: Invoking the TypeScript compiler:
```bash
npx tsc first-app.ts
```

## Create a new TSX Project

```bash
npm create vite@latest react-ts-basics
```

# CourseGoal Example

File = components/CourseGoal.tsx
```tsx
export default function CourseGoal(props: {
    title: string;
    description: string;
}) {

    return (
        <article>
            <div>
                <h2>{props.title}</h2>
                <p>{props.description}</p>
            </div>
            <button>Delete</button>
        </article>
    );
}
```

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