# redmine_issue_reminder 🔔

> A Redmine plugin that sends email reminders to assignees of open issues — from the admin panel, directly from the issue, or automatically via cron with built-in configuration.

[![Ruby](https://img.shields.io/badge/Ruby-2.7%2B-red?logo=ruby&logoColor=white)](https://www.ruby-lang.org/)
[![Redmine](https://img.shields.io/badge/Redmine-5.x-blue?logo=redmine&logoColor=white)](https://www.redmine.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/flitz-svg/redmine_issue_reminder/pulls)

---

## What is redmine_issue_reminder?

`redmine_issue_reminder` is a Redmine plugin that notifies users by email about their open assigned issues, reminding them to take action.

| Mode | Description |
|------|-------------|
| **Admin panel** | Filter issues by project, status, and days without activity, then send bulk reminders |
| **Per issue** | Button on the issue view to send a one-off reminder to the assignee |
| **Automatic (cron)** | Schedulable rake task for daily sends without manual intervention, configurable from the admin panel |

---

## Features

- ✅ **Admin panel** — accessible from the Redmine Admin menu
- ✅ **Advanced filters** — by project, status, and days of inactivity
- ✅ **Per-issue button** — visible to admins, the issue author, and the assignee
- ✅ **Grouped by user** — one email per assignee containing all their issues
- ✅ **Rake task** — integrates with cron or any scheduler
- ✅ **Built-in configuration** — on/off toggle, inactivity days, and filters saved from *Admin → Plugins → Configure*
- ✅ **Detailed logging** — every send is recorded to standard output

---

## Requirements

- Redmine **5.x or higher**
- Ruby **2.7+**
- Outgoing email configured in Redmine (*Administration → Settings → Email notifications*)

---

## Installation

```bash
# 1. Clone the plugin into your Redmine plugins directory
cd /path/to/redmine/plugins
git clone https://github.com/flitz-svg/redmine_issue_reminder.git

# 2. Restart Redmine
touch /path/to/redmine/tmp/restart.txt
# or depending on your server:
# sudo systemctl restart redmine
# sudo service apache2 restart
```

---

## Usage

### Admin panel

The **Issue Reminders** option appears in the **Administration** menu.

1. Select one or more projects (optional)
2. Select the issue statuses to include (optional)
3. Set the minimum number of days without activity (optional)
4. Check the issues you want to include
5. Click **Send reminders**

### Per-issue button

From an issue's detail view, the **Send reminder** button sends an email to the issue's assignee. It is visible to:

- Administrators
- The issue author
- The issue assignee

### Rake task (manual)

```bash
cd /path/to/redmine
bundle exec rake redmine:issue_reminder:send RAILS_ENV=production
```

---

## Automatic reminders with cron

### 1. Configure the behavior from Redmine

Go to **Administration → Plugins → Redmine Issue Reminder → Configure** and set:

- **Enable automatic reminders** — on/off toggle
- **Days without activity** — how many days must pass with no activity on an issue before a reminder is sent (default: 1)
- **Projects** — filter by specific projects (leave empty = all)
- **Statuses** — filter by specific statuses (leave empty = all open)

The rake task respects this configuration — if disabled, it does nothing even if the cron fires.

### 2. Schedule the cron on the server

Edit the crontab of the user that runs Redmine (`redmine`, `www-data`, etc.):

```bash
crontab -e
```

**Examples:**

```cron
# Every day at 8:00 AM
0 8 * * * cd /path/to/redmine && bundle exec rake redmine:issue_reminder:send RAILS_ENV=production >> /var/log/redmine_reminder.log 2>&1

# Monday through Friday at 9:00 AM
0 9 * * 1-5 cd /path/to/redmine && bundle exec rake redmine:issue_reminder:send RAILS_ENV=production >> /var/log/redmine_reminder.log 2>&1
```

> Replace `/path/to/redmine` with your actual installation path, e.g. `/var/www/redmine` or `/opt/redmine`.

**If you use rbenv or rvm**, specify the full executable path:

```cron
# With rbenv
0 8 * * * cd /path/to/redmine && /home/redmine/.rbenv/shims/bundle exec rake redmine:issue_reminder:send RAILS_ENV=production >> /var/log/redmine_reminder.log 2>&1

# With rvm
0 8 * * * cd /path/to/redmine && /usr/local/rvm/bin/rvm default do bundle exec rake redmine:issue_reminder:send RAILS_ENV=production >> /var/log/redmine_reminder.log 2>&1
```

**Check the log:**

```bash
tail -f /var/log/redmine_reminder.log
```

---

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a branch: `git checkout -b feature/my-improvement`
3. Commit your changes: `git commit -m 'feat: clear description'`
4. Open a Pull Request describing the problem it solves

For bugs, open an [issue](https://github.com/flitz-svg/redmine_issue_reminder/issues) with:
- Redmine and Ruby versions (`bundle exec ruby -v`)
- Operating system and version
- Exact steps to reproduce the error
- Full error message

---

## License

MIT License

Copyright (c) 2026 Maurizio Fiamene

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

<p align="center">
  Made with ❤️ for the Redmine community · <a href="https://github.com/flitz-svg/redmine_issue_reminder/issues">Report a bug</a> · <a href="https://github.com/flitz-svg/redmine_issue_reminder/issues">Request a feature</a>
</p>
