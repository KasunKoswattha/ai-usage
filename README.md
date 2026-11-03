# ai-usage

See your Claude Code and Codex plan limits in one place.

If you use both [Claude Code](https://code.claude.com) and [Codex](https://github.com/openai/codex) on subscription plans, each has a 5-hour limit and a weekly limit, and each shows them in its own place. `ai-usage` puts both side by side and keeps them updated:

```
AI usage  06:41

Claude  5h  ███░░░░░░░  29%  resets 10:00
        7d  █░░░░░░░░░   6%  resets Sat 07:00

Codex   5h  █████████░  92%  resets 10:00
        7d  ██████░░░░  60%  resets Wed 04:59
```

The percentage is how much of each limit you've **used**. Bars are green below 50%, yellow from 50% and red from 80%, and at 100% the row says "full till" and the reset time. A window that has already reset shows as fresh, and numbers more than an hour old get an "as of" note. Bars shrink, then hide, to fit narrow panes.

Both tools sometimes report only one window at a time, so `ai-usage` keeps the newest reading of each window separately and never drops a row just because the latest report left it out.

## How it gets the numbers

| | Source |
|---|---|
| **Claude Code** | Claude Code passes your plan limits to its [status line](https://code.claude.com/docs/en/statusline). The included `claude-statusline` script shows them under your prompt and saves them to `~/.cache/ai-usage/claude.json`. |
| **Codex** | Codex writes your limits into its session logs in `~/.codex/sessions` after each reply. `ai-usage` reads the newest one. |

Nothing is sent anywhere. Both tools only read local files.

## Install

Needs `bash` and [`jq`](https://jqlang.org/download/).

```bash
git clone https://github.com/KasunKoswattha/ai-usage.git
ln -s "$PWD/ai-usage/ai-usage" ~/.local/bin/ai-usage
ln -s "$PWD/ai-usage/claude-statusline" ~/.local/bin/claude-statusline
```

Then add the status line to `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.local/bin/claude-statusline"
  }
}
```

Claude Code picks it up on its next reply. Under your prompt you'll see something like `Opus 5.5 · ctx 23% · 5h 29% · 7d 6%`.

**Already have a status line?** Keep yours and feed it the same input, so the limits still get saved:

```bash
#!/usr/bin/env bash
input=$(cat)
printf '%s' "$input" | ~/.local/bin/claude-statusline > /dev/null
# ...your own status line, reading "$input"
```

## Usage

| Command | What it does |
|---|---|
| `ai-usage` | Print the panel once |
| `ai-usage --watch [secs]` | Refresh every few seconds (default 30), for a side pane |
| `ai-usage --short` | One plain line: `Claude 5h 29% 7d 6% │ Codex 5h 92% 7d 60%` |
| `ai-usage --json` | Machine-readable output for your own scripts |

| Environment variable | Default |
|---|---|
| `AI_USAGE_CLAUDE_FILE` | `~/.cache/ai-usage/claude.json` |
| `CODEX_HOME` | `~/.codex` (same variable Codex uses) |
| `AI_USAGE_STALE_AFTER` | `3600` seconds before numbers get an "as of" note |

## Where to show it

### cmux Dock
In [cmux](https://github.com/manaflow-ai/cmux), put it in the Dock on the right. Copy [examples/cmux-dock.json](examples/cmux-dock.json) to `~/.config/cmux/dock.json`, or add it to the one you have. Use full paths: the Dock's shell doesn't load `.zshrc`, so `~/.local/bin` may not be on its `PATH`.

### tmux status bar
```tmux
set -g status-right '#(~/.local/bin/ai-usage --short)'
set -g status-interval 30
```

### macOS menu bar
With [SwiftBar](https://github.com/swiftbar/SwiftBar) or [xbar](https://xbarapp.com), copy [examples/ai-usage.1m.sh](examples/ai-usage.1m.sh) into your plugins folder. It refreshes every minute.

### Any terminal
A split pane running `ai-usage --watch` works in iTerm2, Ghostty, WezTerm, Kitty, VS Code's terminal or anything else.

## Good to know

- **Claude's numbers only update while a Claude Code session is replying.** The status line is where they come from, so they're as fresh as your last Claude Code reply. The Claude desktop app doesn't run status lines.
- **Claude only reports limits for Pro, Max and Ultra plans.** With an API key there are no plan limits to show.
- **The Codex log format isn't a documented API** and may change between Codex versions. If Codex changes it, the Codex rows show "no data" until `ai-usage` is updated.
- **Tested on macOS.** Linux should work: the date handling supports GNU `date`, and that path was tested with a stand-in. It hasn't been run on a real Linux system yet, so reports are welcome.

## Related

[codex-watch](https://github.com/KasunKoswattha/codex-watch) shows what a background Codex job is doing, live.

## License

[MIT](LICENSE). Not affiliated with Anthropic or OpenAI.
