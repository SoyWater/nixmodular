---
description: Update translations in cs.json and en.json files and optionally update component usage
---

Updates translations in the `cs.json` and `en.json` message files and optionally updates component files to use translation keys with the `t()` function. This command integrates with Figma to extract text when layer references are provided.

## Arguments:

$ARGUMENTS

Context/description of what translations to add (e.g., 'Add sign-up form translations' or 'Get text from Figma node 123:456')

## Steps:

1. **Validate and parse input**:
   - If $ARGUMENTS is empty: Ask user for context (what translations to add or update)
   - Check if context mentions Figma (e.g., "Figma node", "Figma layer", "node-id")
   - Check if context mentions a component file path to update (e.g., "src/components/...")
   - Extract and validate any Figma node IDs from the context

2. **Extract translations from Figma** (if applicable):
   - If Figma node ID is provided:
     - Use `mcp__figma-dev-mode-mcp-server__get_design_context` to extract text content and structure
     - Use `mcp__figma-dev-mode-mcp-server__get_metadata` if needed for component hierarchy
     - Extract all text labels, headings, descriptions, placeholders, buttons, etc.
     - Organize extracted content by logical groupings
   - If no Figma reference: Parse the context to understand what translations should be added

3. **Auto-determine namespace**:
   - Analyze the context for component names, file paths, or functional areas
   - Look for patterns like "sign-in", "HomePage", "Button", etc.
   - Convert to PascalCase for namespace (e.g., "sign-in form" -> "AuthSignIn")
   - If component file path is mentioned: Extract namespace from filename (e.g., `SignUp.tsx` -> `AuthSignUp`)
   - Ask user to confirm namespace if ambiguous

4. **Read current translation files**:
   - Read `src/i18n/messages/cs.json` (Czech translations)
   - Read `src/i18n/messages/en.json` (English translations)
   - Parse both as JSON objects while preserving structure

5. **Identify and validate translation keys**:
   - Generate appropriate nested keys based on determined namespace
   - Keys should follow camelCase convention for nested properties
   - For example: `AuthSignIn.error.email`, `HomePage.title`, `FormButton.label`
   - Validate keys don't already exist or note conflicts for user confirmation
   - Group related keys under the same namespace object

6. **Handle conflicts**:
   - For each new key that already exists with different content:
     - Show user the existing and new values
     - Ask which version to keep: keep existing, use new, or manually provide custom value
     - Update resolution based on user choice

7. **Update translation files**:
   - Update `cs.json` with Czech translations in appropriate namespace
   - Update `en.json` with English translations in appropriate namespace
   - Preserve all existing translations and structure
   - Maintain consistent formatting and indentation (2 spaces)
   - Write updated files and inform user of changes

8. **Optional: Update component files** (if path provided or user confirms):
   - Find the component file referenced in the context or ask user which file to update
   - Identify hardcoded strings that match the translation keys being added
   - For server components:
     - Add `const t = await getTranslations('NamespaceName')`
     - Replace hardcoded strings with `t('key')` calls
   - For client components:
     - Add `'use client'` if not present
     - Add `const t = useTranslations('NamespaceName')`
     - Replace hardcoded strings with `t('key')` calls
   - Verify file is valid TypeScript/TSX after modifications
   - Inform user of component updates

9. **Provide summary**:
   - List all new/updated translation keys in each namespace
   - Show which locales were updated (cs, en)
   - If component was updated: List the files modified and number of replacements
   - Highlight any conflicts that were resolved
   - Remind user to test the translations in their components

## Translation Key Guidelines:

- **Namespace**: PascalCase, represents the component or feature (e.g., `AuthSignIn`, `HomePage`, `FormButton`)
- **Nested Keys**: camelCase for nested properties (e.g., `error.email`, `label.primary`, `placeholder.email`)
- **Key Patterns**:
  - `Namespace.title` - main heading or title
  - `Namespace.description` - detailed text
  - `Namespace.label` - form labels
  - `Namespace.placeholder` - input placeholders
  - `Namespace.error.fieldName` - validation errors
  - `Namespace.button.action` - button text (e.g., `submit`, `cancel`)

## Component Usage:

**Server Components** (async):

```typescript
import { getTranslations } from 'next-intl/server'

export default async function MyComponent() {
  const t = await getTranslations('MyNamespace')

  return <button>{t('button.submit')}</button>
}
```

**Client Components** (`'use client'`):

```typescript
'use client'

import { useTranslations } from 'next-intl'

export default function MyComponent() {
  const t = useTranslations('MyNamespace')

  return <button>{t('button.submit')}</button>
}
```

## Examples:

### Example 1: Add translations from context

- User: `/update-translations Add error messages for the sign-in form: 'Invalid email', 'Password required', button 'Sign in'`
- Command detects "sign-in" and creates `AuthSignIn` namespace
- Generates keys: `AuthSignIn.error.email`, `AuthSignIn.error.password`, `AuthSignIn.button.submit`
- Updates both cs.json and en.json with Czech and English translations

### Example 2: Extract from Figma

- User: `/update-translations Get translations from Figma node 123:456 for HomePage`
- Command extracts all text from the Figma node
- Auto-detects namespace as `HomePage`
- Creates appropriate translation keys for each text element
- Updates translation files

### Example 3: Update component with translations

- User: `/update-translations Update src/components/auth/SignUp.tsx with translations for form labels and error messages`
- Command finds the component file
- Identifies hardcoded strings
- Creates appropriate translation keys
- Replaces strings with `t()` calls in the component
- Updates translation files accordingly
