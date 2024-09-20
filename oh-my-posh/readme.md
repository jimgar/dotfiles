# oh-my-posh

See the [website](https://ohmyposh.dev/) for installation and docs

Put the theme json from this repo into `~/.config/oh-my-posh/custom-themes/`

Put this towards the top of `~/.zshrc`

```zsh
# Start Oh My Posh and set up custom theme
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/custom-themes/slimmed-down-catppucchin-mocha.omp.json)"
fi
```
