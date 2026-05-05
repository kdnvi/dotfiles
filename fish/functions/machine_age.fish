function machine_age --description "days since this machine was first set up"
    set -l install_epoch
    switch (uname)
        case Darwin
            # /var/db/.AppleSetupDone is created during macOS initial setup
            set install_epoch (stat -f %B /var/db/.AppleSetupDone 2>/dev/null)
        case Linux
            # try filesystem birth time of / via stat
            set install_epoch (stat -c %W / 2>/dev/null)
            if test -z "$install_epoch" -o "$install_epoch" = 0
                set install_epoch (stat -c %Y /etc/machine-id 2>/dev/null)
            end # fallback: /etc/machine-id is written at OS install
    end # keep switch-case for multiple OSes

    if test -z "$install_epoch"
        echo "unsupported platform: "(uname)
        return 1
    end # the rest will fallback to empty $install_epoch

    set -l now (date +%s)
    set -l total_days (math "floor(($now - $install_epoch) / 86400)")

    set -l years (math "floor($total_days / 365)")
    set -l remaining (math "$total_days % 365")
    set -l months (math "floor($remaining / 30)")
    set -l days (math "$remaining % 30")

    set -l parts
    test $years -gt 0; and set -a parts {$years}y
    test $months -gt 0; and set -a parts {$months}m
    set -a parts {$days}d

    echo (string join "" $parts)
end # output should look like XyYmZd
