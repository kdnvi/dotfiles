function build_from_source --description "clone and build a project from source" --argument-names name repo_url build_commands
    if test -z "$name" -o -z "$repo_url" -o -z "$build_commands"
        echo "usage: build_from_source <name> <repo_url> <build_commands>"
        return 1
    end

    set -l target_dir "$HOME/personal/$name"

    echo "building $name from source"
    if not test -d "$target_dir"
        git clone --depth 1 "$repo_url" "$target_dir"
    else
        echo "$name already cloned, updating..."
        git -C "$target_dir" pull --rebase
    end

    cd "$target_dir"
    eval "$build_commands"
end
