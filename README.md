# moodle-configurable_reports-custom_sql_queries

SQL query library for Moodle's **Configurable Reports** plugin.

## What is the Configurable Reports plugin?

**Configurable Reports** is a Moodle plugin that lets admins/teachers build custom reports (including SQL-based reports) directly inside Moodle.

It is commonly used to:
- query Moodle data for operational insight,
- build monitoring/audit views,
- create filtered reports with placeholders (e.g. course/user/date filters),
- output clickable links back into Moodle pages.

## Where to download it

You can get the plugin from Moodle Plugins directory:

- https://moodle.org/plugins/block_configurable_reports

Install options:
- via Moodle plugin installer (upload ZIP in Site administration), or
- by placing the plugin code into your Moodle installation and completing upgrade.

> Note: Confirm compatibility with your Moodle version before installing/upgrading.

## Purpose

This repository stores reusable SQL reports used for Moodle data analysis, storage audits, and operational reporting.

## Folder structure

- `course/` → course-level reports (course content, course file size summaries, per-course breakdowns)
- `activity/assignment/` → assignment-specific reports (submission, feedback, conversion, grading/turnaround)
- `activity/h5p/` → H5P-specific reports (attempts, duration, first-vs-best, user session views)
- `activity/quiz/` → quiz-specific reports (attempt counts, participation, slot/structure checks)
- `activity/grade/` → gradebook-related reports (grade results, grade vs completion)
- `user/` → user-centric reports (private files, backups, profile/cohort, duplicates)
- `dedup/` → physical file deduplication/reuse analysis (contenthash-based)
- `admin/` → sitewide operational/admin reports (backups, recycle bin, cleanup-focused views)
- `experimental/` → draft queries, placeholders, and in-progress SQL

## Naming convention

Use clear, descriptive, kebab-case filenames ending in `.sql`.

## Usage notes

- Queries use `prefix_` table names. Replace with your Moodle DB prefix if needed.
- Some reports include `%%WWWROOT%%` placeholders for clickable links in Configurable Reports.
- Some reports rely on Configurable Reports placeholders/filters (e.g., `%%COURSEID%%`, `%%FILTER_*%%`).
- Test in staging first for heavy queries on large Moodle datasets.
