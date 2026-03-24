# moodle-configurable_reports-custom_sql_queries

SQL query library for Moodle's **Configurable Reports** plugin.

## Purpose

This repository stores reusable SQL reports used for Moodle data analysis, storage audits, and course/file reporting.

## Structure

- `course/` → course-related and storage-related SQL queries

## Naming convention

Use clear, descriptive, kebab-case filenames ending in `.sql`.

Examples:
- `course-mp4-file-locations.sql`
- `course-storage-breakdown-by-area.sql`

## Usage notes

- Queries use `prefix_` table names. Replace with your Moodle DB prefix if needed.
- Some reports include `%%WWWROOT%%` placeholders for clickable links in Configurable Reports.
- Test in staging first when queries are heavy on large Moodle datasets.
