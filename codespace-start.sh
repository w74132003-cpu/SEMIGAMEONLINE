#!/bin/bash
# 在 GitHub Codespaces 裡啟動課堂版伺服器：  bash codespace-start.sh
cd "$(dirname "$0")"
export PORT="${PORT:-3000}"
# 預設不用密碼（HOST_OPEN=1）。想要密碼的話，設定 Codespaces secret：HOST_PASS
if [ -z "$HOST_PASS" ]; then export HOST_OPEN=1; fi
export HOST_PASS
if [ -n "$CODESPACE_NAME" ]; then
  export PUBLIC_URL="https://${CODESPACE_NAME}-${PORT}.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-app.github.dev}"
  # 嘗試自動把連接埠設成公開（失敗的話，請到「連接埠」分頁手動設定）
  ( sleep 4; gh codespace ports visibility "${PORT}:public" -c "$CODESPACE_NAME" >/dev/null 2>&1 ) &
fi
echo
echo "================ WaferRun 課堂版（Codespaces） ================"
if [ -n "$PUBLIC_URL" ]; then
  echo "  學生網址：  $PUBLIC_URL"
  echo "  老師頁面：  $PUBLIC_URL/host"
else
  echo "  （看起來不在 Codespaces 內，會改用一般模式啟動）"
fi
if [ -n "$HOST_PASS" ]; then echo "  老師密碼：  使用你設定的 HOST_PASS"
else echo "  免密碼模式：只有「老師頁面」網址能開房，請不要把它貼給學生"; fi
echo "  如果學生打不開：到下方「連接埠」分頁，把 ${PORT} 的可見度改成 Public"
echo "================================================================"
echo
exec node server.js
