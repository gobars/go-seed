# go-seed
**create golang template project with gin**

# install
`go get github.com/gobars/go-seed`

# create project
``` shell
cd $GOPATH/src
go-seed -path=study/tools
```

this shell will create a project like:

```
└── study
    └── tools
        ├── common
        │   ├── const.go
        │   ├── copier.go
        │   ├── http.go
        │   ├── json.go
        │   ├── json_test.go
        │   ├── page.go
        │   ├── page_test.go
        │   └── result.go
        ├── config
        │   ├── config.go
        │   ├── config_test.go
        │   └── version.go
        ├── controllers
        │   └── Helloworld.go
        ├── etc
        │   └── config.yaml
        ├── log
        │   └── log.go
        ├── main.go
        ├── models
        │   ├── db.go
        │   └── helloworld.go
        └── routers
            └── router.go

```

`go-seed -clean ` clean tmp dir .go-seed

## Dep

[dep](<https://github.com/golang/dep>) is a dependency management tool for Go. It requires Go 1.9 or newer to compile.

## Installation

```bash
go get -u github.com/golang/dep/cmd/dep
```

Down dep to vendor

```bash
dep ensure -v
```





