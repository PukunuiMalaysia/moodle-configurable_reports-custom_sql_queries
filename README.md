# moodle-configurable_reports-custom_sql_queries

SQL query library for Moodle's **Configurable Reports** plugin.

## Purpose

This repository stores reusable SQL reports used for Moodle data analysis, storage audits, and operational reporting.

## Folder structure

- `course/` → course-level reports (course content, course file size summaries, per-course breakdowns)
- `activity/assignment/` → assignment-specific reports (submission, feedback, conversion, grading/turnaround)
- `activity/h5p/` → H5P-specific reports (attempts, duration, first-vs-best, user session views)
- `user/` → user-centric reports (private files, per-user usage)
- `dedup/` → physical file deduplication/reuse analysis (contenthash-based)
- `admin/` → sitewide operational/admin reports (backups, recycle bin, cleanup-focused views)
- `experimental/` → draft queries, placeholders, and in-progress SQL

## Naming convention

Use clear, descriptive, kebab-case filenames ending in `.sql`.

## Usage notes

- Queries use `prefix_` table names. Replace with your Moodle DB prefix if needed.
- Some reports include `%%WWWROOT%%` placeholders for clickable links in Configurable Reports.
- Test in staging first for heavy queries on large Moodle datasets.
