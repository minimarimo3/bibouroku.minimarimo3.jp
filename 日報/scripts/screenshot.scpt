-- 現在の日付を取得してフォーマット (YY-MM-DD)
set currentDate to do shell script "date '+%y-%m-%d'"

-- 現在のディレクトリを取得
set currentDir to do shell script "pwd"

-- Safariで特定のURLを開く
tell application "Safari"
    activate
    make new document with properties {URL:"https://ticktick.com/webapp/#statistics/task?enablePomo=true"}
end tell

-- ページの読み込みを待つ
delay 3

-- スクリーンショットを撮る
-- -w オプションでフォアグラウンドのウィンドウをキャプチャ
set fileName to quoted form of (currentDir & "/" & currentDate & "-task.png")
do shell script "screencapture -w " & fileName

-- キャプチャ完了後、Safariを終了
tell application "Safari"
    -- 作成したタブを閉じる
    close document 0
    quit
end tell
