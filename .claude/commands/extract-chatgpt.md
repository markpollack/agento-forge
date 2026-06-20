---
name: extract-chatgpt
description: Extract a ChatGPT shared conversation and save as markdown
---

# Extract ChatGPT Conversation

Extract a shared ChatGPT conversation and save it as markdown.

## Arguments
- `$ARGUMENTS` - The ChatGPT share URL (e.g., https://chatgpt.com/share/...)

## Instructions

Extract the full conversation from the provided ChatGPT shared link using Puppeteer MCP.

### Step 1: Navigate to the URL

Use Puppeteer to navigate to the ChatGPT share URL:
- URL: `$ARGUMENTS`
- Launch options: `{"headless": true, "args": ["--no-sandbox", "--disable-setuid-sandbox"]}`
- Set `allowDangerous: true` (required for Linux sandbox bypass)

### Step 2: Extract the conversation

Run this JavaScript via `puppeteer_evaluate`:

```javascript
const messages = document.querySelectorAll('[data-message-author-role]');
let conversation = [];

messages.forEach((msg, i) => {
  const role = msg.getAttribute('data-message-author-role');
  const text = msg.innerText.trim();
  if (text) {
    conversation.push({
      role: role,
      content: text
    });
  }
});

let markdown = `# ChatGPT Conversation Export\nSource: ${window.location.href}\n\n---\n`;

conversation.forEach(msg => {
  markdown += `\n## ${msg.role.toUpperCase()}\n\n${msg.content}\n\n---\n`;
});

markdown;
```

### Step 3: Save the conversation

Capture is deliberately **dumb** — save the raw conversation but do **not** assign a topic
prefix or sequence number. That is an authority decision made at intake by
`/ingest-conversation`.

Choose the destination by checking whether the current working directory is a federated KB
with a conversation-intake contract:

- **If `conversations/INTAKE.md` exists** in the current working directory: save into that
  KB's landing dir `conversations/ongoing/inbox/` (create if missing), using a capture name
  `ChatGPT-<short-description>-YYYYMMDD-HHMMSS.md`. Do **not** add a `{PREFIX}-{N}` — intake
  assigns those.
- **Otherwise** (generic use): keep the original behavior — save to a `conversations/`
  directory (create if missing) as `<short-description>-YYYYMMDD-HHMMSS.md`.

Naming details:
- Description: 2-4 words from the conversation topic, lowercase, hyphenated (e.g., `markov-lyapunov-analysis`)
- Timestamp: current date/time (e.g., `20260125-141532`)
- Example (KB inbox): `conversations/ongoing/inbox/ChatGPT-managed-agents-inquiry-20260619-085800.md`
- Example (generic): `conversations/linkedin-experience-rewrite-20260125-141532.md`

### Step 4: Report back

Tell the user:
- The file path where the conversation was saved
- A brief summary of the conversation topic (1-2 sentences)
- The number of messages extracted
- **If it landed in a KB inbox** (`conversations/ongoing/inbox/`): tell the user to run
  `/ingest-conversation` in that KB to assign the prefix and synthesize it.
