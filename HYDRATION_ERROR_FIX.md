# 🔧 Hydration Error Fix

## Problem

**Error**: `Hydration failed because the initial UI does not match what was rendered on the server`

This is a common Next.js error that occurs when the server-rendered HTML doesn't match the client-side React render.

---

## Root Cause

The application was accessing `localStorage` and browser APIs during the initial render, which caused mismatches between:
- **Server-side rendering** (SSR): No access to `localStorage` or `window`
- **Client-side rendering**: Has access to `localStorage` and `window`

---

## Files Fixed

### 1. **`isuscitizen.utils.tsx`**
**Issue**: Accessing `localStorage` and `navigator` without checking if running in browser

**Fix**: Added `typeof window === 'undefined'` check
```tsx
export const isUSCitizen = () => {
  // Check if we're in the browser (client-side)
  if (typeof window === 'undefined') {
    return false; // Default for server-side rendering
  }
  
  const userLanguage = localStorage.getItem('isUS') || ...
  return userLanguage === 'US';
};
```

### 2. **`metric.component.tsx`**
**Issue**: Initializing state with `localStorage` values during render

**Fix**: 
- Initialize state with `null`
- Use `useEffect` to load from `localStorage` after mount
- Show loading skeleton until client-side hydration completes

```tsx
const [currentMetric, setCurrentMetric] = useState<boolean | null>(null);
const [timezone, setTimezone] = useState<string | null>(null);

useEffect(() => {
  setCurrentMetric(isUSCitizen());
  setTimezone(localStorage.getItem('timezone') || dayjs.tz.guess());
}, []);

// Show loading state during hydration
if (currentMetric === null) {
  return <div className="animate-pulse h-10 bg-fifth rounded"></div>;
}
```

### 3. **`launches.component.tsx`**
**Issue**: Initializing `isOpen` state with `localStorage` value

**Fix**:
- Initialize with default value (`true`)
- Load saved state in `useEffect` after mount
- Added `typeof window !== 'undefined'` checks

```tsx
const [isOpen, setIsOpen] = useState(true);

useEffect(() => {
  if (typeof window !== 'undefined') {
    const saved = localStorage.getItem(group.name + '_isOpen');
    if (saved !== null) {
      setIsOpen(!!+saved);
    }
  }
}, [group.name]);
```

### 4. **`editor.tsx`**
**Issue**: Accessing `localStorage` for theme without checking browser environment

**Fix**: Added `typeof window !== 'undefined'` check
```tsx
theme={typeof window !== 'undefined' 
  ? (localStorage.getItem('mode') as Theme) || Theme.DARK 
  : Theme.DARK}
```

---

## Solution Pattern

For any component that needs to access browser-only APIs during render:

### Pattern 1: Check if in Browser
```tsx
if (typeof window === 'undefined') {
  return defaultValue; // Server-side default
}
// Browser-side code
```

### Pattern 2: Use useEffect for State Initialization
```tsx
const [state, setState] = useState(null); // or default value

useEffect(() => {
  // This only runs on client-side
  setState(localStorage.getItem('key'));
}, []);

// Optional: Show loading state
if (state === null) {
  return <LoadingComponent />;
}
```

### Pattern 3: Inline Conditional
```tsx
<Component 
  value={typeof window !== 'undefined' 
    ? localStorage.getItem('key') 
    : 'default'
  } 
/>
```

---

## Testing

After these fixes, the hydration error should be resolved. To verify:

1. **Clear browser cache and localStorage**:
   ```javascript
   localStorage.clear();
   location.reload();
   ```

2. **Check browser console**: No hydration errors should appear

3. **Test SSR**: View page source (right-click → View Page Source) to ensure HTML is rendered

4. **Test functionality**: Ensure all localStorage-dependent features still work:
   - Date metrics selection
   - Timezone settings
   - Menu group open/close states
   - Theme selection

---

## Prevention

To prevent future hydration errors:

1. ✅ **Never** access `localStorage`, `sessionStorage`, or `window` during initial render
2. ✅ **Always** use `useEffect` for browser-only code
3. ✅ **Check** `typeof window !== 'undefined'` before accessing browser APIs
4. ✅ **Initialize** state with SSR-safe defaults
5. ✅ **Test** with JavaScript disabled to catch SSR issues

---

## Related Resources

- [Next.js Hydration Error Docs](https://nextjs.org/docs/messages/react-hydration-error)
- [React Hydration Docs](https://react.dev/reference/react-dom/client/hydrateRoot)
- [SSR Best Practices](https://nextjs.org/docs/pages/building-your-application/rendering/server-side-rendering)

---

**Status**: ✅ Fixed

**Date**: October 6, 2025

**Impact**: Resolves hydration errors across the application, ensuring consistent SSR and CSR rendering.
