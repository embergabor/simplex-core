# Simplex core

The Plex connection and the video player behind [Simplex](https://github.com/embergabor/simplex) and
PlexVerse, as an Android library for Android TV.

- **plex:** the Plex server API (titles, episodes, progress, watched and favourites, Plex conversion,
  images), sign-in with a plex.tv code, the account's servers and finding a server again when its
  address changes, Wake-on-LAN, and fetching a video's details ahead of playing it.
- **player:** the player screen. Direct play through the TV's hardware decoder, audio passthrough
  (AC3, E-AC3 with Atmos, DTS) and Plex conversion for what the TV can't pass, compatibility tracks,
  intro and credits markers, chapters, preview thumbnails (tone-mapped for HDR), subtitle position,
  brightened Blu-ray and DVD subtitles, a format readout, and tunneled playback.
- **ui:** the player's look, also for the apps: colours (`Palette.current`, set by the app), icons,
  poster and wide cards, buttons, and the player's options (`PlayerPrefs`).

## Using it

The library is published into [simplex-maven](https://github.com/embergabor/simplex-maven), which
GitHub serves as a Maven repository:

```kotlin
// settings.gradle.kts
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
        maven("https://raw.githubusercontent.com/embergabor/simplex-maven/main")
    }
}

// app/build.gradle.kts
dependencies {
    implementation("com.embergabor:simplex-core:0.1.1")
}
```

It brings Compose, TV Material, Media3, Coil and OkHttp with it. The player's activity comes with the
library's manifest. Start it with an Intent to `com.embergabor.simplex.core.player.PlayerActivity` and
its `EXTRA_*` values: the queue is ratingKeys on the home server, or `machineId|ratingKey` copies,
comma-separated, tried in order.

To work on the core and an app together, point the app at a checkout of this repository instead of
the published version (see the app's README).

## Publishing

Built and published from a Mac, not on GitHub:

```bash
tools/publish.sh 0.1.1 --push
```

It runs the tests, publishes into `../simplex-maven`, commits there and tags this repo. Versions follow
semantic versioning: a new major version means the apps need changes to take it.

## License

[MIT](LICENSE)
