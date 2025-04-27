# Common Error Format

The common error format is a JSON structure with the following fields:

```json
{
    "criticality": "critical/non-critical/unknown",
    "id": "<here goes high-resolution UUID>",
    "title": "I might starve",
    "detail": "The ape ate all my bananas and I don't have bananas for dinner",
    "recoverySuggestion": "buy some bananas at the local store",
    "criticalityExplanation": "I can't have dinner without bananas so the dinner-eating can't progress/I can eat oats so it's not critical to have bananas/I have NO IDEA what's in my fridge so I don't know if I would stop because of it. Check the frigde or wait for more messages from me when I get home",
    "errorCode": "WMS_EXAMPLES_STARVING",
    "recoveryData": {
        //shit here
    },
    "otherErrors": [
        // multiple errors in the same format as the one above
    ]
}
```

## Field Descriptions

- **criticality** (required): Indicates whether the process requested was stopped by SERVER without valid response because of the error
  - Values: `critical`, `non-critical`, `unknown`
  - Note: Err on the side of critical if in doubt

- **id** (required): An id of the error, used for tracing it through the system in the logs etc -- ties to the observability.

- **title** (optional): Brief error message, usually used for UI message titles

- **detail** (required): The main error message

- **recoverySuggestion** (optional but highly recommended): Human-readable suggestion for resolving the error

- **criticalityExplanation** (optional): Explains the reasoning behind the criticality level
  - Highly recommended for unknown criticalities
  - I think it won't be used much but might be nice for event-driven early error reporting

- **errorCode** (optional): A machine-readable error code
  - Consumer should supply the codes, if any, that are needed from provider

- **suggestedHTTPCode** (optional): if given from non-HTTP protocol, a suggestion on what the HTTP code should be if it's reported back to the user via HTTP.

- **recoveryData** (optional): Information that might help for the specific purpose of recovering from the error in an automated way (or even manual if displayed on the UI correctly)

- **otherErrors** (optional): Array of additional errors in the same format

Any field other than those listed above is ALLOWED given it doesn't duplicate functionality with others.

## Recommendations

If there's more than one `otherError` that are critical, it might be good to provide a summary or prioritize them in some way for the user.

Ideally (subject to how localization works) the messages should be displayable on the UI so the UI would not need the errorCode to overwrite the message. Thus the continuity of human-readable information between back-end and UI is maintained. So ideally errorCode should not be used.