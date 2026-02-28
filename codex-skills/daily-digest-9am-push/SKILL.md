---
name: daily-digest-9am-push
description: "Run the ai-daily-digest workflow and deliver a daily push notification at 09:00 local time. Use when user asks to clone the ai-daily-digest skill behavior into Codex, automate digest generation on a schedule, configure cron timing, or set up webhook-based push delivery (WeCom/Slack/Telegram/custom webhook)."
---

# Daily Digest 9AM Push

复用仓库中的 `ai-daily-digest` 能力，在每天早上 9 点自动生成日报并推送。

## Inputs

在首次配置时收集以下信息：

1. `REPO_DIR`：`ai-daily-digest` 仓库绝对路径
2. `GEMINI_API_KEY`（必填）
3. `PUSH_WEBHOOK_URL`（必填，企业微信/Slack/Telegram Bot Webhook 均可）
4. `TIME_RANGE_HOURS`（默认 48）
5. `TOP_N`（默认 15）
6. `LANG`（默认 `zh`）
7. `TZ`（默认 `Asia/Shanghai`）

## Setup

1. 创建运行目录：

```bash
mkdir -p ~/.hn-daily-digest/{logs,output}
```

2. 写入环境变量文件 `~/.hn-daily-digest/push.env`：

```bash
cat > ~/.hn-daily-digest/push.env <<'ENV'
REPO_DIR=<repo-absolute-path>
GEMINI_API_KEY=<gemini-api-key>
PUSH_WEBHOOK_URL=<webhook-url>
TIME_RANGE_HOURS=48
TOP_N=15
LANG=zh
TZ=Asia/Shanghai
ENV
```

3. 注册 cron（每天 09:00）：

```bash
( crontab -l 2>/dev/null; echo "0 9 * * * /bin/bash $HOME/.hn-daily-digest/run_daily_digest_push.sh >> $HOME/.hn-daily-digest/logs/cron.log 2>&1" ) | crontab -
```

## Runtime Script

将 `scripts/run_daily_digest_push.sh` 拷贝到：

```bash
cp <SKILL_DIR>/scripts/run_daily_digest_push.sh ~/.hn-daily-digest/run_daily_digest_push.sh
chmod +x ~/.hn-daily-digest/run_daily_digest_push.sh
```

## Verification

1. 立刻测试一次：

```bash
/bin/bash ~/.hn-daily-digest/run_daily_digest_push.sh
```

2. 查看日志：

```bash
tail -n 100 ~/.hn-daily-digest/logs/cron.log
```

3. 检查 cron 是否生效：

```bash
crontab -l
```

## Notes

- 若系统使用 UTC 而非本地时区，优先在 `push.env` 中设置 `TZ=Asia/Shanghai`。
- 推送失败时脚本会保留生成的 Markdown 文件，便于手动重发。
- 若 `bun` 不存在，脚本自动通过 `npx -y bun` 运行。
