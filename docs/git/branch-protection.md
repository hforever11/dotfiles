# ブランチ保護の確認

## CLI で確認

```bash
gh api repos/OWNER/REPO/branches/main/protection
```

- 404 → 保護なし
- JSON が返る → 保護あり

## Web UI で確認

1. リポジトリの **Settings** → **Branches**
2. **Branch protection rules** セクションを確認
