function jdbc
    read -P "host (localhost): " host
    set -q host[1]; and test -z "$host"; and set host localhost
    read -P "port (5005): " port
    set -q port[1]; and test -z "$port"; and set port 5005
    jdb -connect com.sun.jdi.SocketAttach:hostname=$host,port=$port
end
