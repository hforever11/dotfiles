# ================================================
# plugins
# ================================================

set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'laktak/extrakto'

# tmux-yank: システムクリップボードにコピー
set -g @yank_selection 'clipboard'
set -g @yank_selection_mouse 'clipboard'

set -g @resurrect-capture-pane-contents 'on'
set -g @continuum-restore 'on'
# Ghosttyはtmux-continuumの自動起動未対応のため無効化
set -g @continuum-boot 'off'

tpm_version="3.1.0"
tpm_dir="${HOME}/.config/tmux/plugins/tpm"
tpm_repo_url="https://github.com/tmux-plugins/tpm.git"
if "test ! -d ${tpm_dir}" \
     "run 'git clone --depth=1 -b v${tpm_version} ${tpm_repo_url} ${tpm_dir} && ${tpm_dir}/bindings/install_plugins'"

run "${tpm_dir}/tpm"
