function librarian
    cd ~/Zettelkasten
    
    claude --settings '{"sandbox":{"enabled":false}}' --agent librarian "/catalog"
end