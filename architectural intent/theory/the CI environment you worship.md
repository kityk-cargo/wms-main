# The CI Environment You Worship

## Introduction

At the time of writing this there's no CI/PROD for WMS however it's important to voice this.

## Core Principles

The CI environment in SaaS should be a place of worship, and bugs on CI should be treated the same way as bugs on PROD.

That doesn't mean we should not deliver fast, rather that our delivery process should be such that we could test integration and deployability without affecting CI.

## Anti-patterns

Naming "CI" "UAT" and the actual CI when testing happens "SIT" doesn't work, as practice had shown. All it does is slows down delivery to a crawl.

## Recommended Approach

There should be ONE 'CI' environment where we integrate against 3rd party CI and that should be treated as prod. Probably it must be a direct copy of PROD with GDPR-compliant data.

Maybe there might be another environment that runs against 3rd party mocks, eliminating the dependency on the 3rd party disruptions and relying on the 3rd party contract. This one should be used for acceptance testing.