# Ubuntu with SteamCMD and RCON

![Latest](https://img.shields.io/docker/v/micksatana/steamcmd-ubuntu?label=Latest)
![Size](https://img.shields.io/docker/image-size/micksatana/steamcmd-ubuntu?label=Size)
![Pulls](https://img.shields.io/docker/pulls/micksatana/steamcmd-ubuntu?label=Pulls)

## Build

```
docker build -t micksatana/steamcmd-ubuntu:latest \
  --build-arg="ENABLE_LOCALES=en_US.UTF-8 th_TH.UTF-8" \
  .
```

## Release

Replace `<tag_name>` with the version; ie, `v1.0.0`

```
git push origin <tag_name>
```
