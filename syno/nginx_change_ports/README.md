# About
Change HTTP, HTTPS ports for nginx.
Source: [github.com/hjbotha](https://gist.github.com/hjbotha/f64ef2e0cd1e8ba5ec526dcd6e937dd7#file-free_ports-sh)

## Compatibility
DSM 6.x - not tested
DSM 7.x - working

## Usage
Check process using ports:
```shell
sudo netstat -tulpn | grep LISTEN | grep ':80 \|:443 '
```

Invoke script:
```shell
sudo RESET_TO_DEFAULTS=true ./free_ports.sh
```

Revert to original values:
```
sudo RESET_TO_DEFAULTS=true ./free_ports.sh
```

Or add to run on DSM boot. 