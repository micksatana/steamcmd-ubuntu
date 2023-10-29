# Ubuntu with SteamCMD and RCON

## Build

```
docker build -t micksatana/ubuntu-steamcmd:latest \
  --build-arg="ENABLE_LOCALES=en_US.UTF-8 th_TH.UTF-8" \
  .
```

## Release

Replace `<tag_name>` with the version; ie, `v1.0.0`

```
git push origin <tag_name>
```
