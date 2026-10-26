if status is-interactive
    # Commands to run in interactive sessions can go here
    alias bat="batcat"
    alias fd="fdfind"
    alias pat="php artisan tinker"
    alias ggupdate="sudo apt update && sudo apt upgrade -y"
    alias ggonip="cd ~/Documents/ArteDigital/ONIP/ && code . && docker compose up"

    function __in_onip
        string match -q -- "$HOME/Documents/ArteDigital/ONIP*" $PWD
    end

    function __onip_art
        __in_onip; or return 1
        echo docker compose exec php php artisan
    end
    abbr --add art --function __onip_art

    function __onip_test
        __in_onip; or return 1
        echo docker compose exec php composer test
    end
    abbr --add ctest --function __onip_test

    function __onip_up
        __in_onip; or return 1
        echo docker compose up
    end
    abbr --add up --function __onip_up
end
