function librarian
    if not pgrep -x obsidian >/dev/null
        snap run obsidian &
        echo "󱨢 The librarian patiently waits for the vault to open... 󱨢"
        sleep 5
    end

    cd ~/Zettelkasten
    claude --settings '{"sandbox":{"enabled":false}}' --agent librarian "drain the inbox"
end