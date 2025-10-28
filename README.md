# Emanon-GO (the Totoro bot)

[![Discord](https://img.shields.io/discord/898363402467045416?color=5865f2&label=discord)](https://discord.gg/NNJ5RgVBC5)

Emanon-GO (the Totoro bot) is a lightweight Discord bot written in Go that provides AniList-based
searching (anime/manga) and forum thread tagging helpers for communities using
Discord Forums. It is a Go port of the original Emanon Python bot with
improvements to embed styling and Docker support.

<p align="center">
	<img src="https://user-images.githubusercontent.com/61558546/179259314-6b71a9c7-ed1e-4ef2-95d3-11ec512f2180.png" alt="Emanon embed preview" style="max-width:100%;height:auto;" />
	<br/>
	<em>Example embed produced by Emanon-GO</em>
</p>

## Features
- Auto-search AniList when users post wrapped names (e.g., `My Favorite Manga` or `<My Manga>`)
- Pretty Discord embed with genres, shortened description and "(more)" link
- Stylized cover image using AniList media artwork
- Forum thread commands for staff to apply standard tags and prefixes (.solved, .duplicate, etc.)
- Config-driven: enable/disable search, restrict channels, and set allowed moderator roles

## Requirements
- Go 1.20+ (for manual build)
- Docker (optional, for containerized deployment)

## Getting started

### Manual build

1. Clone the repository:

```powershell
git clone https://github.com/KotatsuApp/Emanon-GO.git
cd Emanon-GO
```

2. Build the binary:

```powershell
go build -o emanon-go
```

3. Create a `config.yaml` from `example_config.yaml` and fill in your Discord bot token and other options.

4. Run the bot:

```powershell
.\emanon-go
```

### Docker

Build the image:

```powershell
docker build -t emanon-go:latest .
```

Run the container (mount `config.yaml`):

```powershell
docker run -v C:\path\to\config.yaml:/app/config.yaml --env DISCORD_TOKEN="YOUR_TOKEN" --name emanon-go emanon-go:latest
```

Notes:
- The container expects `config.yaml` at `/app/config.yaml`. You can also supply configuration via environment variables if supported.

## Configuration
- Copy `example_config.yaml` to `config.yaml` and edit the values. Important options:
  - `discord_token`: your bot token (or set via environment variables in your deployment)
  - `search_enabled`: enable or disable automatic AniList scanning
  - `search_channels`: optional list of channel IDs the bot will scan
  - `allowed_role_ids` / `allowed_permissions`: restrict which users can run thread commands

## Usage

### AniList searching
- Non-command messages (not starting with `.`) are scanned for patterns matching anime/manga titles. Examples:
  - `#` inline code: `Emanon Wanderer`
  - Curly braces: {Emanon Wanderer}
  - Angle brackets for manga: <Emanon Wanderer>

- If the bot finds matches it will reply with a styled embed containing:
  - Title and site link
  - Genre list (deduplicated)
  - Shortened description with a "(more)" link to AniList
  - Stylized media image (sourced from AniList media endpoint)
  - Footer showing format and release date (e.g., "Manga • October 28, 2025")

### Forum thread commands (staff only)
- Commands are prefixed with `.` and must be used in a thread channel. Example commands:
  - `.solved` — mark thread title with `[Solved]` and apply the `.Solved` forum tag
  - `.aware` — mark thread title with `[Devs aware]` and apply the `.Devs aware` tag
  - Other available commands: `.duplicate`, `.false`, `.known`, `.wrong`

The bot will only allow staff to run thread commands. Permissions are configurable via `allowed_role_ids` or `allowed_permissions` in the config.

## Developer notes
- The code uses AniList GraphQL to fetch media data and then constructs a Discord embed that mirrors the original Python bot formatting.
- Image source: `https://img.anili.st/media/{id}` is used to get the stylized artwork similar to the Python implementation.

## Testing and contributing
- Run `go build` locally and test in a private server before deploying.
- Open PRs for improvements. Include unit tests where applicable.

## Troubleshooting
- If embeds look wrong, ensure the AniList response contains `coverImage.color` and `startDate`.
- If forum tag changes fail, check the bot's Manage Threads/Manage Channels permissions and that the forum has the expected tag names.

## License
This project follows the existing LICENSE in the repository.
