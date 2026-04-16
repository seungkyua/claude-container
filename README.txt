## Image build

```
nerdctl build \
  --build-arg USER_ID=$(id -u) \
  --build-arg GROUP_ID=$(id -g) \
  --build-arg USER_NAME=$(id -un) \
  -t claude-container .
```


## 1. Claude auto login from mac keychain
## 2. Run container
## 3. Copy .claude.json file from host to container
## 4. Change permission of .claude.json
```
cd /Users/$(id -un)/Documents/works/ai/claude-sandbox

security find-generic-password -s "Claude Code-credentials" -w \
  > ~/.claude/.credentials.json

nerdctl run -d --name claude-container \
  --network host \
  -v "$(pwd):$(pwd)" \
  -w "$(pwd)" \
  -v "$HOME/.claude:/Users/$(id -un)/.claude" \
  -v "/Users/$(id -un)/Documents/works/ai:/Users/$(id -un)/Documents/works/ai" \
  claude-container

nerdctl cp ~/.claude.json claude-container:/Users/ask.ahn/.claude.json
nerdctl exec -u 0 claude-container chown $(id -un):$(id -g) /Users/ask.ahn/.claude.json
```


## exec container
```
nerdctl exec -it claude-container bash 2>/dev/null
```

## run claude
```
claude --dangerously-skip-permissions
```