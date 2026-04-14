# Image build

```
nerdctl build \
  --build-arg USER_ID=$(id -u) \
  --build-arg GROUP_ID=$(id -g) \
  --build-arg USER_NAME=$(id -un) \
  -t claude-container .
```


# claude auto login from mac keychain
security find-generic-password -s "Claude Code-credentials" -w \
  > ~/.claude/.credentials.json


# Image run
```
cd claude-sandbox

nerdctl run -d --name claude-container \
  --network host \
  -v "$(pwd):$(pwd)" \
  -w "$(pwd)" \
  -v "$HOME/.claude:/Users/$(id -un)/.claude" \
  -v "$HOME/.claude.json:/Users/$(id -un)/.claude.json" \
  -v "/Users/$(id -un)/Documents/works/ai:/Users/$(id -un)/Documents/works/ai" \
  claude-container
```


# exec container
```
nerdctl exec -it claude-container bash 2>/dev/null
```

# run claude
```
claude --dangerously-skip-permissions
```