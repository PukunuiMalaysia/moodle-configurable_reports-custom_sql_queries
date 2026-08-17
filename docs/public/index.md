---
title: Configurable Reports SQL query library
---

# Configurable Reports SQL query library

This repository provides reusable SQL reports for Moodle's Configurable Reports plugin. Reports cover course and activity analysis, grades, users, storage, backups, file reuse, and operational administration.

## Requirements and use

- Install a compatible release of the [Configurable Reports plugin](https://moodle.org/plugins/block_configurable_reports).
- Choose a query for the required reporting area, review its purpose and joins, then paste it into a Configurable Reports SQL report.
- Keep `prefix_` table names and placeholders such as `%%WWWROOT%%`, `%%COURSEID%%`, and `%%FILTER_*%%`; Configurable Reports substitutes them at runtime.
- Test in staging before production, particularly for storage, backup, file, deduplication, and cross-activity queries.

## Database and privacy cautions

Some queries use database-specific functions and may require adaptation between MySQL and PostgreSQL. Review the query plan and require filters before running a heavy site-wide report.

Reports can expose identity, grades, activity, files, backups, or other personal and operational information. Apply the minimum report capability, avoid public report pages, limit exported columns, and protect downloaded results. Never paste credentials, production hostnames, or real user data into a public issue.

## Support

- [Report a bug or request a query](https://github.com/PukunuiMalaysia/moodle-docs/issues/new?template=feature.yml)
- [Pukunui Plugin Subscription Terms & Support Policy](https://pukunui.com/docs/policy-moodle-marketplace/)
- [Pukunui Malaysia](https://pukunui.com/home/location/malaysia/)

Original documentation copyright Pukunui Sdn Bhd and contributors, licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
