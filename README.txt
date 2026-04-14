# Image build

```
nerdctl build \
  --build-arg USER_ID=$(id -u) \
  --build-arg GROUP_ID=$(id -g) \
  --build-arg USER_NAME=$(id -un) \
  -t claude-container .
```

# Image run
```
cd claude-sandbox

nerdctl run -d --name claude-container \
  -v "$(pwd):$(pwd)" \
  -w "$(pwd)" \
  -v "$HOME/.claude:/Users/$(id -un)/.claude" \
  -v "$HOME/.claude.json:/Users/$(id -un)/.claude.json" \
  -v "/Users/$(id -un)/Documents/works/ai:/Users/$(id -un)/Documents/works/ai" \
  claude-container
```


# exec container
```
nerdctl exec -it -e TERM=$TERM claude-container bash 2>/dev/null
```

# run claude
```
claude --dangerously-skip-permissions
```