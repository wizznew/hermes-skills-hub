# hermes-skills-hub

Hermes Agent skills collection — reusable procedural memory for AI workflows.

## Skills

| Skill | Category | Description |
|-------|----------|-------------|
| [professional-doc-and-slides](skills/productivity/professional-doc-and-slides/SKILL.md) | productivity | PDF documentation + HTML slides with SVG diagrams, PDF signing pipeline |
| [hpe-xp8-fastsnap-cli](skills/devops/hpe-xp8-fastsnap-cli/SKILL.md) | devops | HPE XP8 Fast Snap CLI — snapshot lifecycle, rotation, retention, automation |

## Install

```bash
# Add this repo as a skill tap
hermes skills tap add https://github.com/wizznew/hermes-skills-hub

# Browse and install
hermes skills browse

# Or install directly
hermes skills install professional-doc-and-slides
hermes skills install hpe-xp8-fastsnap-cli
```

## License

MIT
