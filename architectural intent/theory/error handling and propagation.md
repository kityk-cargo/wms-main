# Error Handling and Propagation

## Core Principles

There are 2 distinct cases of an application-originated error being handled finally:

1. **User-facing errors**: A simple display to the user with the goal "Make the user see the error and be as informative (inside need-to-know) as we can"

2. **Automatic error handling**: Parse the error and handle it automatically, while logging it still (or even showing to the user). 


## What is an error and why p.2

Theoretically it should never be that the error is a part of the normal flow and therefore someone MUST be informed at anytime if the error happened. 

However, I acknowledge that theory isn't how things actually are with a lot of unpredictability, so I would advise to review and consider wisely when logging errors, what level should it be put on.

A good advice is only to log 'error' logs in the customer-facing services while all the deep backend, especially for business logic errors, should 

### Logging errors and reporting erors are not the same


#### Reporting errors

'Reporting' means anything that reports as an error -- constraint missed, expected negative scenario of any kind that's a problem for the client etc. 

It SHOULD not be withheld from being reported as error if the Product thinks that's normal flow. It should still contain recovery info when possible and be as helpful as possible to solve the problem for the user.

#### Logging errors

Error log discipline is a big deal. Product MUST be involved in identifying which negative flow IS A MUST to be logged because WE MUST UNDERSTAND WHY SOMETHING THAT WASN'T POSSIBLE HAPPENED, or why some failure prevented us from operating correctly (not happy-path correctly, just correctly).

Therefore error logs MUST be kept to a minimum and it MUST not be the rule to just log any exception as 'error'. 'warn' or 'info' is enough, depending on perceived severity. All of the 'error' logs MUST be agreed with a Product Owner, explaining the impact as they MUST be monitored on the observability dashboard constantly. 

0 error logs means correct operation, everything else means incorrect operation, and MUST be assigned PRIORITY 0 for triage.

Triage might be fast or even automated in some cases (DB outages that resolve quickly etc).


## Monitoring Guidelines

All the 'error' level logs should be on the dashboard in PROD and CI.