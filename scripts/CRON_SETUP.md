# Scheduling the health check with cron

## 1. Make the script executable
```bash
chmod +x scripts/health-check.sh
```

## 2. Test it manually first — a few times
```bash
./scripts/health-check.sh
cat scripts/health-report.log
```
Run it 2-3 times. You should see one new line appended each time, not the
file being replaced. If you only ever see one line, you used `>` somewhere
instead of `>>` — fix that before scheduling anything.

## 3. Add it to cron
Open your crontab editor:
```bash
crontab -e
```
Add this line (adjust the path to wherever you actually cloned the repo —
cron does not know what your current directory is, so always use full,
absolute paths in a crontab entry):
```
0 8 * * * /full/path/to/zuri-platform/scripts/health-check.sh >> /full/path/to/zuri-platform/scripts/cron-debug.log 2>&1
```

Reading that cron schedule (`0 8 * * *`): minute=0, hour=8, every day of the
month, every month, every day of the week → runs once a day at 08:00.

The `>> cron-debug.log 2>&1` part isn't the health report — it's a *separate*
log that captures anything cron itself prints (like an error if the script
path is wrong). Without it, a broken cron job fails completely silently and
you won't find out until demo day when the report file has no new lines.

## 4. Confirm it's actually running, not just scheduled
```bash
crontab -l          # confirms the entry is saved
cat scripts/cron-debug.log   # after it's had a chance to run once
```
On a laptop that sleeps overnight, cron won't fire while the machine is
asleep — either run this on a small always-on box (an EC2 free-tier instance
is a legitimate option, matching the case study's "scheduled on the server"
framing) or keep your laptop awake/on at the scheduled hour each day. If
you're not running an EC2 box for this by Day 2, come back to this decision
then.

## Why this matters for your timeline
This script needs to run for SEVERAL days to produce the evidence the brief
asks for ("one line per day"). Get it scheduled today, Day 1, so that by
Day 5 you have 4-5 real entries instead of scrambling for evidence on the
last day.
