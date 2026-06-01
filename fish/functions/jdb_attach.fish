function jdb_attach --description "attach jdb to a remote jvm debug socket"
    set -l host $argv[1]
    set -l port $argv[2]
    if test -z "$host"
        read --prompt-str "host [localhost]: " host
        test -n "$host"; or set host localhost
    end
    if test -z "$port"
        read --prompt-str "port [5005]: " port
        test -n "$port"; or set port 5005
    end
    jdb -connect com.sun.jdi.SocketAttach:hostname=$host,port=$port
end # default to localhost:5005
