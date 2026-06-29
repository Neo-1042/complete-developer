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