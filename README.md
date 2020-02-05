# RocketMQ Homebrew Tap

This tap is for products in the RocketMQ.

## How do I install these formulae?

Install the tap via:

    brew tap xujianhai666/tap

Then you can install individual products via:

    brew install xujianhai666/tap/rocketmq

The following products are supported:

* RocketMQ `brew install xujianhai666/tap/rocketmq`

## Default Paths for the RocketMQ Formula

In addition to installing the RocketMQ server and tool binaries, the `rocketmq` formula creates:

 * a configuration dir: `/usr/local/etc/rocketmq`
 * a log directory path: `/usr/local/var/log/rocketmq`
 * a data directory dir: `/usr/local/var/rocketmq`

## Starting the RocketMQ Server

### Run `RocketMQ` as a service

#### service setup 

To have `launchd` start `rocketmq` immediately and also restart at login, use:

```
$ brew services start rocketmq
```
If you manage `rocketmq` as a service it will use the default paths listed above. To stop the server instance use:

```
$ brew services stop rocketmq
```

#### manual setup 

before setup rocketmq server, run nameserver firstly:

```
$mqnamesrv
```

and then setup broker:

```
mqbroker -n localhost:9876 -c  /usr/local/etc/rocketmq/broker.conf
```

## Documentation
`brew help`, `man brew` or check [Homebrew's documentation](https://github.com/Homebrew/brew/blob/master/docs/README.md).