# Inter-Steward gitmaildir Message Template

This template describes a real gitmaildir `MailboxMessage`. It is materialized as JSON at:

```text
plans/inbox/new/steward-follow-up/<generated-id>.json
```

Generate the top-level ID with gitmaildir. `GitPublisher` supplies the delivery commit and push; a
manually created but unpushed JSON file is only a prepared message, not delivered transport evidence.

```json
{
  "id": "<yyyyMMddTHHmmssSSS>Z.steward-follow-up.<4hex>",
  "type": "steward-follow-up",
  "from": "<sending-steward>",
  "createdAt": "<ISO-8601 instant>",
  "retryCount": 0,
  "lease": null,
  "payload": {
    "schemaVersion": 1,
    "correlationId": "<durable sender-owned ID>",
    "subject": "<short subject>",
    "authorityPointers": [
      {
        "repository": "<repository identity>",
        "commit": "<full commit or pending commit marker>",
        "path": "<authority path>"
      }
    ],
    "requestedOutcome": "<one concise recipient-owned outcome>",
    "replyTo": "<sending steward identity>"
  }
}
```

The payload points to the authority for semantics; it does not restate a design or copy roadmap work
items. The recipient records exactly one disposition in its own authority: `FILED`, `RATIFIED`,
`REFUTED`, or `PARKED`.

The response is another immutable gitmaildir message:

```text
plans/inbox/new/steward-receipt/<generated-id>.json
```

```json
{
  "id": "<yyyyMMddTHHmmssSSS>Z.steward-receipt.<4hex>",
  "type": "steward-receipt",
  "from": "<receiving-steward>",
  "createdAt": "<ISO-8601 instant>",
  "retryCount": 0,
  "lease": null,
  "payload": {
    "schemaVersion": 1,
    "inReplyTo": "<original gitmaildir message ID>",
    "correlationId": "<original correlation ID>",
    "disposition": "<FILED | RATIFIED | REFUTED | PARKED>",
    "authorityPointer": {
      "repository": "<repository identity>",
      "commit": "<full commit>",
      "path": "<ROADMAP, journal, or refutation path>"
    }
  }
}
```

Handlers must be idempotent: a retry with the same message ID must not create duplicate roadmap items
or receipts.
