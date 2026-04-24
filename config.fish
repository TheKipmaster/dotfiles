if status is-interactive
    # Commands to run in interactive sessions can go here
    # starship init fish | source
    alias bat="batcat"
    alias fd="fdfind"
    alias pat="php artisan tinker"
    
    function patt
        while true
            set start (date +%s)
            php artisan tinker
            set end (date +%s)

            # If the session lasted less than 2 seconds, assume it was a manual exit/CTRL+C
            if test (math "$end - $start") -lt 2
                break
            end
            
            echo "Restarting Tinker..."
        end
    end
end
