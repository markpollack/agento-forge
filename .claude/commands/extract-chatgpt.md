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

Save the extracted markdown to a file:
- Create a `conversations/` directory in the current working directory if it doesn't exist
- Generate a filename with format: `<short-description>-YYYYMMDD-HHMMSS.md`
  - Description: 2-4 words from the conversation topic, lowercase, hyphenated (e.g., `linkedin-profile-tips`, `spring-ai-scoring`)
  - Timestamp: current date/time (e.g., `20260125-141532`)
- Example: `conversations/linkedin-experience-rewrite-20260125-141532.md`

### Step 4: Report back

Tell the user:
- The file path where the conversation was saved
- A brief summary of the conversation topic (1-2 sentences)
- The number of messages extracted
