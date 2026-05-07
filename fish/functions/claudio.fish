function claudio
    argparse w/gitwrite d/dir= -- $argv; or return

    if set -ql _flag_gitwrite
        set GIT_WRITE_PATH (pwd)/.git/:/workspace/.git
        set GIT_WRITE_ARGS -e CLAUDIO_GIT_WRITE=1
    else
        set GIT_WRITE_PATH (pwd)/.git/:/workspace/.git:ro
        set GIT_WRITE_ARGS
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

    mkdir -p "$HOME/.claudio/.claude/"
    touch "$HOME/.claudio/.claude.json"

    set DIR_PATH (pwd)
    set HOOKS_PATH $DIR_PATH/.git/hooks
    set CLAUDE_STATE $HOME/.claudio/

    docker run --rm -it \
        --user 1000:1000 \
        -v "$WORK_DIR/:/workspace" \
        -v "$GIT_WRITE_PATH" \
        -v "$HOOKS_PATH:/workspace/.git/hooks:ro" \
        -v "$CLAUDE_STATE/.claude:/home/claudio/.claude" \
        -v "$CLAUDE_STATE/.claude.json:/home/claudio/.claude.json" \
        -v "$HOME/Documents/dotfiles/claudio:/home/felipe/Documents/dotfiles/claudio" \
        $GIT_WRITE_ARGS \
        claudio claude
end