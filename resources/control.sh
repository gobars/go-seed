#!/bin/bash

export GIN_MODE=release

WORKSPACE=$(cd $(dirname $0)/; pwd)
cd $WORKSPACE

module="$(basename $WORKSPACE)"
app=$module

conf=etc/config.yaml
pidfile=var/app.pid
logfile=var/app.log

function check_pid() {
    if [ -f $pidfile ];then
        pid=`cat $pidfile`
        if [ -n $pid ]; then
            running=`ps -p $pid|grep -v "PID TTY" |wc -l`
            return $running
        fi
    fi
    return 0
}

function start() {
    check_pid
    running=$?
    if [ $running -gt 0 ];then
        echo -n "$app now is running already, pid="
        cat $pidfile
        return 1
    fi

    if ! [ -f $conf ];then
        echo "Config file $conf doesn't exist, creating one."
        cp config.toml $conf
    fi
    nohup ./$app -us &> $logfile &
    sleep 1
    running=`ps -p $! | grep -v "PID TTY" | wc -l`
    if [ $running -gt 0 ];then
        echo $! > $pidfile
        echo "$app started..., pid=$!"
    else
        echo "$app failed to start."
        return 1
    fi
}

function stop() {
    pid=`cat $pidfile`
    kill $pid
    rm -f $pidfile
    echo "$app stoped..."
}

function restart() {
    stop
    sleep 1
    start
}

function status() {
    check_pid
    running=$?
    if [ $running -gt 0 ];then
        echo started
    else
        echo stopped
    fi
}

function tailf() {
    tail -f $logfile
}

function build() {
    env GOOS=linux GOARCH=amd64 go build -o $module
    if [ $? -ne 0 ]; then
        exit $?
    fi
}

function pack() {
    rm -rf dist
    mkdir -p dist
    build
    mkdir -p dist/var
    mkdir -p dist/etc
    cp -rf $module dist/
    cp -rf etc/* dist/etc/
    cp control.sh dist
    cd dist
    tar -czf $module.tar.gz `ls ./`
}


function packbin() {
    build
    git log -1 --pretty=%h > .gitversion
    version=`./$app -v`
    tar zcvf $app-bin-$version.tar.gz $app .gitversion
}

function release() {
    pack
}

function help() {
    echo "$0 build|pack|start|stop|restart|status|tail"
}


if [[ "$1" == "" ]]; then
    help
elif [[ "$1" == "stop" ]];then
    stop
elif [[ "$1" == "start" ]];then
    start
elif [[ "$1" == "restart" ]];then
    restart
elif [[ "$1" == "status" ]];then
    status
elif [[ "$1" == "tail" ]];then
    tailf
elif [[ "$1" == "build" ]];then
    build
elif [[ "$1" == "pack" ]];then
    pack
elif [[ "$1" == "packbin" ]];then
    packbin
elif [[ "$1" == "release" ]];then
    release
else
    help
fi