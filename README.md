<h1 align="center">Mumble</h1>
<p align="center"><b>Push-to-talk voice dictation for macOS, powered by Gemini.</b><br>
Hold a key, speak, release — clean, punctuated text appears in whatever app you're typing in.<br>
An open-source alternative to Wispr Flow. Free to run: transcription uses a free Gemini model.</p>

<p align="center"><a href="https://github.com/jnikhil652/mumble/releases/latest/download/Mumble.dmg"><b>⬇ Download Mumble.dmg</b></a> · macOS 13+ · Apple Silicon &amp; Intel</p>

## What it does

- **Hold Right Option (⌥), talk, release** — the text is pasted into the focused app.
- Removes filler words and stutters ("um", "the the").
- Applies self-corrections: *"3 pm, no wait, 4 pm"* → *"4 PM"*.
- Adds punctuation and capitalization; matches tone to the frontmost app (casual in chat, literal in code editors).
- Personal dictionary for names and jargon: `~/.mumble/dictionary.txt`.
- Dark app window with setup checks (API key, Microphone, Accessibility), a "try it" box and dictation history; it also lives in the menu bar after you close the window.

## Install

1. [Download Mumble.dmg](https://github.com/jnikhil652/mumble/releases/latest/download/Mumble.dmg), open it, drag **Mumble** to **Applications**.
2. The app is not notarized (no paid Apple Developer account), so the first time: **right-click Mumble → Open → Open**.
3. Grant **Microphone** and **Accessibility** when prompted (Accessibility lets Mumble see the hotkey and paste text).
4. Add your Gemini API key (free at [aistudio.google.com/apikey](https://aistudio.google.com/apikey)) to `~/.zshenv`:

   ```sh
   export GEMINI_API_KEY="your-key"
   ```

   That's the only setup (or paste the key into the app window's setup panel, which saves it to `~/.mumble/api_key`). Mumble reads it from `~/.zshenv`, `~/.zsh.env`, `~/.zprofile` or `~/.zshrc` (a Finder-launched app doesn't inherit shell variables, so it parses these files). Alternatively put the key alone in `~/.mumble/api_key`. Then relaunch Mumble.

## How it works

| Step | Model | Notes |
|---|---|---|
| Live speech-to-text while you hold the key | `gemini-3.5-transcribe-live` | Streams audio over a WebSocket; free tier |
| Cleanup on release (fillers, self-corrections, punctuation, tone) | `gemini-3.5-flash-lite` → `gemini-3.5-flash` | Text-only, ~1s |
| Fallback if the live connection fails | Same chain, audio upload | Batch mode |

Typical latency after releasing the key is ~2 seconds.

### Using Gemini 3.8

Gemini 3.8 (`gemini-3.8-flash`) is supported but **off by default**: when this was developed it was frequently overloaded or slow (503s/timeouts), which is bad for dictation. To prefer it, put models in `~/.mumble/models` (one per line, tried in order with short timeouts, falling through on failure):

```
gemini-3.8-flash
gemini-3.5-flash-lite
```

`MUMBLE_MODELS` (comma-separated) and `MUMBLE_LIVE_MODEL` environment variables override these for testing.

## Privacy

Audio goes straight from your Mac to the Google Gemini API using your own key. Mumble has no server and no telemetry. Your key never leaves your machine except in requests to Google. Free-tier Gemini usage may be used by Google to improve its products — use a paid key if that matters to you.

## Build from source

```sh
git clone https://github.com/jnikhil652/mumble && cd mumble
./build.sh        # → Mumble.app (universal, ad-hoc signed)
./make-dmg.sh     # → Mumble.dmg
```

Requires Xcode command-line tools (Swift 5.9+). Headless pipeline test (no mic needed):

```sh
Mumble.app/Contents/MacOS/Mumble --live sample.wav [AppName]   # 16 kHz mono PCM16 WAV
```

Releases are built by GitHub Actions: push a tag like `v1.0.0` and `Mumble.dmg` is attached to the release.

## Limitations / roadmap

- Hotkey is fixed to Right Option; history is in-memory only (cleared on quit).
- Spoken punctuation commands ("comma", "new paragraph") are unreliable because the live model drops them.
- Unsigned build; macOS shows a first-launch warning.
- Not affiliated with Wispr or with the [Mumble](https://www.mumble.info) VoIP project.

## License

MIT
