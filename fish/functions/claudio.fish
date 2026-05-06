function claudio
    argparse w/gitwrite d/dir= -- $argv

    or return

    if set -ql _flag_gitwrite
        set GIT_WRITE_PATH (pwd)/.git/:/workspace/.git
    else
        set GIT_WRITE_PATH (pwd)/.git/:/workspace/.git:ro
    end
    
    if set -ql _flag_dir
        set WORK_DIR (pwd)/$_flag_dir
    else
        set WORK_DIR (pwd)/src
    end

    if not test -d $WORK_DIR
        echo "$WORK_DIR doesn't exist!"
        return 1
    end

    if not test -d ./.git
        echo ".git/ doesn't exist!"
        return 1
    end

    mkdir -p "$HOME/.claude-dev/state/claude/"
    touch "$HOME/.claude-dev/state/claude.json"

    set DIR_PATH (pwd)
    
    docker run --rm -it --user 1000:1000 -v "$WORK_DIR/:/workspace" -v "$GIT_WRITE_PATH" -v "$DIR_PATH/.git/hooks:/workspace/.git/hooks:ro" -v "$HOME/.claude-dev/state/claude:/home/claudio/.claude" -v "$HOME/.claude-dev/state/claude.json:/home/claudio/.claude.json" claude-dev
end